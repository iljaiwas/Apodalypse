//
//  APPlatformLine.h
//  Apodalypse
//
//  Created by ilja on 06.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import "APRegexpLine.h"

@interface APPlatformLine : APRegexpLine

@property (strong) NSString *platform;
@property (strong) NSString *sdkVersion;

@end
