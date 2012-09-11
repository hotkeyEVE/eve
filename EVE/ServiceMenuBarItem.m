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
#import "Constants.h"
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation ServiceMenuBarItem

+ (void) updateMenuBarShortcutTable :(UIElementItem*) aMenuBarItem :(NSString*) appName {
//  FMDatabase *db = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
//  [db open];
  [[[ApplicationSettings sharedApplicationSettings] getSharedDatabase] inDatabase:^(FMDatabase *db) {
      [db open];
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"insert or replace into menu_bar_shortcuts Values  "];
    [query appendFormat:@"( '%@', ",     appName];
    [query appendFormat:@" '%@', ",     aMenuBarItem.appVersion];
    [query appendFormat:@" '%@', ",     aMenuBarItem.language];
    [query appendFormat:@" '%@', ",     aMenuBarItem.hasShortcut ? @"YES" : @"NO" ];
    [query appendFormat:@" '%@', ",     aMenuBarItem.shortcutString];
    [query appendFormat:@" '%@', ",     aMenuBarItem.titleAttribute];
    [query appendFormat:@" '%@', ",     aMenuBarItem.roleAttribute];
    [query appendFormat:@" '%@', ",     aMenuBarItem.subroleAttribute];
    [query appendFormat:@" '%@', ",     aMenuBarItem.roleDescriptionAttribute];
    [query appendFormat:@" '%@', ",     aMenuBarItem.descriptionAttribute];
    [query appendFormat:@" '%@', ",     aMenuBarItem.valueAttribute];
    [query appendFormat:@" '%@', ",     aMenuBarItem.helpAttribute];
    [query appendFormat:@" '%@', ",     NULL];
    [query appendFormat:@" '%@', ",     aMenuBarItem.parentTitleAttribute];
    [query appendFormat:@" '%@', ",     aMenuBarItem.parentRoleAttribute];
    [query appendFormat:@" '%@' )",     aMenuBarItem.parentDescriptionAttribute];


    
    [db executeUpdate:query];
    if ([db hadError])
      DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
      [db close];
  }];
}

//aMenuBarItem.appName,
//aMenuBarItem.appVersion,
//aMenuBarItem.roleAttribute,
//aMenuBarItem.subroleAttribute,
//aMenuBarItem.roleDescriptionAttribute
//aMenuBarItem.titleAttribute,
//aMenuBarItem.descriptionAttribute,
//aMenuBarItem.helpAttribute,
//aMenuBarItem.parentTitleAttribute,
//aMenuBarItem.parentRoleAttribute,
//aMenuBarItem.parentDescriptionAttribute,
//aMenuBarItem.hasShortcut ? @"YES" : @"NO",
//aMenuBarItem.shortcutString,
//aMenuBarItem.language
@end
