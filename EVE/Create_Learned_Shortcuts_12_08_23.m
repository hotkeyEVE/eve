//
//  Create_Learned_Shortcuts_12_08_23.m
//  EVE
//
//  Created by Tobias Sommer on 8/23/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "Create_Learned_Shortcuts_12_08_23.h"

@implementation Create_Learned_Shortcuts_12_08_23

- (void)up {
  [self createTable:@"learned_shortcuts"  withColumns:[NSArray arrayWithObjects:
                [FmdbMigrationColumn columnWithColumnName:@"AppName" columnType:@"string"],
                [FmdbMigrationColumn columnWithColumnName:@"AppVersion" columnType:@"string"],
                [FmdbMigrationColumn columnWithColumnName:@"Language" columnType:@"string"],
                [FmdbMigrationColumn columnWithColumnName:@"User" columnType:@"string"],
                [FmdbMigrationColumn columnWithColumnName:@"Date" columnType:@"date"],
                [FmdbMigrationColumn columnWithColumnName:@"TitleAttribute" columnType:@"string"],
                [FmdbMigrationColumn columnWithColumnName:@"ShortcutString" columnType:@"string"],
                                                                
                                                                nil]];

}

- (void)down {
  
}

@end
