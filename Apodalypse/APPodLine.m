//
//  APPodLine.m
//  Apodalypse
//
//  Created by ilja on 06.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import "APPodLine.h"

@implementation APPodLine

- (id) init
{
	self = [super init];
	if (self)
	{
		_enabled = YES;
	}
	return self;
}

- (NSString*) description
{
	NSString *description = @"";
	
	if (!self.enabled)
	{
		description = [description stringByAppendingString:@"#"];
	}
	description = [description stringByAppendingFormat:@"pod '%@'",self.name];
	
	if (self.source == APPodSourceMasterRepo)
	{
		if (self.version.length && self.versionModifier)
		{
			description = [description stringByAppendingString:@", '"];

			if (self.versionModifier)
			{
				description = [description stringByAppendingString:[[self class] stringForVersionModifier:self.versionModifier]];
				description = [description stringByAppendingString:@" "];
			}
			
			description = [description stringByAppendingString:self.version];
			description = [description stringByAppendingString:@"'"];
		}
	}
	else if (self.source == APPodSourceExternal)
	{
		description = [description stringByAppendingString:@", :"];
		description = [description stringByAppendingString:self.externalSourceType];
		description = [description stringByAppendingString:@" => '"];
		description = [description stringByAppendingString:self.externalSourceURL];
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
		self.enabled = NO;
	}
	else if (inCaptureGroupIndex == 2)
	{
		self.name = inMatchedString;
	}
	else if (inCaptureGroupIndex == 3)
	{
		self.versionModifier = [[self class] versionModifierForString:inMatchedString];
	}
	else if (inCaptureGroupIndex == 4)
	{
		self.version = inMatchedString;
		if (self.versionModifier == 0)
		{
			self.versionModifier = APUseExact;
		}
	}
	else if (inCaptureGroupIndex == 5)
	{
		self.source = APPodSourceExternal;
		self.externalSourceType = inMatchedString;
	}
	else if (inCaptureGroupIndex == 6)
	{
		self.externalSourceURL = inMatchedString;
	}
	else if (inCaptureGroupIndex == 7)
	{
		self.comment = inMatchedString;
	}
}
	
+ (APPodVersionModifier) versionModifierForString:(NSString*) inVersionModifierString
{
	if ([inVersionModifierString isEqualToString:@"~>"])
		return APRestrictToVersionSeries;
	else if ([inVersionModifierString isEqualToString:@">="])
		return APGreaterOurEqual;
	else if ([inVersionModifierString isEqualToString:@">"])
		return APGreaterThan;
	else if ([inVersionModifierString isEqualToString:@"<="])
		return APLessOrEqual;
	else if ([inVersionModifierString isEqualToString:@"<"])
		return APLessThan;
	return APUseLatest;
}

+ (NSString*) stringForVersionModifier:(APPodVersionModifier) inVersionModifier
{
	switch (inVersionModifier) {
		
		case APUseLatest:
		case APUseExact:
			return @"";
		
		case APRestrictToVersionSeries:
			return @"~>";
		break;
		
		case APGreaterOurEqual:
			return @">=";
		break;
		
		case APGreaterThan:
			return @">";
		break;
		
		case APLessOrEqual:
			return @"<=";
		break;
		
		case APLessThan:
			return @"<";
		break;
	}
	return nil;
}

@end
