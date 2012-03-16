//
//  NLNotifyListController.h
//  NicoLiveAlert
//
//  Created by okey_dokey_ on 12/03/15.
//  Copyright (c) 2012年 okey_dokey_ All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLNotifyListController : NSObject <NSTableViewDataSource, NSTableViewDelegate>
{
    IBOutlet NSTableView *_notifyTable;
	IBOutlet NSButton *_saveButton;
    IBOutlet NSButton *_stickButton;
	NSMutableArray *_communities;
    NSMutableDictionary *_permission;
	NSArray *_userCommunities;
    BOOL _sticky;
}

@property (retain, nonatomic) NSArray *userCommunities;

- (IBAction)updateNotifyList:(id)sender;
- (IBAction)pushStickButton:(id)sender;
- (IBAction)saveNotifyList:(id)sender;
- (void)setNotifyList:(NSDictionary *)notifyList;
- (void)setSticky:(BOOL)sticky;
- (void)clearData;
@end
