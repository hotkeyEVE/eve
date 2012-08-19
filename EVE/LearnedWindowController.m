//
//  LearnedWindowController.m
//  EVE
//
//  Created by Tobias Sommer on 7/22/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "LearnedWindowController.h"
#import "DDLog.h"
#import "Constants.h"
#import "MenuBar.h"
#import "ServiceProcessPerformedAction.h"
#import "ApplicationSettings.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation LearnedWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction) closeButton:(id) sender {
    [NSApp stopModal];
    DDLogInfo(@"Closed the LearnedShortcut Window without doing anything!");
}

- (IBAction) applicationButton:(id) sender {
  
  [ServiceProcessPerformedAction insertShortcutToLearnedTable];
  [[ApplicationSettings sharedApplicationSettings] setSharedClickContext:NULL];
  
  [NSApp stopModal];
}


- (IBAction) disableButton:(id) sender {

  [ServiceProcessPerformedAction insertApplicationToDisabledApplicationTable];
  [[ApplicationSettings sharedApplicationSettings] setSharedClickContext:NULL];
  
    [NSApp stopModal];
}


@end
