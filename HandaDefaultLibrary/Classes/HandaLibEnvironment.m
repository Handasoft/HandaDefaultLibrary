//
//  HandaLibEnvironment.m
//  HandaLib
//
//  Created by Kim Dukki on 3/17/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import "HandaLibEnvironment.h"

@implementation HandaLibEnvironment

+(NSString*)RSAKEY{
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HandaLibProperty" ofType:@"plist"]];
    return [[dic objectForKey:@"handa"] objectForKey:@"rsakey"];
}
+(NSString*)DEFAULT_DOMAIN{
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HandaLibProperty" ofType:@"plist"]];
    return [[dic objectForKey:@"handa"] objectForKey:@"domain"];
}
+(NSString*)DEFAULT_API_FILE{
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HandaLibProperty" ofType:@"plist"]];
    return [[dic objectForKey:@"handa"] objectForKey:@"api_file"];
}
+(NSString*)APP_NAME{
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HandaLibProperty" ofType:@"plist"]];
    return [[dic objectForKey:@"handa"] objectForKey:@"app_name"];
}
+(NSString*)APPLE_ID{
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HandaLibProperty" ofType:@"plist"]];
    return [[dic objectForKey:@"handa"] objectForKey:@"apple_id"];
}

@end
