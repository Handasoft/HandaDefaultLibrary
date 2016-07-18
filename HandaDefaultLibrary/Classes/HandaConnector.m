//
//  HandaConnector.m
//  HandaLib
//
//  Created by Kim Dukki on 3/17/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import "HandaConnector.h"
#import "HandaLibRSAEncryptor.h"
#import "HandaLibEnvironment.h"

@implementation HandaConnector
@synthesize bAuth;

- (id) init{
    self = [super init];
    if(self){
        bAuth = YES;
        strParam = [[NSMutableString alloc] initWithString:@""];
        strDomain = [HandaLibEnvironment DEFAULT_DOMAIN];
        strFile = [HandaLibEnvironment DEFAULT_API_FILE];
    }
    return self;
}

- (void)setDomain:(NSString*)str{
    strDomain = str;
}
- (void)setApiFile:(NSString*)str{
    strFile = str;
}
- (void)appendParam:(NSString*)strP str:(NSString*)strV{
    [strParam appendString:[NSString stringWithFormat:@"%@=", strP]];
    [strParam appendString:[NSString stringWithFormat:@"%@&", strV]];
}
- (void)appendParam:(NSString*)strP int:(int)intV{
    [strParam appendString:[NSString stringWithFormat:@"%@=", strP]];
    [strParam appendString:[NSString stringWithFormat:@"%d&", intV]];
}

- (NSDictionary*) receiveJson{
    // create the URL
    NSURL *postURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@", strDomain, strFile]];
    NSLog(@" URL  %@", postURL);
    // create the connection
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:10.0];
    // change type to POST (default is GET)
    [postRequest setHTTPMethod:@"POST"];
    
    
    
    if(bAuth){
        HandaLibRSAEncryptor *rsa = [[HandaLibRSAEncryptor alloc] init];
        NSData *plainData = [rsa encryptWithString:[HandaLibEnvironment RSAKEY]];
        NSString * escapedString = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)[plainData base64EncodedStringWithOptions:0], NULL, CFSTR("!*'();:@&=+$,/?%#[]\" "), kCFStringEncodingUTF8));
        NSString * escapedString2 = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)escapedString, NULL, CFSTR("!*'();:@&=+$,/?%#[]\" "), kCFStringEncodingUTF8));
        NSMutableString * strPrameter = [NSMutableString stringWithFormat:@"%@&otp_key=%@", strParam, escapedString2];
        NSLog(@"%@/%@?%@", strDomain, strFile, strPrameter);
        [postRequest setHTTPBody:[strPrameter dataUsingEncoding:NSUTF8StringEncoding]];
    }else{
        NSLog(@"%@/%@?%@", strDomain, strFile, strParam);
        [postRequest setHTTPBody:[strParam dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // pointers to some necessary objects
    NSURLResponse* response;
    NSError* error;
    
    // synchronous filling of data from HTTP POST response
    NSData *responseData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
    if (error){
        NSLog(@"Error: %@", [error localizedDescription]);
        return nil;
    }
    
    NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"response = %@", jsonDic);
    if (error){
        NSLog(@"Error: %@", [error localizedDescription]);
        return nil;
    }
    return jsonDic;
}

@end
