//
//  AppDelegate.m
//  NicoLiveAlert
//
//  Created by okey_dokey_ on 12/03/11.
//  Copyright (c) okey_dokey All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [model startConnection];	
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    [_window makeKeyAndOrderFront:nil]; 
    return YES;
}

- (IBAction)requireDisconnection:(id)sender
{
	[model disconnect];
	/*NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    NSLog(@"reset");*/
}

- (IBAction)requireReconnection:(id)sender
{
    [model reconnect];
}

@end
