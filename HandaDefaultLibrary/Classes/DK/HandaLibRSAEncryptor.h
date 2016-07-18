//
//  RSAEncryptor.h
//  M4U
//
//  Created by Kim Dukki on 6/2/14.
//  Copyright (c) 2014 Kim Dukki. All rights reserved.
//
/*
#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import "SecKeyWrapper.h"

@interface DKRSAEncryptor : SecKeyWrapper {
    SecKeyRef keyref;
}
+ (DKRSAEncryptor *)sharedSingleton;
-(NSString*)encrypt:(NSString *)str;

@end
*/

#import <Foundation/Foundation.h>

@interface HandaLibRSAEncryptor : NSObject {
    
    SecKeyRef publicKey;
    
    SecCertificateRef certificate;
    
    SecPolicyRef policy;
    
    SecTrustRef trust;
    
    size_t maxPlainLen;
    
}

- (NSData *) encryptWithData:(NSData *)content;

- (NSData *) encryptWithString:(NSString *)content;

@end