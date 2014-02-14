//
//  APAppDelegate.h
//  Apodalypse
//
//  Created by ilja on 03.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HockeySDK/HockeySDK.h>


@interface APAppDelegate : NSObject <BITHockeyManagerDelegate>

- (IBAction)showPodCatalogWindow:(id)sender;

@end
