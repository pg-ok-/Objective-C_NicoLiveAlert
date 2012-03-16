//
//  NLAuthentication.m
//  NLiveAlert
//
//  Created by okey_dokey on 12/03/12.
//  Copyright (c) 2012年 okey_dokey All rights reserved.
//

#import "NLAuthentication.h"
#import "NLParser.h"

@interface NLAuthentication()
+ (NSString *)ticketForMail:(NSString *)mail pass:(NSString *)pass;
+ (NSDictionary *)useInfoForTicket:(NSString *)ticket;
+ (NSData *)requestDataForURL:(NSURL *)url type:(NSString *)type param:(NSString *)param;
@end

@implementation NLAuthentication 

+ (NSDictionary *)getUserInfoForMail:(NSString *)mail pass:(NSString *)pass
{
    NSString *ticket = [self ticketForMail:mail pass:pass];
    NSDictionary *userInfo = [self useInfoForTicket:ticket];
    return userInfo;
}

+ (NSString *)ticketForMail:(NSString *)mail pass:(NSString *)pass
{
    NSURL *url = [NSURL URLWithString:@"https://secure.nicovideo.jp/secure/login?site=nicolive_antenna"];
    NSString *param = [NSString stringWithFormat:@"mail=%@&password=%@", mail, pass];
    NSData *result = [self requestDataForURL:url type:@"POST" param:param]; 
    NLParser *parser = [[NLParser alloc] initWithData:result];
    NSDictionary *dictionary = [parser parseAndGetDictionary];
    
    if ([[dictionary objectForKey:@"/nicovideo_user_response/error/code"] isEqualToString:@"2"]) {
        [parser release];
        [NSException raise:@"NLInvalidAccountException" format:@"メールドレスまたはパスワードが間違っているため、ログインできませんでした"];
    } else if([[dictionary objectForKey:@"/nicovideo_user_response/error/code"] isEqualToString:@"3"]) {
        [parser release];
        [NSException raise:@"NLAccountRockedExceiption" format:@"何度もパスワードを間違えたのでアカウントがロックされています"];
    }
    
    NSString *ticket =  [NSString stringWithString:[dictionary objectForKey:@"/nicovideo_user_response/ticket"]];
    [parser release];
    return ticket;
}

+ (NSDictionary *)useInfoForTicket:(NSString *)ticket
{
    NSString *urlString = [NSString stringWithFormat:@"http://live.nicovideo.jp/api/getalertstatus?ticket=%@",ticket];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *result = [self requestDataForURL:url type:@"GET" param:nil];
    NLParser *parser = [[NLParser alloc] initWithData:result];
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:[parser parseAndGetDictionary]];
    [parser release];
    return userInfo;
}

+ (NSDictionary *)getProgramInfoForName:(NSString *)name
{
    NSString *urlString = [NSString stringWithFormat:@"http://live.nicovideo.jp/api/getstreaminfo/lv%@", name];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *result = [self requestDataForURL:url type:@"GET" param:nil];
    NLParser *parser = [[NLParser alloc] initWithData:result];    
    NSDictionary *programInfo = [NSDictionary dictionaryWithDictionary:[parser parseAndGetDictionary]];
    [parser release];
    return programInfo;
}

+ (NSData *)requestDataForURL:(NSURL *)url type:(NSString *)type param:(NSString *)param
{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
    [urlRequest setHTTPMethod:type];
    if ([type isEqualToString:@"POST"]) {
        [urlRequest setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSURLResponse* response;
    NSError* error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest
                                           returningResponse:&response
                                                       error:&error];
    [urlRequest release];
    return result;
}


@end
