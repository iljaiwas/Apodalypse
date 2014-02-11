//
//  APPodSearchWindowController.m
//  Apodalypse
//
//  Created by ilja on 03.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import "APPodCatalogWindowController.h"

#import "AFHTTPRequestOperationManager.h"

@implementation APPodCatalogWindowController

- (void) awakeFromNib
{
	[self.foundPodsTableView setTarget:self];
	[self.foundPodsTableView setDoubleAction:@selector(userDidDoubleclickTableView:)];
}


- (IBAction)searchFieldChanged:(id)sender
{
	if ([[sender stringValue] length])
	{
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		manager.responseSerializer = [AFJSONResponseSerializer serializer];
		
		[manager GET:@"http://search.cocoapods.org/api/v1/pods.flat.hash.json"
		  parameters:@{@"query":[sender stringValue]}
			 success:^(AFHTTPRequestOperation *operation, id responseObject)
		{
			if ([responseObject isKindOfClass:[NSArray class]])
			{
				 self.foundPodsArrayController.content = responseObject;
				NSLog (@"%@", responseObject);
			}
			else
			{
				self.foundPodsArrayController.content = [NSArray array];;
			}
				 
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			self.foundPodsArrayController.content = [NSArray array];;
		}];
	}
	else
	{
		self.foundPodsArrayController.content = [NSArray array];
	}
}

- (IBAction)userDidDoubleclickTableView:(id)sender
{
	NSDictionary *clickedPod = [self.foundPodsArrayController.selectedObjects firstObject];
	
	if (clickedPod[@"link"])
	{
		[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:clickedPod[@"link"]]];
	}
}


@end
