//
//  APAppDelegate.m
//  Apodalypse
//
//  Created by ilja on 03.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import "APAppDelegate.h"

#import "APPodCatalogWindowController.h"

@interface APAppDelegate ()

@property (strong) APPodCatalogWindowController *catalogWindowController;

@end

@implementation APAppDelegate

- (IBAction)showPodCatalogWindow:(id)sender
{
	if (nil == self.catalogWindowController)
	{
		self.catalogWindowController = [[APPodCatalogWindowController alloc] initWithWindowNibName:@"APPodCatalogWindowController"];
	}
	[self.catalogWindowController showWindow:sender];
}

@end
