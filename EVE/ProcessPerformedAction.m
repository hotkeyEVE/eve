/*
 ProcessPerformedAction.m
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


#import "ProcessPerformedAction.h"
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "UIElementUtilities.h"
#import <Growl/Growl.h>
#import "DDLog.h"
#import "ServiceProcessPerformedAction.h"
#import "StringUtilities.h"
#import "ApplicationSettings.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation ProcessPerformedAction


+ (void)treatPerformedAction :(NSEvent*) mouseEvent :(AXUIElementRef) currentUIElement  {
  FMDatabase *db = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
  
  UIElementItem *theClickedUIElementItem = [UIElementItem initWithElementRef:currentUIElement];

  // Check first menu bar
  NSString*shortcutString = NULL;
//    [UIElementItem printObject:theClickedUIElementItem];
  if (![UIElementUtilities isGUIElement:currentUIElement]) {
  shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem :theClickedUIElementItem :db];
  }
  
  if (!shortcutString && [ServiceProcessPerformedAction checkGUISupport :theClickedUIElementItem :db]) {
    shortcutString = [ServiceProcessPerformedAction getShortcutStringFromGUIElement :theClickedUIElementItem :db];
  }
  
  theClickedUIElementItem.shortcutString = shortcutString;
  shortcutString = NULL;
  
  BOOL shortcutLastDisplayed = [ServiceProcessPerformedAction checkIfShortcutAlreadySend :theClickedUIElementItem :db];
  BOOL shortcutDisabled =      [ServiceProcessPerformedAction checkIfShortcutIsDisabled  :theClickedUIElementItem :db];

  if (theClickedUIElementItem.shortcutString && !shortcutLastDisplayed && !shortcutDisabled) {
    [self showGrowlMessage :theClickedUIElementItem];
    [ServiceProcessPerformedAction insertDisplayedShortcutEntryToDatabase:theClickedUIElementItem :db];
  }
  else {
    if(shortcutLastDisplayed)
      DDLogInfo(@"This Shortcut has already been send. Don't bother me!!! %@", theClickedUIElementItem.shortcutString );
    else if(shortcutDisabled)
      DDLogInfo(@"This Shortcut is marked as learned!! %@",  theClickedUIElementItem.shortcutString );
    else
      DDLogInfo(@"No Hotkey found for: %@",  theClickedUIElementItem.titleAttribute );
  }
  
  //[db closeOpenResultSets];
}


+ (void)showGrowlMessage :(UIElementItem*) theClickedUIElementItem {
  
  NSArray *clickContextObjects = [NSArray arrayWithObjects:
                                  theClickedUIElementItem.appName,
                                  theClickedUIElementItem.appVersion,
                                  theClickedUIElementItem.titleAttribute,
                                  theClickedUIElementItem.shortcutString,
                                  theClickedUIElementItem.user,
                                  theClickedUIElementItem.language,
                                  theClickedUIElementItem.date,
                                  nil];
  NSArray *clickContextkeys    = [NSArray arrayWithObjects:
                                  @"AppName",
                                  @"AppVersion",
                                  @"TitleAttribute",
                                  @"ShortcutString",
                                  @"User",
                                  @"Language",
                                  @"Date",
                                  nil];
  
  [GrowlApplicationBridge notifyWithTitle:theClickedUIElementItem.shortcutString description:@"(click to disable)" notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:[NSDictionary dictionaryWithObjects:clickContextObjects forKeys:clickContextkeys]];
}


@end

