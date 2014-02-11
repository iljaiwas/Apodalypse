//
//  APPodfileParser.m
//  Apodalypse
//
//  Created by ilja on 07.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import "APPodfileParser.h"

#import "APPlatformLine.h"
#import "APPodLine.h"
#import "APCommentLine.h"

@implementation APPodfileParser

+ (NSArray*) parsedLinesFromPodfileString:(NSString*) inPodfileString
{
	NSMutableArray	*parsedLines = [NSMutableArray array];

	[inPodfileString enumerateLinesUsingBlock:^(NSString *rawLine, BOOL *stop) {
		for (Class lineClass in [self lineClassesToTry])
		{
			APLine *parsedLine = [lineClass lineFromString:rawLine];
			if (parsedLine)
			{
				[parsedLines addObject:parsedLine];
				break;
			}
		}
	}];
	return [NSArray arrayWithArray:parsedLines];
}

+ (NSArray*) lineClassesToTry
{
	return @[[APPlatformLine class], [APPodLine class], [APCommentLine class]];
}

@end
