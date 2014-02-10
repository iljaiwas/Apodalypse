//
//  APRegexpLine.m
//  Apodalypse
//
//  Created by ilja on 07.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import "APRegexpLine.h"

@implementation APRegexpLine

+ (id) lineFromString:(NSString *)inRawLine
{
	NSString *patternFilePath = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class])
																ofType:@"txt"];
	NSAssert (patternFilePath, @"couldn't find regexp pattern for line class");
	NSString *pattern = [NSString stringWithContentsOfFile:patternFilePath
												  encoding:NSUTF8StringEncoding
													 error:nil];
	NSRegularExpression *regexp;
	
	regexp = [NSRegularExpression regularExpressionWithPattern:pattern
													   options:0
														 error:nil];
	
	NSArray *matches = [regexp matchesInString:inRawLine options:0 range:NSMakeRange(0,[inRawLine length])];
	if (0 == matches.count)
		return nil;
	
	APRegexpLine *parsedLine = [[self alloc] init];
	
	for (NSTextCheckingResult *result in matches)
	{
		for (NSUInteger i = 1; i < result.numberOfRanges; i++)
		{
			// the first range at index 0 is skipped, since it equals result.range
			NSRange groupRange = [result rangeAtIndex:i];
			if (groupRange.location == NSNotFound) {
				continue;
			}
			NSString* groupMatch = [inRawLine substringWithRange:groupRange];
			
			[parsedLine setString:groupMatch matchingCaptureGroupAtIndex:i];
		}
	}
	
	if (parsedLine.isValid)
	{
		return parsedLine;
	}
	
	return nil;
}

- (BOOL) isValid
{
	// overwrite in subclass
	return NO;
}

- (void) setString:(NSString*) inString matchingCaptureGroupAtIndex:(NSInteger) inCaptureGroupIndex
{
	// overwritte in subclass
}


@end
