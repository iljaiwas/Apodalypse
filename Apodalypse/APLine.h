//
//  APLine.h
//  Apodalypse
//
//  Created by ilja on 06.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APLine : NSObject

- (NSString*) description;

+ (id) lineFromString:(NSString*) inRawLine;

@end
