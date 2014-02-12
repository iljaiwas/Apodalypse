//
//  APDocument.m
//  Apodalypse
//
//  Created by ilja on 03.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import "APDocument.h"

#import "APPodfileParser.h"
#import "APPlatformLine.h"
#import "APPodLine.h"

#import "MACollectionUtilities.h"

@interface APDocument ()

@property (strong) NSArray *lines;

@property (strong) IBOutlet NSArrayController	*visibleLinesController;
@property (strong) IBOutlet NSTableView			*podLinesTableView;

@end

@implementation APDocument

- (id) initWithType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
	self = [super initWithType:typeName error:outError];
	if (self)
	{
		APPlatformLine *platformLine = [[APPlatformLine alloc] init];
		
		platformLine.platform = @"osx";
		platformLine.sdkVersion = @"10.9";
		self.lines = @[platformLine];
	}
	return self;
}

- (NSString *)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"APDocument";
}

- (void)updateVisibleLines
{
	self.visibleLinesController.content = SELECT (self.lines, [obj isKindOfClass:[APPlatformLine class]]
												  || [obj isKindOfClass:[APPodLine class]]);
}

- (void)updateTextView
{
	// Add any code here that needs to be executed once the windowController has loaded the document's window.
	
	self.textView.string = [self podfileText];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];
	[self updateTextView];
	
	[self updateVisibleLines];
	
	[self.podLinesTableView registerForDraggedTypes:@[@"podSpecJSON"]];
	
	if ([self.visibleLinesController.arrangedObjects count] > 1)
	{
		[self.visibleLinesController setSelectionIndex:1];
	}
	else
	{
		[self.visibleLinesController setSelectedObjects:@[]];
	}
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	return [[self podfileText] dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	NSString				*input = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	self.lines = [APPodfileParser parsedLinesFromPodfileString:input];
		
	if (NO == [self isValid])
	{
		return NO;
	}
	return YES;
}


-(NSString*) podfileText
{
	NSMutableString *podfileText = [NSMutableString string];
	
	for (APLine *line in self.lines)
	{
		[podfileText appendString:[line description]];
	}
		 
	return [NSString stringWithString:podfileText];
}

- (BOOL) isValid
{
	if (self.lines.count == 0)
		return NO;
	
	if (1 != SELECT (self.lines, [obj isKindOfClass:[APPlatformLine class]]).count)
	{
		return NO;
	}
	
	return YES;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	if (nil == tableColumn)
		return nil;
	
	APLine *line = [self.visibleLinesController.arrangedObjects objectAtIndex:row];
	
	return [tableView makeViewWithIdentifier:NSStringFromClass([line class]) owner:self];
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation
{
	if (row == 0)
	{
		// disallow drops onto line 0 which we use for the plattform line
		[aTableView setDropRow:1 dropOperation:NSTableViewDropAbove];
	}
	else
	{
		// only allow drops in between pod lines
		[aTableView setDropRow:row dropOperation:NSTableViewDropAbove];
	}

	return NSDragOperationCopy;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
	NSData			*podSpecJSON = [[info draggingPasteboard] dataForType:@"podSpecJSON"];
	NSArray			*draggedPodSpecDicts = [NSJSONSerialization JSONObjectWithData:podSpecJSON options:0 error:nil];
	NSUInteger		insertionIndex;
	
	// compute insertion index in self.lines from drop index
	if (row >= [self.visibleLinesController.arrangedObjects count])
	{
		insertionIndex = self.lines.count;
	}
	else
	{
		APLine *dropTargetLine = [self.visibleLinesController.arrangedObjects objectAtIndex:row];
		
		insertionIndex = [self.lines indexOfObject:dropTargetLine];
	}
	for (NSDictionary *podSpecDict in draggedPodSpecDicts)
	{
		APPodLine *podLine = [[APPodLine alloc] init];
		
		podLine.name = podSpecDict[@"id"];
		[self insertPodLine:podLine atIndex:insertionIndex++];
	}
		
	return YES;
}

- (void) insertPodLine:(APPodLine*) inPodLine atIndex:(NSUInteger) insertionIndex
{
	NSMutableArray	*mutableLines = [self.lines mutableCopy];

	[[self.undoManager prepareWithInvocationTarget:self] removePodLineAtIndex:insertionIndex];
	
	[mutableLines insertObject:inPodLine atIndex:insertionIndex];
	
	self.lines = [NSArray arrayWithArray:mutableLines];
	[self updateVisibleLines];
	[self updateTextView];
}

- (void) removePodLineAtIndex:(NSUInteger) inIndex
{
	APPodLine		*lineToRemove = [self.lines objectAtIndex:inIndex];
	NSMutableArray	*mutableLines = [self.lines mutableCopy];

	[[self.undoManager prepareWithInvocationTarget:self] insertPodLine:lineToRemove atIndex:inIndex];
	
	[mutableLines removeObject:lineToRemove];
	self.lines = [NSArray arrayWithArray:mutableLines];
	[self updateVisibleLines];
	[self updateTextView];
}

- (IBAction)togglePodLineState:(id)sender
{
	NSUInteger row = [self.podLinesTableView rowForView:sender];
	
	APPodLine *podLine = [self.visibleLinesController.arrangedObjects objectAtIndex:row];
	
	if (podLine.enabled)
	{
		[[self.undoManager prepareWithInvocationTarget:self] disablePodLine:podLine];
	}
	else
	{
		[[self.undoManager prepareWithInvocationTarget:self] enablePodLine:podLine];
	}
	
	[self updateTextView];
}

- (void) enablePodLine:(APPodLine*) inPodLine
{
	[[self.undoManager prepareWithInvocationTarget:self] disablePodLine:inPodLine];
	inPodLine.enabled = YES;
	[self updateTextView];
}

- (void) disablePodLine:(APPodLine*) inPodLine
{
	[[self.undoManager prepareWithInvocationTarget:self] enablePodLine:inPodLine];
	inPodLine.enabled = NO;
	[self updateTextView];
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
	if (rowIndex == 0) // platform row shouldn't be selectable
		return NO;
	
	return YES;
}

- (IBAction)delete:(id)sender
{
	for (APPodLine *podLine in [self.visibleLinesController selectedObjects])
	{
		NSUInteger index = [self.lines indexOfObject:podLine];
		
		[self removePodLineAtIndex:index];
	}
}

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem
{
	if ([menuItem action] == @selector(delete:))
	{
		return [[self.visibleLinesController selectedObjects] count] > 0;
	}
	
	return [super validateMenuItem:menuItem];
}

@end
