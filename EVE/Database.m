//
//  Database.m
//  EVE
//
//  Created by Tobias Sommer on 8/23/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "Database.h"
#import "ApplicationSettings.h"
#import "NSFileManager+DirectoryLocations.h"
#import "FmdbMigrationManager.h"
#import "FMDB/FMDatabase.h"
#import "DDLog.h"
#import "Create_Dislayed_shortcuts_12_08_23.h"
#import "Create_GUI_ELEMENTS_12_08_23.h"
#import "Create_Disabled_Applications_12_08_23.h"
#import "Create_GUI_Supported_Application_12_08_23.h"
#import "Create_Learned_Shortcuts_12_08_23.h"
#import "Create_Menu_Bar_Shortcuts_12_08_23.h"

@implementation Database

+ (FMDatabase*) initDatabaseFromSupportDirectory {
  NSString *dbPath = [[[NSFileManager defaultManager] applicationSupportDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"database.db"]];
  FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
  
  [self executeMigrations :dbPath];

  
  NSLog(@"Is SQLite compiled with it's thread safe options turned on? %@!", [FMDatabase isSQLiteThreadSafe] ? @"Yes" : @"No");
  {
    // -------------------------------------------------------------------------------
    // Un-opened database check.
    [db executeQuery:@"select * from table"];
    NSLog(@"%d: %@", [db lastErrorCode], [db lastErrorMessage]);
  }
  
  if (![db open]) {
//    DDLogError(@"Could not open db.");
    [NSApp terminate:self];
  }
  db.logsErrors = YES;
  // Clear Databases
  // [db executeUpdate:@"DELETE FROM menu_bar_shortcuts"];
  
  [self insertGUIElements :db];
  [self insertFreeGuiSupportedApplication :db];
  
//  DDL(@"Load database...");
  [db close];
  return db;
}

+ (void) executeMigrations :(NSString*) dbPath {
  NSArray *migrations = [NSArray arrayWithObjects:
                         [Create_Dislayed_shortcuts_12_08_23 migration], // 1
                         [Create_GUI_ELEMENTS_12_08_23 migration],
                         [Create_Disabled_Applications_12_08_23 migration],
                         [Create_GUI_Supported_Application_12_08_23 migration],
                         [Create_Learned_Shortcuts_12_08_23 migration],
                         [Create_Menu_Bar_Shortcuts_12_08_23 migration],
                         nil];
  [FmdbMigrationManager executeForDatabasePath:dbPath withMigrations:migrations];
}



+ (void) insertFreeGuiSupportedApplication :(FMDatabase*) db {
  NSMutableArray *allInserts = [[NSMutableArray alloc] init];

  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Finder', NULL, 'en', 'Togo', '', 'YES', 'free'); "];
  [allInserts addObject:@" INSERT INTO \"gui_supported_applications\" VALUES (NULL, 'Google Chrome', NULL, 'en', 'Togo', NULL, 'YES', NULL);"];
   
  [db open];
   for(NSString *query in allInserts) {
      [db executeUpdate:query]; 
  }
  [db close];
}

