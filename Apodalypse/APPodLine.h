//
//  APPodLine.h
//  Apodalypse
//
//  Created by ilja on 06.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import "APRegexpLine.h"

@interface APPodLine : APRegexpLine

@property (strong) NSString *name;
@property (strong) NSString *versionModifier;
@property (strong) NSString *version;
@property (assign) BOOL		enabled;

@end
