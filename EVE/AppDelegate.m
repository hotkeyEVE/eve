/*
 AppDelegate.m
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

#import "AppDelegate.h"

#import <Cocoa/Cocoa.h>
#import <AppKit/NSAccessibility.h>
#import "UIElementUtilities.h"
#import "ProcessPerformedAction.h"
#import "Constants.h"
#import "MenuBar.h"
#import "ServiceMenuBarItem.h"
#import "NSFileManager+DirectoryLocations.h"
#import "ServiceAppDelegate.h"
#import "StringUtilities.h"
#import "Database.h"
#import "ServiceLogging.h"
#import "DateUtilities.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation AppDelegate

@synthesize _globalMouseListener;

- (void)applicationDidFinishLaunching:(NSNotification *)note {
  
  // Logging Framework
  [DDLog addLogger:[DDASLLogger sharedInstance]];
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
  
  DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
  fileLogger.maximumFileSize = (3024 * 3024);
  fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
  fileLogger.logFileManager.maximumNumberOfLogFiles = 0;
  [DDLog addLogger:fileLogger];
  DDLogInfo(@"Load Logging Framework");

  [self checkAccessibilityAPIEnabled];

  _systemWideElement = AXUIElementCreateSystemWide();

  _applicationSettings = [ApplicationSettings sharedApplicationSettings];
  
  FMDatabaseQueue *queue = [Database initDatabaseFromSupportDirectory];
  [_applicationSettings setSharedDatabase:queue]; // order important
  [Database executeMigrations:[queue path]];
  DDLogInfo(@"executeMigrations");
  
  [_applicationSettings setSharedAppDelegate:self];
  
  // Growl
  [GrowlApplicationBridge setGrowlDelegate:self];
  DDLogInfo(@"Load Growl Framework");
  
  @autoreleasepool {
    [NSThread detachNewThreadSelector:@selector(indexingAllApps) toTarget:self withObject:nil];
  }
  [[[ApplicationSettings sharedApplicationSettings] getMenuBar] startAnimating];
  
  [self registerAppFrontSwitchedHandler];
  [self registerAppLaunchedHandler];
  [self registerGlobalMouseListener];
  DDLogInfo(@"Finished with Listener");
}

- (void)applicationWillTerminate:(NSNotification *)notification {
  
}

// a Growl delegate method, called when a notification is clicked. Check the value of the clickContext argument to determine what to do
- (void) growlNotificationWasClicked:(id) clickedContext {
    if(clickedContext) {
      [[ApplicationSettings sharedApplicationSettings] setSharedClickContext:clickedContext];
      DDLogInfo(@"ClickContext successfully received!");
        
        if (!learnedWindowController) {
            learnedWindowController = [[LearnedWindowController alloc] initWithWindowNibName:@"LearnedWindow"];
        }
        
        NSWindow *learnedWindow = [learnedWindowController window];
        [learnedWindow orderFront:self];
        [learnedWindow setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
        
        [NSApp runModalForWindow: learnedWindow];
        
        [NSApp endSheet: learnedWindow];
        [NSApp activateIgnoringOtherApps:YES];
        
        [learnedWindow orderOut: self];
    }
    else
    {
        DDLogError(@"Something went wrong in the click context: %@", clickedContext);
    }
}


- (void) checkAccessibilityAPIEnabled {
  // We first have to check if the Accessibility APIs are turned on.  If not, we have to tell the user to do it (they'll need to authenticate to do it).  If you are an accessibility app (i.e., if you are getting info about UI elements in other apps), the APIs won't work unless the APIs are turned on.
  if (!AXAPIEnabled()) {

    NSAlert *alert = [[NSAlert alloc] init];

    [alert setAlertStyle:NSWarningAlertStyle];
    [alert setMessageText:@"EVE requires that the Accessibility API be enabled."];
    [alert setInformativeText:@"Would you like to launch System Preferences so that you can turn on \"Enable access for assistive devices\"?"];
    [alert addButtonWithTitle:@"Open System Preferences"];
    [alert addButtonWithTitle:@"Continue Anyway"];
    [alert addButtonWithTitle:@"Quit UI"];

    NSInteger alertResult = [alert runModal];

    switch (alertResult) {
      case NSAlertFirstButtonReturn: {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSSystemDomainMask, YES);
        if ([paths count] == 1) {
          NSURL *prefPaneURL = [NSURL fileURLWithPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"UniversalAccessPref.prefPane"]];
          [[NSWorkspace sharedWorkspace] openURL:prefPaneURL];
        }
      }
        break;

      case NSAlertSecondButtonReturn: // just continue
        default:
        break;

      case NSAlertThirdButtonReturn:
        [NSApp terminate:self];
        return;
        break;
    }
  } else {
    DDLogInfo(@"Accessibility API is enabled");
  }
}

// -------------------------------------------------------------------------------
//	setCurrentUIElement:uiElement
// -------------------------------------------------------------------------------
- (void)setCurrentUIElement:(AXUIElementRef)uiElement
{
  _currentUIElement = uiElement;
}

// -------------------------------------------------------------------------------
//	currentUIElement:
// -------------------------------------------------------------------------------
- (AXUIElementRef)currentUIElement
{
  return _currentUIElement;
}


// -------------------------------------------------------------------------------
//	updateCurrentUIElement:
// -------------------------------------------------------------------------------
- (void)updateCurrentUIElement
{
  
  // The current mouse position with origin at top right.
  NSPoint cocoaPoint = [NSEvent mouseLocation];
  
  // Only ask for the UIElement under the mouse if has moved since the last check.
  if (!NSEqualPoints(cocoaPoint, _lastMousePoint)) {
    
    CGPoint pointAsCGPoint = [UIElementUtilities carbonScreenPointFromCocoaScreenPoint:cocoaPoint];
    
    AXUIElementRef newElement;
    
    /* If the interaction window is not visible, but we still think we are interacting, change that */
    if (_currentlyInteracting) {
      _currentlyInteracting = ! _currentlyInteracting;
    }
    
    // Ask Accessibility API for UI Element under the mouse
    // And update the display if a different UIElement
    if (AXUIElementCopyElementAtPosition( _systemWideElement, pointAsCGPoint.x, pointAsCGPoint.y, &newElement ) == kAXErrorSuccess
        && newElement
        && ([self currentUIElement] == NULL || ! CFEqual( [self currentUIElement], newElement ))) {

      [self setCurrentUIElement:newElement];
    }
    
    _lastMousePoint = cocoaPoint;
  }
}

