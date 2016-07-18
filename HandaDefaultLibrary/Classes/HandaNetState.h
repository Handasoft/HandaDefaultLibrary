//
//  HandaNetState.h
//  HandaLib
//
//  Created by Kim Dukki on 3/17/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandaLibReachability.h"

@interface HandaNetState : NSObject{
    HandaLibReachability * internetReach;
}
- (void)networkCheck;   //네트워크 감시 시작
@end
