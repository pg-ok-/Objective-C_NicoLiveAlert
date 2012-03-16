//
//  NLModelController.h
//  NicoLiveAlert
//
//  Created by okey_dokey on 12/03/12.
//  Copyright (c) 2012年 okey_dokey All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLLogController.h"
#import "NLConnection.h"

@interface NLModelController : NSObject {
	NLConnection *connection;
    NLLogController *_logController;
	IBOutlet NSTableView *_logView;
	IBOutlet NSTextField *_statusField;
}

- (void)startConnection;
- (void)disconnect;
- (void)reconnect;
@end
