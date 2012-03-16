//
//  NLSocket.m
//  NicoLiveAlert
//
//  Created by okey_dokey on 12/03/12.
//  Copyright (c) 2012年 okey_dokey_ All rights reserved.
//

#import "NLSocket.h"

@interface NLSocket()
- (void)sendThread:(NSString *)threadName;
@end

@implementation NLSocket

- (void)dealloc
{
    [_inputStream release];
    [_outputStream release];
    [super dealloc];
}

- (void)connectToHostName:(NSString *)hostName port:(NSInteger)port threadName:(NSString *)threadName delegate:(id<NSStreamDelegate>)delegate
{
	_inputStream = nil;
	_outputStream = nil;
	NSHost *host = [NSHost hostWithName:hostName];
	[NSStream getStreamsToHost:host port:port inputStream:&_inputStream outputStream:&_outputStream];
	[_inputStream retain];
	[_outputStream retain];
	[_inputStream setDelegate:delegate];
	[_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_inputStream open];
	[_outputStream open];

	[self sendThread:threadName];
	[_outputStream close];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                   target:delegate
                                                 selector:@selector(checkConnect:)
                                                 userInfo:nil 
                                                  repeats:YES];
}

- (void)sendThread:(NSString *)threadName
{
	char buffer[128];
	NSUInteger len = snprintf(buffer, sizeof(buffer), "<thread thread=\"%s\" version=\"20061206\" res_from=\"-1\"/>\\0", [threadName UTF8String]);
   	[_outputStream write:(const uint8_t *)buffer maxLength:len + 1];
}

- (void)disconnect
{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    [_inputStream close];
}

@end
