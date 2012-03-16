//
//  NLParser.m
//  NicoLiveAlert
//
//  Created by okey_dokey_ on 12/03/11.
//  Copyright (c) 2012年 okey_dokey_ All rights reserved.
//

#import "NLParser.h"

@implementation NLParser

- (void)dealloc
{
	[_xmlDictionay release];
    [super dealloc];
}

- (NSDictionary *)parseAndGetDictionary 
{
	_xmlDictionay = [[NSMutableDictionary alloc] initWithCapacity:10];
	_elementString = @"";
	[self setDelegate:self];
	[self parse];
	return (NSDictionary *)_xmlDictionay;
}

/*** implement NSXMLParserDelegate ***/
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	_elementString = [_elementString stringByAppendingFormat:@"/%@",elementName];
}

/*** implement NSXMLParserDelegate ***/
- (void)parser:(NSXMLParser*)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	NSArray *array = [_elementString componentsSeparatedByString:@"/"];
	NSString *string = @"";
	for (int i=1; i<[array count]-1; i++) {
		string = [string stringByAppendingFormat:@"/%@",[array objectAtIndex:i]];
	}
	_elementString = string;
}

/*** implement NSXMLParserDelegate ***/
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string  
{  
	if (![[_xmlDictionay allKeys] containsObject:_elementString]) { 
		if ([_elementString isEqualToString:@"/getalertstatus/communities/community_id"]) {
			NSMutableArray *array = [NSMutableArray arrayWithObject:string];
			[_xmlDictionay setValue:array forKey:_elementString];		
		} else {
            NSMutableString *str = [NSMutableString stringWithString:string];
			[_xmlDictionay setValue:str forKey:_elementString];
		}
	} else {
		if([_elementString isEqualToString:@"/getalertstatus/communities/community_id"]) {		
			[[_xmlDictionay objectForKey:_elementString] addObject:string];
		} else {
		[[_xmlDictionay objectForKey:_elementString] appendString:string];
		}
	}
}



@end
