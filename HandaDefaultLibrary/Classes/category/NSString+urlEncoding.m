//
//  NSString+urlEncoding.m
//  hidate
//
//  Created by dicadong on 12. 10. 11..
//
//

#import "NSString+urlEncoding.h"

@implementation NSString (urlEncoding)
- (NSString*) urlEncoding{
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8));
}
@end
