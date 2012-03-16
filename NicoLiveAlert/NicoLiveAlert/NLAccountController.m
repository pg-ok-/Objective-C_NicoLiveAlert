//
//  NLAccountController.m
//  NicoLiveAlert
//
//  Created by okey_dokey_ on 12/03/16.
//  Copyright (c) 2012年 okey_dokey_ All rights reserved.
//

#import "NLAccountController.h"

@implementation NLAccountController

- (void)awakeFromNib
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *mail = [userDefaults stringForKey:@"mail"];
	NSString *pass = [userDefaults stringForKey:@"pass"];
	if (mail) {
		[_mailField setStringValue:mail];
	}
	if (pass) {
		[_passField setStringValue:pass];
	}
}

- (IBAction)saveAccount:(id)sender
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setValue:[_mailField stringValue] forKey:@"mail"];
	[userDefaults setValue:[_passField stringValue] forKey:@"pass"];
	[_saveButton setEnabled:NO];
	[userDefaults synchronize];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"reconnect" object:self];
}

/*** implement NSControlTextEditingDelegate ***/
- (void)controlTextDidChange:(NSNotification *)obj
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *mail = [userDefaults stringForKey:@"mail"];
	NSString *pass = [userDefaults stringForKey:@"pass"];
	if ([mail isEqualToString:[_mailField stringValue]] && [pass isEqualToString:[_passField stringValue]]) {
		[_saveButton setEnabled:NO];
    } else {
		[_saveButton setEnabled:YES];
	}	
}


@end
