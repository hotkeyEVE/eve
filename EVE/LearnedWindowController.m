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
}

- (IBAction) applicationButton:(id) sender {
  ApplicationSettings *appSettings = [ApplicationSettings sharedApplicationSettings];
  
  BOOL success = [ServiceProcessPerformedAction insertShortcutToLearnedTable :  [appSettings getSharedDatabase]];
  
  if (success) {
   [GrowlApplicationBridge notifyWithTitle:@"Ok, i hide this shortcut!" description:@"If you want to undo this, wait until the next version is released :-)" notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:NULL];
  } else {
    [GrowlApplicationBridge notifyWithTitle:@"Hmm, there was a error. Try again." description:@"" notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:NULL];
  }
  
  [appSettings setSharedClickContext:NULL];
  
  [NSApp stopModal];
}


- (IBAction) disableButton:(id) sender {
  ApplicationSettings *appSettings = [ApplicationSettings sharedApplicationSettings];
  NSDictionary *clickContext = [appSettings getSharedClickContext];
  
  BOOL success = [ServiceProcessPerformedAction insertApplicationToDisabledApplicationTable :  [appSettings getSharedDatabase]];
  if (success) {
    [GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:@"Ok I disabled notifcations for: %@",[clickContext valueForKey:@"AppName"]] description:@"If you want to undo this, wait until the next version is released :-)" notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:NULL];
  } else {
    [GrowlApplicationBridge notifyWithTitle:@"Hmm, there was a error. Try again." description:@"" notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:NULL];
  }
  
  [[ApplicationSettings sharedApplicationSettings] setSharedClickContext:NULL];
  
    [NSApp stopModal];
}


@end
