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
#import "APEmptyLine.h"
#import "APPodLine.h"

#import <ParseKit/ParseKit.h>

@interface APDocument ()

@property (strong) NSArray *lines;

@end

@implementation APDocument

- (id)init
{
    self = [super init];
    if (self) {
		// Add your subclass-specific initialization here.
		self.lines = [NSMutableArray array];
    }
    return self;
}

- (NSString *)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"APDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];
	// Add any code here that needs to be executed once the windowController has loaded the document's window.
	
	self.textView.string = [self podfileText];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	// Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
	// You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
	NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
	@throw exception;
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	NSString				*input = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	self.lines = [APPodfileParser parsedLinesFromPodfileString:input];
	if (self.lines.count == 0)
		return NO;
		
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

@end
