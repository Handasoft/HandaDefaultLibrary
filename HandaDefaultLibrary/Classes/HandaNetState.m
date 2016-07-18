//
//  HandaNetState.m
//  HandaLib
//
//  Created by Kim Dukki on 3/17/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import "HandaNetState.h"
#import "UIAlertView+Helper.h"

@implementation HandaNetState

//네트워크 상태 체크 Notification 등록
- (void)networkCheck
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    internetReach = [HandaLibReachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    [self updateInterfaceWithReachability:internetReach];
}

// 네트워크 상태가 변경 될 경우 호출된다.
- (void)reachabilityChanged:(NSNotification *)note
{
    HandaLibReachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [HandaLibReachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

// 네트워크 상태가 변경 될 경우 처리
- (void)updateInterfaceWithReachability:(HandaLibReachability *)curReach
{
    if(curReach == internetReach)
    {
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        
        NSString *statusString = @"";
        switch (netStatus)
        {
            case NotReachable:
                HandaLibUIAlertViewQuick(@"네트워크 연결이 원활하지 않습니다. 확인 후 이용해주세요.");
                break;
            case ReachableViaWiFi:
                statusString = @"Reachable WiFi";
                break;
            case ReachableViaWWAN:
                statusString = @"Reachable WWAN";
                break;
                
            default:
                break;
        }
        
        // 네트워크 상태에 따라 처리
    }
}

@end
