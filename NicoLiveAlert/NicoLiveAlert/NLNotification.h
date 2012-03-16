//
//  NLNotificate.h
//  NicoLiveAlert
//
//  Created by okey_dokey on 12/03/12.
//  Copyright (c) 2012年 okey_dokey_ All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Growl/Growl.h>

@interface NLNotification : NSObject <GrowlApplicationBridgeDelegate>


- (void)growlNotificateTitle:(NSString *)title 
				 description:(NSString *)description 
					iconData:(NSData *)iconData
					isSticky:(BOOL)isSticky
				clickContext:(id)clickContext;
@end
