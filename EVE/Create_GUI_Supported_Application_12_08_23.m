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
         [FmdbMigrationColumn columnWithColumnName:@"Date" columnType:@"string"],
         [FmdbMigrationColumn columnWithColumnName:@"GUISupport" columnType:@"string"],                                                       nil]];
  
    [self insertGuiSupportedApplication];
}

- (void)down {
  
}

- (void) insertGuiSupportedApplication {
  FMDatabaseQueue *queue = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
  NSMutableArray *allInserts = [[NSMutableArray alloc] init];
  
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Finder', NULL, 'en', 'Togo', NULL, 'YES');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Chrome', NULL, 'en', 'Togo', NULL, 'YES');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Safari', NULL, 'en', 'Togo', NULL, 'YES');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'EVE', NULL, 'en', 'Togo', NULL, 'NO');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Finder', NULL, 'de', 'Togo', NULL, 'YES');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Chrome', NULL, 'de', 'Togo', NULL, 'YES');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Safari', NULL, 'de', 'Togo', NULL, 'YES');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'EVE', NULL, 'de', 'Togo', NULL, 'NO');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Mail', NULL, 'en', 'Togo', NULL, 'YES');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Mail', NULL, 'de', 'Togo', NULL, 'YES');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'iCal', NULL, 'de', 'Togo', NULL, 'YES');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'iCal', NULL, 'en', 'Togo', NULL, 'YES');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Kalendar', NULL, 'de', 'Togo', NULL, 'YES');"];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Calendar', NULL, 'en', 'Togo', NULL, 'YES');"];
    [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Calendar', NULL, 'de', 'Togo', NULL, 'YES');"];
  [queue inDatabase:^(FMDatabase *db) {
    [db open];
    [db open];
    for(NSString *query in allInserts) {
      [db executeUpdate:query];
    }
    [db close];
  }];
}

@end
