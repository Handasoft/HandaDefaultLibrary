//
//  UIAlertViewHelper.m
//  CocoaHelpers
//
//  Created by Shaun Harrison on 10/16/08.
//  Copyright 2008 enormego. All rights reserved.
//

#import "UIAlertView+Helper.h"
#import "HandaLibEnvironment.h"

void HandaLibUIAlertViewQuick(NSString * msg){//NSString* title, NSString* message, NSString* dismissButtonTitle) {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[HandaLibEnvironment APP_NAME]
													message:msg
												   delegate:nil 
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil
						  ];
	[alert show];
}



@implementation UIAlertView (Helper)

@end
