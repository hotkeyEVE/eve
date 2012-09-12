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
#import "ServiceMenuBarItem.h"

static const int ddLogLevel = LOG_LEVEL_ERROR;

@implementation ProcessPerformedAction


+ (void)treatPerformedAction :(UIElementItem*) theClickedUIElementItem :(BOOL) guiSupport {
  FMDatabaseQueue *queue = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
  
  DDLogInfo(@"treatPerformedAction gui_support: %d", guiSupport);
  
  if ( (guiSupport && theClickedUIElementItem.isGUIElement)
     || (guiSupport && !theClickedUIElementItem.isInMenuBar) ) {
    // If this is a gui element read the correct titles form guielement table. After this you match the correct entry in the menuBar Table
    theClickedUIElementItem = [ServiceProcessPerformedAction getFixedGUIElement :theClickedUIElementItem :queue];
    // if there is no menu Bar Item with a matching shortuct and the shortcutString is hardCoded in the database, don't make a select
    if ([theClickedUIElementItem.shortcutString length] == 0) {
        theClickedUIElementItem.shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem :theClickedUIElementItem :queue];
    }
  } else if (theClickedUIElementItem.isInMenuBar) {
      theClickedUIElementItem.shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem :theClickedUIElementItem :queue];
  }

  BOOL shortcutLastDisplayed = [ServiceProcessPerformedAction checkIfShortcutAlreadySend :theClickedUIElementItem :queue];
  BOOL shortcutDisabled =      [ServiceProcessPerformedAction checkIfShortcutIsDisabled  :theClickedUIElementItem :queue];

  if (([theClickedUIElementItem.shortcutString length] > 0)
      && !shortcutLastDisplayed
      && !shortcutDisabled) {
    [self showGrowlMessage :theClickedUIElementItem];
    [ServiceProcessPerformedAction insertDisplayedShortcutEntryToDatabase:theClickedUIElementItem :queue];
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
  
  DDLogInfo(@"Send message to Growl: Title: %@  Text: %@", theClickedUIElementItem.shortcutString, contentString);
}


@end

