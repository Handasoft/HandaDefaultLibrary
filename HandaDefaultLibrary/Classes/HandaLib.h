//
//  HandaLib.h
//  HandaLib
//
//  Created by Kim Dukki on 3/17/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandaLib : NSObject{
    NSString * strNewUrl;
}

+ (HandaLib *)Access;
- (void) checkUpdate;//업데이트 체크
- (NSString*) getUUID;
- (NSString*) getDeviceName;
- (NSString*) getPlatform;
@end
