//
//  APAppDelegate.m
//  Apodalypse
//
//  Created by ilja on 03.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import "APAppDelegate.h"

#import "APPodSpecCatalogWindowController.h"

@interface APAppDelegate ()

@property (strong) APPodSpecCatalogWindowController *catalogWindowController;

@end

@implementation APAppDelegate

- (IBAction)showPodCatalogWindow:(id)sender
{
	if (nil == self.catalogWindowController)
	{
		self.catalogWindowController = [[APPodSpecCatalogWindowController alloc] initWithWindowNibName:@"APPodSpecCatalogWindowController"];
	}
	[self.catalogWindowController showWindow:sender];
}

@end
