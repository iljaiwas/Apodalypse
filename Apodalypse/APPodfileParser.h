//
//  APPodfileParser.h
//  Apodalypse
//
//  Created by ilja on 07.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPodfileParser : NSObject

+ (NSArray*) parsedLinesFromPodfileString:(NSString*) inPodfileString;

@end
