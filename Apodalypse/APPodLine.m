//
//  APPodLine.m
//  Apodalypse
//
//  Created by ilja on 06.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import "APPodLine.h"

@implementation APPodLine

- (NSString*) description
{
	NSString *description = [NSString stringWithFormat:@"pod '%@'",self.name];
	
	if (self.version)
	{
		description = [description stringByAppendingString:@", '"];

		if (self.versionModifier)
		{
			description = [description stringByAppendingString:self.versionModifier];
			description = [description stringByAppendingString:@" "];
		}
		
		description = [description stringByAppendingString:self.version];
		description = [description stringByAppendingString:@"'"];
	}
	if (self.comment)
	{
		description = [description stringByAppendingString:self.comment];
	}
	description = [description stringByAppendingString:@"\n"];
	return  description;
}

- (BOOL) isValid
{
	return (self.name.length);
}

- (void) setString:(NSString*) inMatchedString matchingCaptureGroupAtIndex:(NSInteger) inCaptureGroupIndex
{
	if (inCaptureGroupIndex == 1)
	{
		self.name = inMatchedString;
	}
	else if (inCaptureGroupIndex == 2)
	{
		self.versionModifier = inMatchedString;
	}
	else if (inCaptureGroupIndex == 3)
	{
		self.version = inMatchedString;
	}
	else if (inCaptureGroupIndex == 4)
	{
		self.comment = inMatchedString;
	}

}

@end