- (void) leftMouseButtonClicked :(NSEvent*) incomingEvent {

  // First Update the UIElement with the Element under the mouse pointer
  [self updateCurrentUIElement];
//
  if (_currentUIElement) {
    UIElementItem *theClickedUIElementItem = [UIElementItem initWithElementRef:_currentUIElement];

    // Filter UIElements i.e. skip WebArea
    if ([UIElementUtilities elememtInFilter: _currentUIElement]) {
      [UIElementItem printObject :theClickedUIElementItem];
      [ProcessPerformedAction treatPerformedAction  :theClickedUIElementItem :_guiSupport];
    } else {
      DDLogInfo(@"UIElement not in the filter.");
    }
    theClickedUIElementItem =nil;
  }
}

- (void) appFrontSwitched {
  
  _guiSupport =  [ServiceAppDelegate checkGUISupport];
  
  BOOL disabledApplication = [ServiceAppDelegate checkIfAppIsDisabled];
  if (!disabledApplication) {
    // set menu Bar icon if not active
    __strong NSString *statusIcon = [[[ApplicationSettings sharedApplicationSettings] getMenuBar] getIconName];
    if (![statusIcon isEqualTo:@"EVE_ICON_STATUS_BAR_ACTIVE"] && _guiSupport) {
      [[[ApplicationSettings sharedApplicationSettings] getMenuBar] setMenuBarIconToActive];
    }
    if (![statusIcon isEqualTo:@"EVE_ICON_STATUS_BAR_NO_GUI"] && !_guiSupport) {
      [[[ApplicationSettings sharedApplicationSettings] getMenuBar] setMenuBarIconToNoGUI];
    }
  }
  else {
    [[[ApplicationSettings sharedApplicationSettings] getMenuBar] setMenuBarIconToDisabled];
  }
  
  // Set shortcut cut
  int count = [ServiceAppDelegate countShortcutsForActiveApp];
  [[[ApplicationSettings sharedApplicationSettings] getMenuBar] setShortcutCount :count];
}

