//
//  NLLogController.m
//  NicoLiveAlert
//
//  Created by okey_dokey on 12/03/13.
//  Copyright (c) 2012年 okey_dokey_ All rights reserved.
//

#import "NLLogController.h"

@implementation NLLogController

- (void)dealloc
{
    [_messages release];
	[_urls release];
    [_timeStamps release];
    [super dealloc];
}

- (id)init
{
    if ((self = [super init])) {
        _messages = [[NSMutableArray alloc] initWithObjects:nil];
		_urls = [[NSMutableArray alloc] initWithObjects:nil];
        _timeStamps = [[NSMutableArray alloc] initWithObjects:nil];
    }
    return self;
}

- (void)addMessage:(NSString *)message {
	[self addMessage:message url:[NSURL URLWithString:@""]];
	
}

- (void)addMessage:(NSString *)message url:(NSURL *)url
{
	[_messages addObject:message];
	[_urls addObject:url];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH:mm:ss"];
	NSString *timeStamp = [formatter stringFromDate:[NSDate date]];
    [_timeStamps addObject:timeStamp];
	[formatter release];
}

/*** implement NSTableViewDataSource ***/
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [_messages count];
}

/*** implement NSTableViewDataSource ***/
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
	if ([tableColumn.identifier isEqualToString:@"message"]) {
        return [_messages objectAtIndex:rowIndex];
    } else {
        return [_timeStamps objectAtIndex:rowIndex];
    }
    return nil;
}

/*** implement  NSTableViewDelegate ***/
- (BOOL)tableView:(NSTableView *)tableView shouldTrackCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
   	NSString *urlString = [NSString stringWithFormat:@"%@",[_urls objectAtIndex:row]];
	if (![urlString isEqualToString:@""]) {
		NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
		[workspace openURL:[_urls objectAtIndex:row]];
	}	
	
	return YES;
}

@end

