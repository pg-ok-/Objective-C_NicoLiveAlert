//
//  NLPreferaceController.m
//  NicoLiveAlert
//
//  Created by okey_dokey_ on 12/03/14.
//  Copyright (c) 2012年 okey_dokey_ All rights reserved.
//

#import "NLPreferenceController.h"

typedef enum {
	PreferencesViewAccount = 1,
	PreferencesViewNotifyList
} PreferencesViewType;


@implementation NLPreferenceController


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
    }
		
    return self;
}

- (void)awakeFromNib
{
	NSWindow *window = [self window];
	NSToolbar *toolbar = [window toolbar];
	NSArray *toolbarItems = [toolbar items];
	NSToolbarItem *item = [toolbarItems objectAtIndex:0];
	[toolbar setSelectedItemIdentifier:[item itemIdentifier]];
	[self switchView:item];
	[window center];
}

- (IBAction)switchView:(id)sender
{
	NSWindow *window = [self window];
	NSView *contentView = [window contentView];
	
	NSArray *subviews = [contentView subviews];
	if([subviews count]) {
		NSView *currentView = [subviews objectAtIndex:0];
		[currentView removeFromSuperview];
	}
	
	NSToolbarItem *item = (NSToolbarItem *)sender;
	NSString *title = [item label];
	[window setTitle:title];
	
	NSView *newView = nil;
	switch([item tag]) {
		case PreferencesViewAccount:
			newView = _accountView;
			break;
		case PreferencesViewNotifyList:
			newView = _notifyListView;
			break;
		default:
			return;
	}
	
	NSRect windowFrame = [window frame];
	NSRect newWindowFrame = [window frameRectForContentRect:[newView frame]];
	newWindowFrame.origin.x = windowFrame.origin.x;
	newWindowFrame.origin.y = windowFrame.origin.y + windowFrame.size.height - newWindowFrame.size.height;
	[window setFrame:newWindowFrame display:YES animate:YES];
	
	CGFloat width = newWindowFrame.size.width;
	CGFloat height = [newView frame].size.height + 22.0f;
	[window setMinSize:NSMakeSize(width, height)];
	[window setMaxSize:NSMakeSize(width, height)];
	
	[contentView addSubview:newView];
}

@end
