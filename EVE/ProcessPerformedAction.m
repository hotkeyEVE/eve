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


+ (void)treatPerformedAction :(NSEvent*) mouseEvent :(AXUIElementRef) currentUIElement :(NSDictionary*) activeApplication :(NSDictionary*) elementProperties {
  FMDatabase *db = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
  
  // Read the settings for this Element
  BOOL guiSupport =       [[activeApplication objectForKey:@"GUI_SUPPORT"] boolValue];
  BOOL guiElement =       [[activeApplication objectForKey:@"IS_GUI_ELEMENT"] boolValue];
  BOOL elementInMenuBar = [[activeApplication objectForKey:@"ELEMENT_IN_MENU_BAR"] boolValue];
  BOOL isMenuItem =       [[activeApplication objectForKey:@"IS_MENU_ITEM"] boolValue];
  
  UIElementItem *theClickedUIElementItem = [UIElementItem initWithElementRef:currentUIElement];
  
  [UIElementItem printObject:theClickedUIElementItem];
  if ( (guiSupport && guiElement)
     || (guiSupport && !elementInMenuBar) ) {
    // If this is a gui element read the correct titles form guielement table. After this you match the correct entry in the menuBar Table
    theClickedUIElementItem = [ServiceProcessPerformedAction getFixedGUIElement :theClickedUIElementItem :db];
    // if there is no menu Bar Item with a matching shortuct and the shortcutString is hardCoded in the database, don't make a select
    if (![theClickedUIElementItem.shortcutString length] > 0) {
        theClickedUIElementItem.shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem :theClickedUIElementItem :db];
    }
  } else if (isMenuItem && elementInMenuBar) {
      theClickedUIElementItem.shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem :theClickedUIElementItem :db];
//    
//    // try to find something in the gui element table
//    if (!theClickedUIElementItem.shortcutString) {
//      // If this is a gui element read the correct titles form guielement table. After this you match the correct entry in the menuBar Table
//      theClickedUIElementItem = [ServiceProcessPerformedAction getFixedGUIElement :theClickedUIElementItem :db];
//      theClickedUIElementItem.shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem :theClickedUIElementItem :db];
//    }
  }
  else {
    // if no guisupport and not in menubar stop here
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
  
  NSMutableString *contentString = [[NSMutableString alloc] init];
  if (theClickedUIElementItem.helpAttribute != NULL && [theClickedUIElementItem.helpAttribute length] > 0) {
    [contentString appendFormat:@"%@ \n", theClickedUIElementItem.helpAttribute];
  } else if ( theClickedUIElementItem.titleAttribute != NULL &&  [theClickedUIElementItem.titleAttribute length] > 0) {
    [contentString appendFormat:@"%@ \n", theClickedUIElementItem.titleAttribute];
  }
    [contentString appendFormat:@"(click to disable)"];
  
  [GrowlApplicationBridge notifyWithTitle:theClickedUIElementItem.shortcutString description:contentString notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:[NSDictionary dictionaryWithObjects:clickContextObjects forKeys:clickContextkeys]];
}


@end

