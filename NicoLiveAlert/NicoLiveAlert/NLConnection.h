//
//  NLConnection.h
//  NicoLiveAlert
//
//  Created by okey_dokey on 12/03/13.
//  Copyright (c) 2012年 okey_dokey All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLNotification.h"
#import "NLSocket.h"

@interface NLConnection : NSObject <NSStreamDelegate>
{
    NSArray *_communities;
    NLSocket *_socket;
    NLNotification *_notification;
    BOOL _sticky;
    BOOL _connecting;
	BOOL _ping;
}

- (void)loginCommentServerForMail:(NSString *)mail pass:(NSString *)pass;
- (void)disconnect;
@end
