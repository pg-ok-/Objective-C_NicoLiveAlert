//
//  NLParser.h
//  NicoLiveAlert
//
//  Created by okey_dokey on 12/03/11.
//  Copyright (c) 2012年 okey_dokey_ All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLParser : NSXMLParser <NSXMLParserDelegate>
{
	NSMutableDictionary *_xmlDictionay;
	NSString *_elementString;
}

- (NSDictionary *)parseAndGetDictionary;

@end
