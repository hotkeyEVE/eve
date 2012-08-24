//
//  Create_GUI_ELEMENTS_12_08_23.m
//  EVE
//
//  Created by Tobias Sommer on 8/23/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "Create_GUI_ELEMENTS_12_08_23.h"


@implementation Create_GUI_ELEMENTS_12_08_23
- (void)up {
  [self createTable:@"gui_elements"  withColumns:[NSArray arrayWithObjects:
                     [FmdbMigrationColumn columnWithColumnName:@"AppName" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"AppVersion" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"Language" columnType:@"date"],
                     [FmdbMigrationColumn columnWithColumnName:@"RoleAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"SubroleAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"RoleDescriptionAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"TitleAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"DescriptionAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"ValueAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"HelpAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"ParentAttribute" columnType:@"string"],                                      
                     [FmdbMigrationColumn columnWithColumnName:@"ChildrenAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"SelectStatement" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"TitleAttributeReference" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"ParentTitleAttributeReference" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"ParentAttributeReference" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"ShortcutString" columnType:@"string"],
                    nil]];
}

- (void)down {

}


@end
