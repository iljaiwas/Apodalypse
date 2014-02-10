//
//  APEmptyLine.m
//  Apodalypse
//
//  Created by ilja on 06.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import "APEmptyLine.h"

@implementation APEmptyLine

- (NSString*) description
{
	return @"\n";
}

+ (id) lineFromString:(NSString *)inRawLine
{
	if (inRawLine.length == 0)
		return [[APEmptyLine alloc] init];
	
	return nil;
}

@end