- (void) appLaunched {
  [NSThread sleepForTimeInterval:0.3];
  NSDictionary *appDic = [[NSWorkspace sharedWorkspace] activeApplication];
  NSString *bundleIdentifier = [appDic valueForKey:@"NSApplicationBundleIdentifier"];
  NSArray *app =  [NSRunningApplication runningApplicationsWithBundleIdentifier:bundleIdentifier];
  NSTimeInterval interval = [[[app objectAtIndex:0] launchDate] timeIntervalSinceNow];
  if(interval > - 10 && interval > 0) {
    [self indexingThisApp :NO];
  } else {
    DDLogInfo(@"This App has only been refreshed. No Indexing necessary");
  }
  if (interval == 0) {
    DDLogInfo(@"Interval = 0");
  }
}

- (void) registerGlobalMouseListener {
  _globalMouseListener = [NSEvent addGlobalMonitorForEventsMatchingMask:(NSLeftMouseUp)
                                                handler:^(NSEvent *incomingEvent) {
                                                  [self leftMouseButtonClicked:incomingEvent];
                                                }];
}

- (void) removeGlobalMouseListener {
  if (_globalMouseListener) {
    [NSEvent removeMonitor:_globalMouseListener];
    DDLogInfo(@"Disabled the Mouse Listener.");
  }
}

- (void) registerAppFrontSwitchedHandler {
  EventTypeSpec spec = { kEventClassApplication,  kEventAppFrontSwitched };
  OSStatus err = InstallApplicationEventHandler(NewEventHandlerUPP(AppFrontSwitchedHandler), 1, &spec, (__bridge void*)self, NULL);
  if (err)
    DDLogError(@"Could not install event handler");
}

- (void) registerAppLaunchedHandler {
  EventTypeSpec spec = { kEventClassApplication,  kEventAppLaunched };
  OSStatus err = InstallApplicationEventHandler(NewEventHandlerUPP(AppLaunchedHandler), 1, &spec, (__bridge void*)self, NULL);
  if (err)
    DDLogError(@"Could not install event handler");
}

static OSStatus AppLaunchedHandler(EventHandlerCallRef inHandlerCallRef, EventRef inEvent, void *inUserData) {
  [(__bridge id)inUserData appLaunched];
  return 0;
}

static OSStatus AppFrontSwitchedHandler(EventHandlerCallRef inHandlerCallRef, EventRef inEvent, void *inUserData) {
  [(__bridge id)inUserData appFrontSwitched];
  return 0;
}

- (void) indexingThisApp :(BOOL) beHard {
  [NSThread sleepForTimeInterval:0.3];
  NSDictionary *appDic = [[NSWorkspace sharedWorkspace] activeApplication];
  NSString *bundleIdentifier = [appDic valueForKey:@"NSApplicationBundleIdentifier"];
  NSString *appName = [StringUtilities getApplicationNameWithBundleIdentifier:bundleIdentifier ];
  BOOL lastIndexingFinished = [ServiceLogging isIndexingActive :appName];

  if (lastIndexingFinished || beHard) {
    DDLogInfo(@"Indexing New App!");
    @autoreleasepool {
      [NSThread detachNewThreadSelector:@selector(indexingAppWithBundleIdentifier:) toTarget:self withObject:bundleIdentifier];
    }
    [[[ApplicationSettings sharedApplicationSettings] getMenuBar] startAnimating];
  } else {
    DDLogInfo(@"For this App is a search active!");
  }
}

- (void) indexingAllApps {
  [UIElementUtilities indexingAllApps];
  int count = [ServiceAppDelegate countShortcutsForActiveApp];
  [[[ApplicationSettings sharedApplicationSettings] getMenuBar] setShortcutCount :count];
}

- (void) indexingAppWithBundleIdentifier :(NSString*) bundleIdentifier {
    DDLogInfo(@"Start with indexing a single app: %@", bundleIdentifier);
   [UIElementUtilities indexingOnlyOneApp:bundleIdentifier];
    DDLogInfo(@"Finished with indexing app: %@", bundleIdentifier);
    int count = [ServiceAppDelegate countShortcutsForActiveApp];
    [[[ApplicationSettings sharedApplicationSettings] getMenuBar] setShortcutCount :count];
}

@end