+ (void) insertGUIElements :(FMDatabase*) db {
  NSMutableArray *allInserts = [[NSMutableArray alloc] init];
  
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (1, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'forward', NULL, NULL, NULL, NULL, NULL, 'forward', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (2, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'icon view', NULL, NULL, NULL, NULL, NULL, 'as icons', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (3, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'list view', NULL, NULL, NULL, NULL, NULL, 'as list', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (4, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'column view', NULL, NULL, NULL, NULL, NULL, 'as columns', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (5, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'cover flow view', NULL, NULL, NULL, NULL, NULL, 'as cover flow', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (6, 'Finder', NULL, 'en', NULL, NULL, NULL, 'name', NULL, NULL, NULL, NULL, NULL, NULL, 'name$1', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (7, 'Finder', NULL, 'en', NULL, NULL, NULL, 'kind', NULL, NULL, NULL, NULL, NULL, NULL, 'kind$1', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (8, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date last opened', NULL, NULL, NULL, NULL, NULL, NULL, 'date last opened', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (9, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date added', NULL, NULL, NULL, NULL, NULL, NULL, 'date added', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (10, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date modified', NULL, NULL, NULL, NULL, NULL, NULL, 'date modified$1', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (11, 'Finder', NULL, 'en', NULL, NULL, NULL, 'size', NULL, NULL, NULL, NULL, NULL, NULL, 'size$1', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (12, 'Finder', NULL, 'en', NULL, NULL, NULL, 'label', NULL, NULL, NULL, NULL, NULL, NULL, 'label$1', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (13, 'Finder', NULL, 'en', NULL, NULL, NULL, 'none', NULL, NULL, NULL, NULL, NULL, NULL, 'none', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (14, 'Finder', NULL, 'en', NULL, NULL, NULL, 'eject', 'eject', NULL, NULL, NULL, NULL, NULL, 'eject', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (15, 'Finder', NULL, 'en', NULL, NULL, NULL, 'new folder', 'new folder', NULL, NULL, NULL, NULL, NULL, 'new folder', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (16, 'Finder', NULL, 'en', NULL, NULL, NULL, 'delete', 'delete', NULL, NULL, NULL, NULL, NULL, 'move to trash', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (17, 'Finder', NULL, 'en', NULL, NULL, NULL, 'connect', 'connect', NULL, NULL, NULL, NULL, NULL, 'connect to server', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (18, 'Finder', NULL, 'en', NULL, NULL, NULL, 'get info', 'get info', NULL, NULL, NULL, NULL, NULL, 'get info', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (19, 'Finder', NULL, 'en', NULL, NULL, NULL, 'search', 'search', NULL, NULL, NULL, NULL, NULL, 'find', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (20, 'Finder', NULL, 'en', NULL, NULL, NULL, 'quick look', 'quick look', NULL, NULL, NULL, NULL, NULL, 'quick look', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (21, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'all my files', NULL, NULL, NULL, NULL, 'all my files', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (22, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'airdrop', NULL, NULL, NULL, NULL, 'airdrop', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (23, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'desktop', NULL, NULL, NULL, NULL, 'desktop', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (24, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'home', NULL, NULL, NULL, NULL, 'home', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (25, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'applications', NULL, NULL, NULL, NULL, 'applications', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (26, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'documents', NULL, NULL, NULL, NULL, 'documents', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (27, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'downloads', NULL, NULL, NULL, NULL, 'downloads', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (28, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'back', NULL, NULL, NULL, NULL, NULL, 'back', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (29, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'back', NULL, NULL, NULL, NULL, NULL, 'back', 'history', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (30, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'forward', NULL, NULL, NULL, NULL, NULL, 'forward', 'history', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (31, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'new tab', NULL, NULL, NULL, NULL, NULL, 'new tab', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (32, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'close', NULL, NULL, NULL, NULL, NULL, 'close tab', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (33, 'All', NULL, 'en', NULL, 'axminimizebutton', 'minimize button', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'minimize', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (34, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'reload', NULL, NULL, NULL, NULL, NULL, 'reload this page', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (35, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'home', NULL, NULL, NULL, NULL, NULL, 'home', 'history', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (36, 'Google Chrome', NULL, 'en', 'axtextfield', NULL, NULL, NULL, 'address', NULL, NULL, NULL, NULL, NULL, 'open location', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (37, 'All', NULL, 'en', NULL, 'axclosebutton', 'close button', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'close window', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (38, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, '1password', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Command \');"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (40, 'All', NULL, 'en', NULL, NULL, 'full screen button', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'enter full screen', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (41, 'Finder', NULL, 'en', NULL, NULL, NULL, 'name', NULL, NULL, NULL, NULL, NULL, NULL, 'name$2', 'sort by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (42, 'Finder', NULL, 'en', NULL, NULL, NULL, 'kind', NULL, NULL, NULL, NULL, NULL, NULL, 'kind$2', 'sort  by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (43, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date last opened', NULL, NULL, NULL, NULL, NULL, NULL, 'date last opened$1', 'sort by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (44, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date added', NULL, NULL, NULL, NULL, NULL, NULL, 'date added', 'sort by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (45, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date modified', NULL, NULL, NULL, NULL, NULL, NULL, 'date modified$2', 'sort by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (46, 'Finder', NULL, 'en', NULL, NULL, NULL, 'size', NULL, NULL, NULL, NULL, NULL, NULL, 'size$2', 'sort by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (47, 'Finder', NULL, 'en', NULL, NULL, NULL, 'label', NULL, NULL, NULL, NULL, NULL, NULL, 'label$2', 'sort by', NULL, NULL);"];

  [db open];
  for(NSString *query in allInserts) {
    [db executeUpdate:query];
  }
  [db close];

}

@end
