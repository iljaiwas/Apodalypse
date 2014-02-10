//
//  APPlatformLine.m
//  Apodalypse
//
//  Created by ilja on 06.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import "APPlatformLine.h"

@implementation APPlatformLine

- (NSString*) description
{
	NSString *description = [NSString stringWithFormat:@"platform :%@, '%@'\n", self.platform, self.sdkVersion];
	
	if (self.comment)
	{
		description = [description stringByAppendingString:self.comment];
	}
	
	return description;
}

- (BOOL) isValid
{
	return (self.platform.length && self.sdkVersion.length);
}

- (void) setString:(NSString*) inMatchedString matchingCaptureGroupAtIndex:(NSInteger) inCaptureGroupIndex
{
	if (inCaptureGroupIndex == 1)
	{
		self.platform = inMatchedString;
	}
	else if (inCaptureGroupIndex == 2)
	{
		self.sdkVersion = inMatchedString;
	}
	else if (inCaptureGroupIndex == 3)
	{
		self.comment = inMatchedString;
	}
}


@end
