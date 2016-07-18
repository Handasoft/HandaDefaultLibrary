//
//  HandaLib.m
//  HandaLib
//
//  Created by Kim Dukki on 3/17/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import "HandaLib.h"
#import "HandaLibEnvironment.h"
#import "HandaConnector.h"
#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"
#import <sys/utsname.h>
#import <sys/types.h>
#import <sys/sysctl.h>

@implementation HandaLib

static HandaLib * globalValue = nil;

+ (id)alloc{
    @synchronized([HandaLib class])
    {
        globalValue = [super alloc];
        return globalValue;
    }
    return nil;
}

+ (HandaLib *)Access{
    @synchronized([HandaLib class])
    {
        if(!globalValue)
        {
            globalValue = [[self alloc] init];
            
        }
        
        return globalValue;
    }
    return nil;
}

- (void) checkUpdate{
    //버전 체크
    HandaConnector * hc = [[HandaConnector alloc] init];
    [hc appendParam:@"method" str:@"chk.app.ver"];
    [hc appendParam:@"device" str:@"ios"];
    [hc appendParam:@"app_name" str:[[NSBundle mainBundle] bundleIdentifier]];
    [hc appendParam:@"device_name" str:[self getPlatform]];
    [hc appendParam:@"device_os_ver" str:[[UIDevice currentDevice] systemVersion]];
    [hc appendParam:@"device_id" str:[self getUUID]];
    
    NSDictionary * jsonData = [hc receiveJson];

    if([[jsonData objectForKey:@"result"] boolValue] == NO)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[HandaLibEnvironment APP_NAME]
                                                        message:[jsonData objectForKey:@"errmsg"]
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil
                              ];
        alert.tag = 99;
        [alert show];
    }else{
        NSDictionary * dicVersion = [jsonData objectForKey:@"info"];
        strNewUrl = [dicVersion objectForKey:@"app_name2"];
        NSString * strVersion = [dicVersion objectForKey:@"ver"];
        if([strVersion compare:[[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] == NSOrderedDescending){//서버에서 받아온 버전이 더 크면
            
            if([[dicVersion objectForKey:@"type"] intValue] == 1){//필수 업데이트면
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[HandaLibEnvironment APP_NAME]
                                                                message:@"필수 업데이트가 있습니다."
                                                               delegate:self
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil
                                      ];
                alert.tag = 2;
                [alert show];
            }else{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[HandaLibEnvironment APP_NAME]
                                                                message:@"새로운 버전이 나왔습니다.\n업데이트 하시겠습니까?"
                                                               delegate:self
                                                      cancelButtonTitle:@"아니오"
                                                      otherButtonTitles:@"예", nil
                                      ];
                alert.tag = 1;
                [alert show];
            }
        }
    }
}

- (void) goAppStoreForUpdate{
    NSURL* redirectToURL = nil;
    if(strNewUrl != nil && [strNewUrl isEqualToString:@""] == NO){
        redirectToURL = [NSURL URLWithString:strNewUrl];
    }else{
        redirectToURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/app/id%@?mt=8", [HandaLibEnvironment APPLE_ID]]];
    }
    [[UIApplication sharedApplication] openURL:redirectToURL];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1){
        if(buttonIndex){
            [self goAppStoreForUpdate];
        }
    }else if(alertView.tag == 2){
        [self goAppStoreForUpdate];
        exit(0);
    }else if(alertView.tag == 99){//종료
        exit(0);
    }
}

- (NSString*) getUUID{
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UUID"
                                                                       accessGroup:nil];
    
    NSString *uuid = [wrapper objectForKey:(__bridge id)(kSecAttrAccount)];
    if( uuid == nil || uuid.length == 0)
    {
        // if there is not UUID in keychain, make UUID and save it.
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        uuid = [NSString stringWithString:(__bridge NSString *) uuidStringRef];
        CFRelease(uuidStringRef);
        
        // save UUID in keychain
        [wrapper setObject:uuid forKey:(__bridge id)(kSecAttrAccount)];
    }

    return uuid;
}

- (NSString*) getDeviceName{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}


- (NSString *) platform
{
    size_t size;
    
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    
    return platform;
}

- (NSString*) getPlatform
{
    NSString *platform = [self platform];
    
    /* iPhone */
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,3"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 PLUS";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S PLUS";
    
    /* iPod Touch */
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"]) return @"iPod Touch 6G";
    /* iPad */
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad mini";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad mini";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad mini";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"New iPad";
    if ([platform isEqualToString:@"iPad3,5"]) return @"New iPad";
    if ([platform isEqualToString:@"iPad3,6"]) return @"New iPad";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad mini Retina";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad mini Retina";
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad Air2";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad Air2";
    
    /* Simulator */
    if ([platform isEqualToString:@"i386"]) return @"Simulator";
    return @"iPhone OS";
}

@end
