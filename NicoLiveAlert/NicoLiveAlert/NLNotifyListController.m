//
//  NLNotifyListController.m
//  NicoLiveAlert
//
//  Created by okey_dokey on 12/03/15.
//  Copyright (c) 2012年 okey_dokey_ All rights reserved.
//

#import "NLNotifyListController.h"
#import "NLAuthentication.h"

@interface NLNotifyListController()
- (void)validSave;
- (NSArray *)getUsersCommunities;
- (void)clearData;
- (void)setNotifyList:(NSDictionary *)notifyList;
- (void)setSticky:(BOOL)sticky;
@end

@implementation NLNotifyListController 

@synthesize userCommunities = _userCommunities;

- (void)dealloc
{
    [_communities release];
	[_permission release];
    [super dealloc];
}

- (id)init
{
    if ((self = [super init])) {
        _communities = [[NSMutableArray alloc] initWithObjects:nil];
		_permission = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
}

- (void)awakeFromNib
{
    [_notifyTable setDataSource:self];
	[_notifyTable setDelegate:self];
	[self updateNotifyList:nil];
}

- (IBAction)pushStickButton:(id)sender
{
    _sticky = [sender state];
    [self validSave];
}

- (void)validSave
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (NSString *community in _permission) {
        if (![[defaults objectForKey:community] isEqual:[_permission objectForKey:community]] || _sticky != [defaults boolForKey:@"sticky"]) {
            [_saveButton setEnabled:YES];
            return;
        }
    } 
    [_saveButton setEnabled:NO];
}

- (IBAction)saveNotifyList:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (NSString *community in _permission) {
        [defaults setObject:[_permission objectForKey:community] forKey:community];
    }
    [defaults setBool:_sticky forKey:@"sticky"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reconnect" object:self];
}

- (IBAction)updateNotifyList:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *notifyDictionary = [NSMutableDictionary dictionary];
	
	_userCommunities = [self getUsersCommunities];
    
    for (NSString *community in _userCommunities) {
        NSString *permission;
        if ((permission = [defaults stringForKey:community])) {
            [notifyDictionary setObject:permission forKey:community];       
            [defaults setObject:permission forKey:community];
        } else {
            [notifyDictionary setObject:@"YES" forKey:community];
            [defaults setObject:@"YES" forKey:community];
        }
	}
	[self clearData];
	[self setNotifyList:notifyDictionary];
    [self setSticky:[defaults boolForKey:@"sticky"]];
	[_notifyTable reloadData];
	if (sender) {
		
	}
}

- (NSArray *)getUsersCommunities
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *mail = [userDefaults stringForKey:@"mail"];
	NSString *pass = [userDefaults stringForKey:@"pass"];
	NSArray *communities;
	@try {
        NSDictionary *userInfo = [NLAuthentication getUserInfoForMail:mail pass:pass];
		communities = [NSArray arrayWithArray:[userInfo objectForKey:@"/getalertstatus/communities/community_id"]];  
	} @catch (NSException *e) {
		return nil;
	}
	return communities;
}


- (void)clearData
{
	[_communities release];
	[_permission release];
	_communities = [[NSMutableArray alloc] initWithObjects:nil];
	_permission = [[NSMutableDictionary alloc] initWithCapacity:10];
}

- (void)setNotifyList:(NSDictionary *)notifyList
{
	for (NSString *community in notifyList) {
		[_communities addObject:community];
	}
	[_permission release];
	_permission = [[NSMutableDictionary alloc] initWithDictionary:notifyList];
}

- (void)setSticky:(BOOL)sticky
{
    _sticky = sticky;
    [_stickButton setState:sticky];
}


/*** implement NSTableViewDataSource ***/
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [_communities count];
}

/*** implement NSTableViewDataSource ***/
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
	NSString *community = [_communities objectAtIndex:rowIndex];
	if ([tableColumn.identifier isEqualToString:@"community"]) {
		return community;
    } else {
		NSButton *button = [[[NSButton alloc] init] autorelease];
		[button setButtonType:NSPushOnPushOffButton];
		if ([[_permission objectForKey:community] isEqualToString:@"YES"]) {
			[button setState:1];
		} else {
			[button setState:0];
		}
        
        [self validSave];
		return button;
    }
    return nil;
}

/*** implement NSTableViewDelegate  ***/
- (BOOL)tableView:(NSTableView *)tableView shouldTrackCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	NSString *community = [_communities objectAtIndex:row];
	if ([tableColumn.identifier isEqualToString:@"community"]) {
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://com.nicovideo.jp/community/%@",community]];
		NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
		[workspace openURL:url];
	} else {
		if ([[_permission objectForKey:community] isEqualToString:@"YES"]) {
			[_permission setObject:@"NO" forKey:community];
        } else {
			[_permission setObject:@"YES" forKey:community];
        }
    }
	
	return YES;
}


@end
