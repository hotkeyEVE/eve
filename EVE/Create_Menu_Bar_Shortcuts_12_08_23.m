//
//  Create_Menu_Bar_Shortcuts_12_08_23.m
//  EVE
//
//  Created by Tobias Sommer on 8/23/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "Create_Menu_Bar_Shortcuts_12_08_23.h"
#import "ApplicationSettings.h"
#import "FMDB/FMDatabaseQueue.h"
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation Create_Menu_Bar_Shortcuts_12_08_23

- (void)up {
  __block NSMutableString *query = [[NSMutableString alloc] init];
  [query appendFormat:@" CREATE TABLE \"menu_bar_shortcuts\"  ( "];
  [query appendFormat:@" \"AppName\" string, "];
  [query appendFormat:@" \"AppVersion\" string, "];
  [query appendFormat:@" \"Language\" string, "];
  [query appendFormat:@" \"HasShortcut\" string, "];
  [query appendFormat:@" \"ShortcutString\" string, "];
  [query appendFormat:@" \"TitleAttribute\" string, "];
  [query appendFormat:@" \"RoleAttribute\" string, "];
  [query appendFormat:@" \"SubroleAttribute\" string, "];
  [query appendFormat:@" \"RoleDescriptionAttribute\" string, "];
  [query appendFormat:@" \"DescriptionAttribute\" string, "];
  [query appendFormat:@" \"ValueAttribute\" string, "];
  [query appendFormat:@" \"HelpAttribute\" string, "];
  [query appendFormat:@" \"SelectStatement\" string, "];
  [query appendFormat:@" \"ParentTitleAttribute\" string, "];
  [query appendFormat:@" \"ParentRoleAttribute\" string, "];
  [query appendFormat:@" \"ParentDescriptionAttribute\" string, "];
  [query appendFormat:@" PRIMARY KEY (AppName, Language,TitleAttribute, ShortcutString ));"  ];

  [[[ApplicationSettings sharedApplicationSettings] getSharedDatabase] inDatabase:^(FMDatabase *db) {
    [db open];
    [db executeUpdate:query];
    
    if ([db hadError])
        DDLogError(@"%d: %@", [db lastErrorCode], [db lastErrorMessage]);
    [db close];
  }];
}

- (void)down {
  
}

@end
