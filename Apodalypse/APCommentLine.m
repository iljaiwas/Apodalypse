//
//  APCommentLine.m
//  Apodalypse
//
//  Created by ilja on 07.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import "APCommentLine.h"

@implementation APCommentLine

- (BOOL) isValid
{
	return YES;
}

- (void) setString:(NSString*) inMatchedString matchingCaptureGroupAtIndex:(NSInteger) inCaptureGroupIndex
{
	if (inCaptureGroupIndex == 1)
	{
		self.comment = inMatchedString;
	}
}

- (NSString*) description
{
	return [self.comment stringByAppendingString:@"\n"];
}
@end
