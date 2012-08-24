//
//  Create_Menu_Bar_Shortcuts_12_08_23.m
//  EVE
//
//  Created by Tobias Sommer on 8/23/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "Create_Menu_Bar_Shortcuts_12_08_23.h"

@implementation Create_Menu_Bar_Shortcuts_12_08_23

- (void)up {
  [self createTable:@"menu_bar_shortcuts"  withColumns:[NSArray arrayWithObjects:
          [FmdbMigrationColumn columnWithColumnName:@"AppName" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"AppVersion" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"Language" columnType:@"date"],
          [FmdbMigrationColumn columnWithColumnName:@"HasShortcut" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"ShortcutString" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"TitleAttribute" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"ShortcutString" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"RoleAttribute" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"SubroleAttribute" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"RoleDescriptionAttribute" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"TitleAttribute" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"DescriptionAttribute" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"ValueAttribute" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"HelpAttribute" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"ChildrenAttribute" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"SelectStatement" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"ParentTitleAttribute" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"ParentRoleAttribute" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"ParentDescriptionAttribute" columnType:@"string"],
          [FmdbMigrationColumn columnWithColumnName:@"ShortcutString" columnType:@"string"],
          nil]];

}

- (void)down {
  
}

@end
