/*
 MenuBar.m
 EVE
 
 Created by Tobias Sommer on 6/13/12.
 Copyright (c) 2012 Sommer. All rights reserved.
 
 This file is part of EVE.
 
 EVE is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 EVE is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with EVE.  If not, see <http://www.gnu.org/licenses/>. */

#import "MenuBar.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ApplicationSettings.h"
#import "DDLog.h"
#import "StringUtilities.h"
#import "ServiceAppDelegate.h"
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation MenuBar

@synthesize eve_icon_active;
@synthesize eve_icon_disabled;
@synthesize eve_icon_learned;
@synthesize eve_icon_no_gui;
@synthesize statusItem;
@synthesize animTimer;
@synthesize currentFrame;
@synthesize indexingIsRunning;

-(void) menuWillOpen :(NSMenu*) menu {
  int count = [ServiceAppDelegate countShortcutsForActiveApp];
  [[[ApplicationSettings sharedApplicationSettings] getMenuBar] setShortcutCount :count];
}

-(void) awakeFromNib {
    // Init Global Icon
    eve_icon_active = [NSImage imageNamed:@"EVE_ICON_STATUS_BAR_ACTIVE.icns"];
    [eve_icon_active setSize:NSMakeSize(14, 14)];
    
    eve_icon_disabled = [NSImage imageNamed:@"EVE_ICON_STATUS_BAR_DISABLED.icns"];
    [eve_icon_disabled setSize:NSMakeSize(14, 14)];
    
    eve_icon_learned = [NSImage imageNamed:@"EVE_ICON_STATUS_BAR_LEARNED.icns"];
    [eve_icon_learned setSize:NSMakeSize(14, 14)];
  
    eve_icon_no_gui = [NSImage imageNamed:@"EVE_ICON_STATUS_BAR_NO_GUI.icns"];
    [eve_icon_no_gui setSize:NSMakeSize(14, 14)];
    
    
     statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:theMenu];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:eve_icon_active];
    
    [PauseMenuItem setState:NSOffState];
  
    [[ApplicationSettings sharedApplicationSettings] setMenuBar:self];
}

// Actions
- (IBAction)exitProgram:(id)sender {
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

- (IBAction)contactMe:(id)sender {
    NSString* subject = [NSString stringWithFormat:@"Found a bug, or have suggestions?"];
    NSString* body = [NSString stringWithFormat:@"You can contact me in English or German! \n\nThanks Tobi Sommer"];
    NSString* to = eveEmailAddresse;
    
    NSString *encodedSubject = [NSString stringWithFormat:@"SUBJECT=%@", [subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *encodedBody = [NSString stringWithFormat:@"BODY=%@", [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *encodedTo = [to stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedURLString = [NSString stringWithFormat:@"mailto:%@?%@&%@", encodedTo, encodedSubject, encodedBody];
    NSURL *mailtoURL = [NSURL URLWithString:encodedURLString];
    
    [[NSWorkspace sharedWorkspace] openURL:mailtoURL];
}

- (IBAction)pause:(id)sender {
    if ([sender state] == NSOffState) {
        [sender setState:NSOnState];
        [statusItem setImage:eve_icon_disabled];
        [[[ApplicationSettings sharedApplicationSettings] sharedAppDelegate] removeGlobalMouseListener];
    } else {
        [sender setState:NSOffState];
        [statusItem setImage:eve_icon_active];
        [[[ApplicationSettings sharedApplicationSettings] sharedAppDelegate] registerGlobalMouseListener];
    }
}

- (IBAction) visitWebsite:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:URL_WEBSITE]];
}

- (IBAction) resetDatabase:(id)sender {
  // if no indexing active
  if (!indexingIsRunning) {
    [ServiceAppDelegate resetDatabase];
  } else {
    //An error occurred
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:@"EVE is actually indexing. To reset the database, please wait until the indexing is finished!" forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:@"eve" code:100 userInfo:errorDetail];
    [NSApp presentError:error];
  }
}

- (IBAction) indexingThisAppAgain:(id)sender {
  [NSThread sleepForTimeInterval:0.3];
  [[[ApplicationSettings sharedApplicationSettings] sharedAppDelegate] indexingThisApp :YES];
}

- (void) setShortcutCount :(int) count {
  [indexing setTitle:[NSString stringWithFormat:@"Rescan %@ (%i)", [StringUtilities getActiveApplicationName], count]];
}

- (void) setMenuBarIconToDisabled {
    [statusItem setImage:eve_icon_disabled];
}

- (void) setMenuBarIconToNoGUI {
  [statusItem setImage:eve_icon_no_gui];
}


- (void) setMenuBarIconToActive {
    [statusItem setImage:eve_icon_active];
}

- (void) setMenuBarIconToDisabledDelayActive {
    [NSThread detachNewThreadSelector:@selector(delay:) toTarget:[self class] withObject:nil];
}

- (void)delay:(id)param {
    [statusItem setImage:eve_icon_learned];
    [NSThread sleepForTimeInterval:1.5f];
    [statusItem setImage:eve_icon_active];
}

- (NSString*) getIconName {
  return  [[statusItem image] name];
}

- (void)startAnimating {
  
  if (![animTimer isValid]) {
    currentFrame = 0;
    animTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    indexingIsRunning = TRUE;
  }
}

- (void)stopAnimating {
  [animTimer invalidate];
  indexingIsRunning = FALSE;
}

- (void)updateImage {
  if(indexingIsRunning) {
    //get the image for the current frame
    if ((currentFrame % 2) == 0) {
      [self setMenuBarIconToActive];
    } else {
      [self setMenuBarIconToNoGUI];
    }
    currentFrame++;
  } else {
    [self stopAnimating];
  }
}
  
@end