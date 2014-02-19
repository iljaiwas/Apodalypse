//
//  APTaskWindowController.h
//  Apodalypse
//
//  Created by ilja on 19.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface APTaskWindowController : NSWindowController

+ (void) runSheetForTask:(NSTask*) inTask parentWindow:(NSWindow*) inWindow;

@end
