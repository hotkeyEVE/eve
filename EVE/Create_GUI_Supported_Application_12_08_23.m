//
//  Create_GUI_Supported_Application_12_08_23.m
//  EVE
//
//  Created by Tobias Sommer on 8/23/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "Create_GUI_Supported_Application_12_08_23.h"

@implementation Create_GUI_Supported_Application_12_08_23
- (void)up {
  [self createTable:@"gui_supported_applications"  withColumns:[NSArray arrayWithObjects:
         [FmdbMigrationColumn columnWithColumnName:@"AppName" columnType:@"string"],
         [FmdbMigrationColumn columnWithColumnName:@"AppVersion" columnType:@"string"],
         [FmdbMigrationColumn columnWithColumnName:@"Language" columnType:@"string"],
         [FmdbMigrationColumn columnWithColumnName:@"User" columnType:@"string"],
         [FmdbMigrationColumn columnWithColumnName:@"Date" columnType:@"date"],
         [FmdbMigrationColumn columnWithColumnName:@"GUISupport" columnType:@"string"],
         [FmdbMigrationColumn columnWithColumnName:@"Licence" columnType:@"string"],                                                             nil]];
}

- (void)down {
  
}


@end
