//
//  HandaConnector.h
//  HandaLib
//
//  Created by Kim Dukki on 3/17/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandaConnector : NSObject{
    NSMutableString * strParam;
    NSString * strDomain;
    NSString * strFile;
}

@property (nonatomic)BOOL bAuth;    //rsa암호화 여부

- (void)setDomain:(NSString*)str;   //도메인 설정
- (void)setApiFile:(NSString*)str;  //api파일 경로
- (void)appendParam:(NSString*)strP str:(NSString*)strV;    //파라미터 추가
- (void)appendParam:(NSString*)strP int:(int)intV;          //파라미터 추가
- (NSDictionary*) receiveJson;      //요청

@end
