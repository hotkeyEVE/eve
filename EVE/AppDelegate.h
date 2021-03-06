/*
 AppDelegate.h
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

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>

#import "DDLog.h"
#import "DDFileLogger.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

#import "LearnedWindowController.h"
#import "ApplicationSettings.h"
#import "FMDatabase.h"

#import <Carbon/Carbon.h>

@class OptionsWindowController;
@class LearnedWindowController;
@class ApplicationSettings;

@interface AppDelegate : NSObject <GrowlApplicationBridgeDelegate> {
    
  LearnedWindowController *learnedWindowController;
  
    ApplicationSettings     *_applicationSettings;
  
    NSEvent                 *_globalMouseListener;
    NSEvent                 *_globalKeyListener;
  
    AXUIElementRef			    _systemWideElement;
    NSPoint                 _lastMousePoint;
    AXUIElementRef			    _currentUIElement;
    BOOL                    _currentlyInteracting;
    BOOL                    _highlightLockedUIElement;
    BOOL                    _guiSupport;
    BOOL                    _disabledApplication;
}

@property (readwrite, retain) NSEvent *_globalMouseListener;

- (void)setCurrentUIElement:(AXUIElementRef)uiElement;
- (AXUIElementRef)currentUIElement;
- (void) updateCurrentUIElement;



- (void) leftMouseButtonClicked :(NSEvent*) incomingEvent;

- (void) registerAppFrontSwitchedHandler;
- (void) registerAppLaunchedHandler;
- (void) registerGlobalMouseListener;
- (void) removeGlobalMouseListener;
- (void) registerGlobalKeyDownListener;
- (void) appFrontSwitched;

- (void) checkAccessibilityAPIEnabled;

- (void) indexingAllAppsBackgroundJob;
- (void) indexingAllApps;

- (void) indexingAppWithBundleIdentifier :(NSString*) bundleIdentifier;

- (void) indexingThisApp :(BOOL) beHard;


static OSStatus AppLaunchedHandler(EventHandlerCallRef inHandlerCallRef, EventRef inEvent, void *inUserData);
static OSStatus AppFrontSwitchedHandler(EventHandlerCallRef inHandlerCallRef, EventRef inEvent, void *inUserData);

@end
