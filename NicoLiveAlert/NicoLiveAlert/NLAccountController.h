//
//  NLAccountController.h
//  NicoLiveAlert
//
//  Created by okey_dokey_ on 12/03/16.
//  Copyright (c) 2012年 okey_dokey_ All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLAccountController : NSObject <NSControlTextEditingDelegate>
{
    IBOutlet NSTextField *_mailField;
	IBOutlet NSSecureTextField *_passField;
	IBOutlet NSButton *_saveButton;
}

- (IBAction)saveAccount:(id)sender;
@end
