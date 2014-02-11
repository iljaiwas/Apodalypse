//
//  APPodSpecCatalogWindowController
//  Apodalypse
//
//  Created by ilja on 03.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface APPodSpecCatalogWindowController : NSWindowController

@property (strong) IBOutlet NSArrayController	*foundPodsArrayController;
@property (strong) IBOutlet NSTableView			*foundPodsTableView;

- (IBAction)searchFieldChanged:(id)sender;
- (IBAction)userDidDoubleclickTableView:(id)sender;

@end
