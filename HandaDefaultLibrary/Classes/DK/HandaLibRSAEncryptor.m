//
//  RSAEncryptor.m
//  M4U
//
//  Created by Kim Dukki on 6/2/14.
//  Copyright (c) 2014 Kim Dukki. All rights reserved.
//
/*
#import "DKRSAEncryptor.h"

#import "SecKeyWrapper.h"
#import "BasicEncodingRules.h"
#import "Base64.h"

//공개키-modulus (바이너리를 BASE64로 인코딩한 문자열)
#define PUBLICKEY_MODULUS @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwEHjCPRJzTHoYfiY9OYi\
nxzFPnBPYTmJJGvj1tmj2F/fnKWl2TZ3UJNplzWgAbYZo3VZ5gVEoIm7hFxX/P5b\
Acga5ICcDa6O8pRpnB1cdmBPzYQ7lENk5J6E3ZzqR1lFC+19IPNwKpjtMc15+RvJ\
Y3HvgazhutEZaNC3P43FvsNz6MuU+qBawEaDIqSQfiOcrMEVwbnPTPiogTeXx+yw\
KiCd/NirZwXX0Y6/7y3nQlsrpz5gLWzSNaHcWzk3zdSYvUlG+eLZy+oNXvT9t/9v\
3j5tXNpL8l+a59jXV8gGCuhXONN51Gd/Ek4XeqU3vfAaOMJWl6FZV5/aGLNidrch\
VwIDAQAB"

//공개키-exponent (바이너리를 BASE64로 인코딩한 문자열)
#define PUBLICKEY_EXPONENT @"AQAB"

@implementation DKRSAEncryptor

static DKRSAEncryptor *rsaEncryptor = nil;

+ (DKRSAEncryptor *)sharedSingleton
{
    @synchronized(self)
    {
        if (rsaEncryptor == NULL)
            rsaEncryptor = [[self alloc] init];
    }
    return(rsaEncryptor);
}
- (id)init {
    if (self = [super init]) {
        
        //공개키 생성
        NSData *pubKeyModData = [[NSData alloc] initWithBase64Encoding:PUBLICKEY_MODULUS];
        NSData *pubKeyExpData = [[NSData alloc] initWithBase64Encoding:PUBLICKEY_EXPONENT];
        
        NSString *peerName = @"thisissometagname";  //태그명
        NSMutableArray *pubKeyArray = [[NSMutableArray alloc] init];
        [pubKeyArray addObject:pubKeyModData];
        [pubKeyArray addObject:pubKeyExpData];
        NSData *pubKeys = [pubKeyArray berData];
        
        keyref = [self addPeerPublicKey:peerName keyBits:pubKeys];
    }
    return self;
}


-(NSString*)encrypt:(NSString *)str {
    if (keyref) {
        size_t cipherBufferSize;
        uint8_t *cipherBuffer;                     // 1 암호화 된 텍스트를 저장할 버퍼를 할당합니다.
        const char *dataToEncrypt = [str UTF8String];
        size_t dataLength = strlen(dataToEncrypt);
        cipherBufferSize = SecKeyGetBlockSize(keyref);
        cipherBuffer = malloc(cipherBufferSize);
        //NSLog(@"RSA암호화할 문자열 : %s", dataToEncrypt);
        OSStatus status = SecKeyEncrypt(keyref,
                                        kSecPaddingPKCS1,
                                        (uint8_t*)dataToEncrypt,
                                        (size_t) dataLength,
                                        cipherBuffer,
                                        &cipherBufferSize
                                        );
        
        if (status==0) {
            NSString * encoded = [NSString stringWithBase64EncodedString:[NSString stringWithUTF8String:cipherBuffer]];
            //NSString *encoded = [Base64 encode:cipherBuffer length:cipherBufferSize];
            NSLog(@"RSA암호화(BASE64문자열) : %@", encoded);
            return encoded;
        }
    }
    return @"";
}

@end
*/

#import "HandaLibRSAEncryptor.h"

@implementation HandaLibRSAEncryptor

- (id)init {
    self = [super init];
    
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key"
                                                              ofType:@"der"];
    if (publicKeyPath == nil) {
        NSLog(@"Can not find public_key.der");
        return nil;
    }
    
    NSData *publicKeyFileContent = [NSData dataWithContentsOfFile:publicKeyPath];
    if (publicKeyFileContent == nil) {
        NSLog(@"Can not read from public_key.der");
        return nil;
    }
    
    certificate = SecCertificateCreateWithData(kCFAllocatorDefault, ( __bridge CFDataRef)publicKeyFileContent);
    if (certificate == nil) {
        NSLog(@"Can not read certificate from public_key.der");
        return nil;
    }
    
    policy = SecPolicyCreateBasicX509();
    OSStatus returnCode = SecTrustCreateWithCertificates(certificate, policy, &trust);
    if (returnCode != 0) {
        
        return nil;
    }
    
    SecTrustResultType trustResultType;
    returnCode = SecTrustEvaluate(trust, &trustResultType);
    if (returnCode != 0) {
        
        return nil;
    }
    
    publicKey = SecTrustCopyPublicKey(trust);
    if (publicKey == nil) {
        NSLog(@"SecTrustCopyPublicKey fail");
        return nil;
    }
    
    maxPlainLen = SecKeyGetBlockSize(publicKey) - 12;
    return self;
}

- (NSData *) encryptWithData:(NSData *)content {
    
    size_t plainLen = [content length];
    if (plainLen > maxPlainLen) {
        NSLog(@"content(%ld) is too long, must < %ld", plainLen, maxPlainLen);
        return nil;
    }
    
    void *plain = malloc(plainLen);
    [content getBytes:plain
               length:plainLen];
    
    size_t cipherLen = 256;
    void *cipher = malloc(cipherLen);
    
    OSStatus returnCode = SecKeyEncrypt(publicKey, kSecPaddingPKCS1, plain,
                                        plainLen, cipher, &cipherLen);
    
    NSData *result = nil;
    if (returnCode != 0) {
        
    }
    else {
        result = [NSData dataWithBytes:cipher
                                length:cipherLen];
    }
    
    free(plain);
    free(cipher);
    
    return result;
}

- (NSData *) encryptWithString:(NSString *)content {
    return [self encryptWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

@end