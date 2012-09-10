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

@implementation Create_Menu_Bar_Shortcuts_12_08_23

- (void)up {
  __block NSMutableString *query = [[NSMutableString alloc] init];
  [query appendFormat:@" CREATE TABLE \"menu_bar_shortcuts\"  ( "];
  [query appendFormat:@" \"id\" integer auto increment, "];
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
      
    [db close];
  }];
//  [self createTable:@"menu_bar_shortcuts"  withColumns:[NSArray arrayWithObjects:
//          [FmdbMigrationColumn columnWithColumnName:@"AppName" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"AppVersion" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"Language" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"HasShortcut" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"ShortcutString" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"TitleAttribute" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"ShortcutString" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"RoleAttribute" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"SubroleAttribute" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"RoleDescriptionAttribute" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"TitleAttribute" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"DescriptionAttribute" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"ValueAttribute" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"HelpAttribute" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"SelectStatement" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"ParentTitleAttribute" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"ParentRoleAttribute" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"ParentDescriptionAttribute" columnType:@"string"],
//          [FmdbMigrationColumn columnWithColumnName:@"ShortcutString" columnType:@"string"],
//          nil]];
}

- (void)down {
  
}

@end
