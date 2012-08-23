//
//  ServiceMenuBarItem.m
//  EVE
//
//  Created by Tobias Sommer on 8/16/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "ServiceMenuBarItem.h"
#import "ApplicationSettings.h"
#import "FMDatabase.h"
#import "UIElementItem.h"
#import "Constants.h"
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation ServiceMenuBarItem

+ (void) updateMenuBarShortcutTable :(NSArray*) allMenuBarItemsWithShortcuts {
  FMDatabase *db = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
  
  for(UIElementItem *aMenuBarItem in allMenuBarItemsWithShortcuts) {
    [db executeUpdate:@"insert or ignore into menu_bar_shortcuts (AppName, AppVersion, RoleAttribute, SubroleAttribute, RoleDescriptionAttribute, TitleAttribute, DescriptionAttribute, HelpAttribute, ParentTitleAttribute, ParentRoleAttribute, ParentDescriptionAttribute, ChildrenAttribute, HasShortcut, ShortcutString, Language) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
    aMenuBarItem.appName,
    aMenuBarItem.appVersion,
    aMenuBarItem.roleAttribute,
    aMenuBarItem.subroleAttribute,
    aMenuBarItem.roleDescriptionAttribute,
    aMenuBarItem.titleAttribute,
    aMenuBarItem.descriptionAttribute,
    aMenuBarItem.helpAttribute,
    aMenuBarItem.parentTitleAttribute,
    aMenuBarItem.parentRoleAttribute,
    aMenuBarItem.parentDescriptionAttribute,
    aMenuBarItem.childrenAttribute,
    aMenuBarItem.hasShortcut,
    aMenuBarItem.shortcutString,
    aMenuBarItem.language];
    if ([db hadError])
      NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
  }
  DDLogInfo(@"Update Database");
}
@end
