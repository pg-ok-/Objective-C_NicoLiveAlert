//
//  NLLogController.h
//  NicoLiveAlert
//
//  Created by Okey_dokey on 12/03/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLLogController : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
    NSMutableArray *_messages;
	NSMutableArray *_urls;
    NSMutableArray *_timeStamps;
}

- (void)addMessage:(NSString *)message;
- (void)addMessage:(NSString *)message url:(NSURL *)url;
@end
