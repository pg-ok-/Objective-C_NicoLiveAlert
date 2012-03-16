//
//  NLModelController.m
//  NicoLiveAlert
//
//  Created by okey_dokey on 12/03/12.
//  Copyright (c) 2012年 okey_dokey All rights reserved.
//

#import "NLModelContoller.h"

@implementation NLModelController

- (void)dealloc
{
	[_logController release];
	[super dealloc];
}

- (id)init
{
    if ((self = [super init])) {
        connection = nil;
		_logController = [[NLLogController alloc] init];
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(changeStatus:) name:@"status" object:nil];
		[nc addObserver:self selector:@selector(hitProgram:) name:@"program" object:nil];
		[nc addObserver:self selector:@selector(reconnect) name:@"reconnect" object:nil];
	}
    return self;
}

- (void)awakeFromNib
{
	[_logView setDataSource:_logController];
	[_logView setDelegate:_logController];
	[_statusField setStringValue:@"切断中"];
}

- (void)startConnection
{
	connection = [[NLConnection alloc] init];
	NSUserDefaults *defaults = [[[NSUserDefaults alloc] init] autorelease];
	NSString *mail = [defaults stringForKey:@"mail"];
	NSString *pass = [defaults stringForKey:@"pass"];
	@try {
        [connection loginCommentServerForMail:mail pass:pass];
    } @catch (NSException *e) {
        if ([e.name isEqualToString:@"NLInvalidAccountException"] || [e.name isEqualToString:@"NLAccountRockedExceiption"]) {
			[_logController addMessage:e.reason];
		} else {
			[_logController addMessage:@"接続に失敗しました"];
		}
		[_logView reloadData];
		[connection release];
        connection = nil;
    }
}

- (void)changeStatus:(NSNotification *)notification
{
	NSString *connecting = [[notification userInfo] objectForKey:@"connecting"];
	if ([connecting isEqualToString:@"YES"]) {
		[_logController addMessage:@"接続に成功しました"];
		[_statusField setStringValue:@"接続中"];
	} else {
		[_logController addMessage:@"接続が切断されました"];
		[_statusField setStringValue:@"切断中"];
	}
	[_logView reloadData];
	
}

- (void)hitProgram:(NSNotification *)notificaiton
{
	NSString *name = [[notificaiton userInfo] objectForKey:@"name"];
	NSString *title = [[notificaiton userInfo] objectForKey:@"title"];
	NSString *programNum = [[notificaiton userInfo] objectForKey:@"number"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://live.nicovideo.jp/watch/%@",programNum]];
	[_logController addMessage:[NSString stringWithFormat:@"%@ - %@",name,title] url:url];

	[_logView reloadData];
}

- (void)disconnect {
	if (connection) {
		[connection disconnect];
		[connection release];
		if ([[_statusField stringValue] isEqualToString:@"接続中"]) {
			[_logController addMessage:@"接続を切断しました"];
			[_statusField setStringValue:@"切断中"];
			[_logView reloadData];
		}
		connection = nil;
	}
}

- (void)reconnect
{
	[self disconnect];
    [self startConnection];
}


@end
