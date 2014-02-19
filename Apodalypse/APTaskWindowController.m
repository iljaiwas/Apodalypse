//
//  APTaskWindowController.m
//  Apodalypse
//
//  Created by ilja on 19.02.14.
//  Copyright (c) 2014 iwascoding GmbH. All rights reserved.
//

#import "APTaskWindowController.h"

@interface APTaskWindowController ()

@property (strong) NSTask *task;

@property (weak)	IBOutlet NSProgressIndicator	*progressBar;
@property (weak)	IBOutlet NSButton				*cancelButton;
@property (weak)	IBOutlet NSButton				*closeButton;
@property (strong)	IBOutlet NSTextView				*textView;
@property (strong)	NSWindow						*parentWindow;
@property (assign)	BOOL							taskFinished;

@end

@implementation APTaskWindowController

+ (void) runSheetForTask:(NSTask*) inTask parentWindow:(NSWindow*) inWindow
{
	APTaskWindowController *controller = [[APTaskWindowController alloc] initWithWindowNibName:@"APTaskWindowController"];
	NSMutableDictionary *environment = [[[NSProcessInfo processInfo] environment] mutableCopy];
	
	controller.task = inTask;
	controller.parentWindow = inWindow;
	
	[inTask setStandardOutput: [NSPipe pipe]];
	[inTask setStandardError: [inTask standardOutput]];
	
	environment[@"LC_ALL"] = @"en_US.UTF-8";
	inTask.environment = environment;
	
	
	[inWindow beginSheet:controller.window completionHandler:^(NSModalResponse returnCode) {
		[controller.window orderOut:nil];
	}];
	
	[[NSNotificationCenter defaultCenter] addObserver:controller
											 selector:@selector(readPipe:)
												 name:NSFileHandleReadCompletionNotification
											   object:[[inTask standardOutput] fileHandleForReading]];
	
	[[[inTask standardOutput] fileHandleForReading] readInBackgroundAndNotify];
	
	[[NSNotificationCenter defaultCenter] addObserver:controller
											 selector:@selector(taskDidTerminate:)
												 name:NSTaskDidTerminateNotification object:inTask];

	
	[inTask launch];
}

- (void) readPipe:(NSNotification*) inNotification
{
	NSData		*data;
	NSString	*text;
	
	data = inNotification.userInfo[NSFileHandleNotificationDataItem];
	if ([data length])
	{
		text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		// Update the text in our text view
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self addLogText:text];
		});
	}
	[[inNotification object] readInBackgroundAndNotify];
}

- (void) taskDidTerminate:(NSNotification*) inNotification
{
	self.taskFinished = YES;
}

- (void) addLogText:(NSString*) inString
{
	NSAttributedString* attr = [[NSAttributedString alloc] initWithString:inString];
	
	[[self.textView textStorage] appendAttributedString:attr];
	[self.textView scrollRangeToVisible:NSMakeRange([[self.textView string] length], 0)];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)cancelTask:(id)sender
{
	[self.task terminate];
}

- (IBAction)closeWindow:(id)sender
{
	[self.parentWindow endSheet:self.window];
}

@end
