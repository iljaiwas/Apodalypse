//
//  APPodSpecCatalogWindowController
//  Apodalypse
//
//  Created by ilja on 03.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import "APPodSpecCatalogWindowController.h"

#import "AFHTTPRequestOperationManager.h"

@implementation APPodSpecCatalogWindowController

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

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
	NSArray *draggedPodSpecDicts = [[self.foundPodsArrayController arrangedObjects] objectsAtIndexes:rowIndexes];
	NSData	*podSpecJSON = [NSJSONSerialization dataWithJSONObject:draggedPodSpecDicts
														  options:0
															error:nil];
	[pboard setData:podSpecJSON forType:@"podSpecJSON"];
	
	return YES;
}


@end
