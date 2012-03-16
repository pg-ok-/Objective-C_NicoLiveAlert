//
//  NLSocket.h
//  NicoLiveAlert
//
//  Created by okey_dokey on 12/03/12.
//  Copyright (c) 2012年 okey_dokey_ All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLSocket : NSObject
{
    NSInputStream *_inputStream;
	NSOutputStream *_outputStream;
    NSTimer *_timer;
}

- (void)connectToHostName:(NSString *)hostName port:(NSInteger)port threadName:(NSString *)threadName delegate:(id<NSStreamDelegate>)delegate;
- (void)disconnect;
@end
