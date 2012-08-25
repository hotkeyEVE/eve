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
#import "ServiceAppDelegate.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation ProcessPerformedAction


+ (void)treatPerformedAction :(NSEvent*) mouseEvent :(AXUIElementRef) currentUIElement  {
  FMDatabase *db = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
  
  UIElementItem *theClickedUIElementItem = [UIElementItem initWithElementRef:currentUIElement];
  
  [UIElementItem printObject:theClickedUIElementItem];
  if ([ServiceAppDelegate checkGUISupport] && [UIElementUtilities isGUIElement:currentUIElement]) {
    // If this is a gui element read the correct titles form guielement table. After this you match the correct entry in the menuBar Table
    theClickedUIElementItem = [ServiceProcessPerformedAction getFixedGUIElement :theClickedUIElementItem :db];
    // if there is no menu Bar Item with a matching shortuct and the shortcutString is hardCoded in the database, don't make a select
    if (!theClickedUIElementItem.shortcutString) {
            theClickedUIElementItem.shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem :theClickedUIElementItem :db];
    }
  } else if ([UIElementUtilities isMenuItemElement:currentUIElement]) {
      theClickedUIElementItem.shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem :theClickedUIElementItem :db];
  }
  else {
    return;
  }
  
  BOOL shortcutLastDisplayed = [ServiceProcessPerformedAction checkIfShortcutAlreadySend :theClickedUIElementItem :db];
  BOOL shortcutDisabled =      [ServiceProcessPerformedAction checkIfShortcutIsDisabled  :theClickedUIElementItem :db];

  if (([theClickedUIElementItem.shortcutString length] > 0)
      && !shortcutLastDisplayed
      && !shortcutDisabled) {
    [self showGrowlMessage :theClickedUIElementItem];
    [ServiceProcessPerformedAction insertDisplayedShortcutEntryToDatabase:theClickedUIElementItem :db];
  }
  else {
    if(shortcutLastDisplayed)
      DDLogError(@"This Shortcut has already been send. Don't bother me!!! %@", theClickedUIElementItem.shortcutString );
    else if(shortcutDisabled)
      DDLogError(@"This Shortcut is marked as learned!! %@",  theClickedUIElementItem.shortcutString );
    else
      DDLogError(@"No Shortcut found for: %@",  theClickedUIElementItem.titleAttribute );
  }
  
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

