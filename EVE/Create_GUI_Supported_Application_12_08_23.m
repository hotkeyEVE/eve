//
//  Create_GUI_Supported_Application_12_08_23.m
//  EVE
//
//  Created by Tobias Sommer on 8/23/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "Create_GUI_Supported_Application_12_08_23.h"
#import "ApplicationSettings.h"
#import "FMDatabase.h"


@implementation Create_GUI_Supported_Application_12_08_23

- (void)up {
  [self createTable:@"gui_supported_applications"  withColumns:[NSArray arrayWithObjects:
         [FmdbMigrationColumn columnWithColumnName:@"AppName" columnType:@"string"],
         [FmdbMigrationColumn columnWithColumnName:@"AppVersion" columnType:@"string"],
         [FmdbMigrationColumn columnWithColumnName:@"Language" columnType:@"string"],
         [FmdbMigrationColumn columnWithColumnName:@"User" columnType:@"string"],
         [FmdbMigrationColumn columnWithColumnName:@"Date" columnType:@"date"],
         [FmdbMigrationColumn columnWithColumnName:@"GUISupport" columnType:@"string"],                                                       nil]];
  
    [self insertGuiSupportedApplication];
}

- (void)down {
  
}

- (void) insertGuiSupportedApplication {
  FMDatabase *sharedDatabase = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
  NSMutableArray *allInserts = [[NSMutableArray alloc] init];
  
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Finder', NULL, 'en', 'Togo', NULL, 'YES');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Google Chrome', NULL, 'en', 'Togo', NULL, 'YES');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Safari', NULL, 'en', 'Togo', NULL, 'YES');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'EVE', NULL, 'en', 'Togo', NULL, 'NO');"];
  
  [sharedDatabase open];
  for(NSString *query in allInserts) {
    [sharedDatabase executeUpdate:query];
  }
  [sharedDatabase close];
}

@end
