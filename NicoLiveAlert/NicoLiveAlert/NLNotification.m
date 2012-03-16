//
//  NLNotificatio.m
//  NicoLiveAlert
//
//  Created by okey_dokey on 12/03/12.
//  Copyright (c) 2012年 okey_dokey_ All rights reserved.
//

#import "NLNotification.h"

@implementation NLNotification 


- (id)init
{
	if ((self = [super init])) {
		if (![GrowlApplicationBridge growlDelegate]) {
			[GrowlApplicationBridge setGrowlDelegate:self];
		}
    }
	return self;
}


- (void)growlNotificateTitle:(NSString *)title 
				 description:(NSString *)description 
					iconData:(NSData *)iconData
					isSticky:(BOOL)isSticky
				clickContext:(id)clickContext
{
	[GrowlApplicationBridge notifyWithTitle:title										
								description:description
						   notificationName:@"NicoLiveAlert"
								   iconData:iconData
								   priority:0
								   isSticky:isSticky
							   clickContext:clickContext];
}

/*** implement GrowlApplicationBridgeDelegate ***/
- (void)growlNotificationWasClicked:(id)clickContext
{
    NSURL *url = [NSURL URLWithString:[@"http://live.nicovideo.jp/watch/" stringByAppendingString:clickContext]];
	NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
	[workspace openURL:url];
}



@end
