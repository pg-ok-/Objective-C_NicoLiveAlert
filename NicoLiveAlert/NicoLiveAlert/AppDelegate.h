//
//  AppDelegate.h
//  NicoLiveAlert
//
//  Created by okey_dokey_ on 12/03/11.
//  Copyright (c) 2012年 okey_dokey All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NLLogController.h"
#import "NLModelContoller.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
	IBOutlet NLModelController *model;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)requireDisconnection:(id)sender;
- (IBAction)requireReconnection:(id)sender;
@end
