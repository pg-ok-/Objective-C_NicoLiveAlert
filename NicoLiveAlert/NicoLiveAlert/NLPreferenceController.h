//
//  NLPreferenceController.h
//  NicoLiveAlert
//
//  Created by okey_dokey on 12/03/14.
//  Copyright (c) 2012年 okey_dokey All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NLPreferenceController : NSWindowController
{ 
	IBOutlet NSView *_accountView;
	IBOutlet NSView *_notifyListView;

}

- (IBAction)switchView:(id)sender;
@end
