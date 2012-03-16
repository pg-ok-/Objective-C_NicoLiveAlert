//
//  NLAuthentication.h
//  NicoLiveAlert
//
//  Created by okey_dokey on 12/03/12.
//  Copyright (c) 2012年 okey_dokey All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLAuthentication : NSObject

+ (NSDictionary *)getUserInfoForMail:(NSString *)mail pass:(NSString *)pass;
+ (NSDictionary *)getProgramInfoForName:(NSString *)name;
@end
