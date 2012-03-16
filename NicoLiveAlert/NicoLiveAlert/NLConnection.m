//
//  NLConnection.m
//  NicoLiveAlert
//
//  Created by okey_dokey on 12/03/13.
//  Copyright (c) 2012年 okey_dokey All rights reserved.
//

#import "NLConnection.h"
#import "NLAuthentication.h"

@interface NLConnection()
- (void)prepareStickyAndCommunitiesWithCommunities:(NSDictionary *)communities;
- (void)connectSocketWithInfo:(NSDictionary *)info;
- (void)checkConnect:(NSTimer *)timer;
- (NSString *)stringFromInputStream:(NSInputStream *)inputStream;
- (BOOL)checkCommunity:(NSString *)community;
- (void)notifyProgramInfo:(NSDictionary *)programInfo;
@end


@implementation NLConnection

- (void)dealloc
{
    [_socket release];
    [_notification release];
    [_communities release];
    [super dealloc];
}

- (void)loginCommentServerForMail:(NSString *)mail pass:(NSString *)pass
{
    _notification = [[NLNotification alloc] init];	
    NSDictionary *userInfo = [NLAuthentication getUserInfoForMail:mail pass:pass];
    [self prepareStickyAndCommunitiesWithCommunities:[userInfo objectForKey:@"/getalertstatus/communities/community_id"]];
	_socket = [[NLSocket alloc] init];
	[self connectSocketWithInfo:userInfo];
    _connecting = YES;
}

- (void)prepareStickyAndCommunitiesWithCommunities:(NSDictionary *)communities
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *defaultCommunities = [NSMutableDictionary dictionary];
    
    for (NSString *community in communities) {
        [defaultCommunities setObject:@"YES" forKey:community];
    }
    [defaults registerDefaults:defaultCommunities];
    [defaults synchronize];
    
    for (NSString *community in communities) {
        if ([[defaults objectForKey:community] isEqualToString:@"YES"]) {
            [array addObject:community];
        }
    }
    _communities = [[NSArray alloc] initWithArray:array];
    _sticky = [defaults boolForKey:@"sticky"];
}

- (void)connectSocketWithInfo:(NSDictionary *)info
{
    NSString *hostName = [info objectForKey:@"/getalertstatus/ms/addr"];
	NSNumber *number = [info objectForKey:@"/getalertstatus/ms/port"];
	NSInteger port = [number integerValue];
	NSString *threadName = [info objectForKey:@"/getalertstatus/ms/thread"];
    [_socket connectToHostName:hostName port:port threadName:threadName delegate:self];
}

- (void)checkConnect:(NSTimer *)timer
{
	if (_connecting && !_ping) {
		NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"NO" forKey:@"connecting"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"status" object:self userInfo:dictionary];
		
	} else if(!_connecting && _ping) {
		NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"YES" forKey:@"connecting"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"status" object:self userInfo:dictionary];
	}
	_connecting = _ping;
    _ping = NO;
}

- (void)disconnect {
    [_socket disconnect];
}


/*** implement NSStreamDelegate ***/
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
	switch(eventCode) {
        case NSStreamEventOpenCompleted:
			if ([stream isKindOfClass:[NSInputStream class]]) {
				NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"YES" forKey:@"connecting"];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"status" object:self userInfo:dictionary];
				_connecting = _ping = YES;
			}
            break;
        
        case NSStreamEventHasBytesAvailable:
            if (!_ping) {
                _ping = YES;
            }
			NSString *string = [self stringFromInputStream:(NSInputStream *)stream];
            if (string == nil) {
                return;
            }
            
			NSArray *array = [string componentsSeparatedByString:@">"];
			array = [[array objectAtIndex:1] componentsSeparatedByString:@","];
			if ([array count] != 3)
				return;
            NSString *programId = [array objectAtIndex:0];
            NSString *communityId = [array objectAtIndex:1];
			
            if (![self checkCommunity:communityId]) {
                return;
            }
            
            NSDictionary *programInfo = [NLAuthentication getProgramInfoForName:programId];
            [self notifyProgramInfo:programInfo];
			
			break;
	}
}

- (NSString *)stringFromInputStream:(NSInputStream *)inputStream
{
    NSMutableData *data = [[NSMutableData alloc] init];
    uint8_t buf[1024];
    NSInteger len = 0;
    len = [inputStream read:buf maxLength:1024];
    
    if(len) {    
        [data appendBytes:(const void *)buf length:len];
    } else {
        [data release];
        return nil;
    }
    NSString *string = [[[NSString alloc] initWithData:data 
                                           encoding:NSUTF8StringEncoding] autorelease];
    return string;
}

- (BOOL)checkCommunity:(NSString *)community
{
    for (NSString *string in _communities) {
        if ([string isEqualToString:community] )  {
            return YES;
        }
    }
    return NO;
}

- (void)notifyProgramInfo:(NSDictionary *)programInfo
{
    NSString *programId = [programInfo objectForKey:@"/getstreaminfo/request_id"];
    NSString *communityName = [programInfo objectForKey:@"/getstreaminfo/communityinfo/name"];
    NSString *programTitle = [programInfo objectForKey:@"/getstreaminfo/streaminfo/title"];
    NSData *iconData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[programInfo objectForKey:@"/getstreaminfo/communityinfo/thumbnail"]]];
    
    [_notification growlNotificateTitle:communityName
                            description:programTitle 
                               iconData:iconData 
                               isSticky:_sticky
                           clickContext:programId];
    
    NSMutableDictionary *notifyDict = [NSMutableDictionary dictionary];
    [notifyDict setObject:communityName forKey:@"name"];
    [notifyDict setObject:programTitle forKey:@"title"];
    [notifyDict setObject:programId forKey:@"number"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"program" object:self userInfo:notifyDict];
}

@end
