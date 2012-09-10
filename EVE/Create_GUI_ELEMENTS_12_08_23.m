//
//  Create_GUI_ELEMENTS_12_08_23.m
//  EVE
//
//  Created by Tobias Sommer on 8/23/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "Create_GUI_ELEMENTS_12_08_23.h"
#import "ApplicationSettings.h"
#import "FMDatabase.h"


@implementation Create_GUI_ELEMENTS_12_08_23

- (void)up {
  [self createTable:@"gui_elements"  withColumns:[NSArray arrayWithObjects:
                     [FmdbMigrationColumn columnWithColumnName:@"AppName" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"AppName2" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"AppVersion" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"Language" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"RoleAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"SubroleAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"RoleDescriptionAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"TitleAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"DescriptionAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"ValueAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"HelpAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"ParentAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"ParentTitleAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"ParentDescriptionAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"ParentRoleAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"ChildrenAttribute" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"SelectStatement" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"TitleAttributeReference" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"ParentTitleAttributeReference" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"ParentAttributeReference" columnType:@"string"],
                     [FmdbMigrationColumn columnWithColumnName:@"ShortcutString" columnType:@"string"],
                    nil]];
  
  
  [self insertGUIElements];
}

- (void)down {

}

- (void) insertGUIElements {
  FMDatabaseQueue *queue = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
//  NSMutableArray *allInserts = [[NSMutableArray alloc] init];
  
  NSString     *finalPath =  [[NSBundle mainBundle] pathForResource:@"gui_elements_inserts"  ofType:@"sql" inDirectory:@""];
  NSData *myData = [NSData dataWithContentsOfFile:finalPath];

  if (myData) {
    NSString *sql = [NSString stringWithUTF8String:[myData bytes]];
    NSMutableArray * fileLines = [[NSMutableArray alloc] initWithArray:[sql componentsSeparatedByString:@"\n"] copyItems: YES];
    [queue inDatabase:^(FMDatabase *db) {
      [db open];
      //  [sharedDatabase open];
      for(NSString *query in fileLines) {
      [db executeUpdateWithFormat:query];
      }
      [db close];
    }];

  }
  
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (1, 'All', NULL, 'en', NULL, 'axclosebutton', 'close button', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'close window', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (2, 'All', NULL, 'en', NULL, 'axminimizebutton', 'minimize button', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'minimize', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (3, 'All', NULL, 'en', NULL, NULL, 'full screen button', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'enter full screen', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (4, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'forward', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'forward', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (5, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'icon view', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'as icons', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (6, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'list view', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'as list', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (7, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'column view', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'as columns', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (8, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'cover flow view', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'as cover flow', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (9, 'Finder', NULL, 'en', NULL, NULL, NULL, 'name', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'name', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (10, 'Finder', NULL, 'en', NULL, NULL, NULL, 'kind', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'kind', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (11, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date last opened', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'date last opened', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (12, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date added', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'date added', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (13, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date modified', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'date modified', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (14, 'Finder', NULL, 'en', NULL, NULL, NULL, 'size', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'size', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (15, 'Finder', NULL, 'en', NULL, NULL, NULL, 'label', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'label', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (16, 'Finder', NULL, 'en', NULL, NULL, NULL, 'none', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'none', 'arrange by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (17, 'Finder', NULL, 'en', NULL, NULL, NULL, 'eject', 'eject', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'eject', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (18, 'Finder', NULL, 'en', NULL, NULL, NULL, 'new folder', 'new folder', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'new folder', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (19, 'Finder', NULL, 'en', NULL, NULL, NULL, 'delete', 'delete', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'move to trash', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (20, 'Finder', NULL, 'en', NULL, NULL, NULL, 'connect', 'connect', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'connect to server', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (21, 'Finder', NULL, 'en', NULL, NULL, NULL, 'get info', 'get info', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'get info', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (22, 'Finder', NULL, 'en', NULL, NULL, NULL, 'search', 'search', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'find', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (23, 'Finder', NULL, 'en', NULL, NULL, NULL, 'quick look', 'quick look', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'quick look', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (24, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'all my files', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'all my files', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (25, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'airdrop', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'airdrop', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (26, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'desktop', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'desktop', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (27, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'home', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'home', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (28, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'applications', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'applications', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (29, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'documents', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'documents', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (30, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'downloads', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'downloads', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (31, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'back', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'back', 'go', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (32, 'Finder', NULL, 'en', NULL, NULL, NULL, 'name', NULL, NULL, NULL, NULL, 'sort by', NULL, NULL, NULL, NULL, 'name', 'sort by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (33, 'Finder', NULL, 'en', NULL, NULL, NULL, 'kind', NULL, NULL, NULL, NULL, 'sort  by', NULL, NULL, NULL, NULL, 'kind', 'sort  by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (34, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date last opened', NULL, NULL, NULL, NULL, 'sort by', NULL, NULL, NULL, NULL, 'date last opened', 'sort by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (35, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date added', NULL, NULL, NULL, NULL, 'sort by', NULL, NULL, NULL, NULL, 'date added', 'sort by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (36, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date modified', NULL, NULL, NULL, NULL, 'sort by', NULL, NULL, NULL, NULL, 'date modified', 'sort by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (37, 'Finder', NULL, 'en', NULL, NULL, NULL, 'size', NULL, NULL, NULL, NULL, 'sort by', NULL, NULL, NULL, NULL, 'size', 'sort by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (38, 'Finder', NULL, 'en', NULL, NULL, NULL, 'label', NULL, NULL, NULL, NULL, 'sort by', NULL, NULL, NULL, NULL, 'label', 'sort by', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (39, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'forward', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'forward', 'history', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (40, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'back', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'back', 'history', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (41, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'new tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'new tab', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (42, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'close', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'close tab', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (43, 'Google Chrome', NULL, 'en', 'axradiobutton', NULL, 'tab', 'new tab', 'new tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'dont display', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (44, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'reload', NULL, 'stop loading this page', NULL, NULL, NULL, NULL, NULL, NULL, 'stop', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (45, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'reload', NULL, 'reload this page', NULL, NULL, NULL, NULL, NULL, NULL, 'reload this page', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (46, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'home', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'home', 'history', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (47, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, '1password', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1password', NULL, NULL, 'Command ');"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (48, 'Google Chrome', NULL, 'en', 'axtextfield', NULL, NULL, NULL, 'address', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'open location', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (49, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'back', 'back', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'back', 'history', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (50, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'forward', 'forward', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'forward', 'history', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (51, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, '1password', '1password', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1password', NULL, NULL, 'Command ');"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (52, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'downloads', 'downloads', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'show downloads', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (53, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'web inspector', 'web inspector', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'show web inspector', 'develop', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (54, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'print', 'print', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'print', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (55, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'mail', 'mail', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'mail link to this page', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (56, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'zoom in', 'zoom in', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'zoom in', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (57, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'zoom out', 'zoom out', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'zoom out', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (58, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'bookmarks bar', 'bookmarks bar', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'bookmarks bar', NULL, NULL, 'Command Shift B');"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (59, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'add bookmark', 'add bookmark', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'add bookmark', 'bookmarks', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (60, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'bookmarks', 'bookmarks', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'bookmarks', NULL, NULL, 'Command Option B');"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (61, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'history', 'history', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'show all history', 'history', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (62, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'new tab', 'new tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'new tab', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (63, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'home', 'home', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'home', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (64, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'top sites', 'top sites', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'show top sites', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (65, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'reading list', 'reading list', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'reading list', NULL, NULL, 'Command Shift L');"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (66, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, NULL, NULL, NULL, 'show reader', NULL, NULL, NULL, NULL, NULL, NULL, 'show reader', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (67, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'reload', 'reload', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'reload page', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (68, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'stop', 'stop', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'stop', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (69, 'Safari', NULL, 'en', 'axtextfield', NULL, NULL, 'address and search', 'address and search', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'open location', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (70, 'Safari', NULL, 'en', NULL, NULL, NULL, NULL, NULL, NULL, 'show reading list', NULL, NULL, NULL, NULL, NULL, NULL, 'show reading list', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (71, 'Safari', NULL, 'en', NULL, NULL, NULL, NULL, NULL, NULL, 'hide reading list', NULL, NULL, NULL, NULL, NULL, NULL, 'hide reading list', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (72, 'Safari', NULL, 'en', NULL, NULL, NULL, NULL, NULL, NULL, 'show all bookmarks', NULL, NULL, NULL, NULL, NULL, NULL, 'show all bookmarks', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (73, 'Safari', NULL, 'en', NULL, NULL, NULL, NULL, NULL, NULL, 'hide all bookmarks', NULL, NULL, NULL, NULL, NULL, NULL, 'hide all bookmarks', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (74, 'Safari', NULL, 'en', NULL, NULL, NULL, NULL, NULL, NULL, 'show top sites', NULL, NULL, NULL, NULL, NULL, NULL, 'show top sites', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (75, 'Safari', NULL, 'en', NULL, NULL, NULL, NULL, NULL, NULL, 'hide top sites', NULL, NULL, NULL, NULL, NULL, NULL, 'hide top sites', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (76, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'close tab', 'close tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'close tab', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (77, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'new tab', 'new tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'new tab', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (78, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, NULL, NULL, NULL, 'hide reader', NULL, NULL, NULL, NULL, NULL, NULL, 'hider reader', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (79, 'Safari', NULL, 'en', 'axradiobutton', NULL, 'tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'dont display', '', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (80, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'autofill', 'autofill', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'autofill form', 'edit', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (81, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'show all tabs', 'show all tabs', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'show all tabs', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (82, 'All', NULL, 'de', NULL, 'axclosebutton', 'schließen-taste', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'schließen', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (83, 'All', NULL, 'de', NULL, 'axminimizebutton', 'taste zum minimieren', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'im dock ablegen', 'fenster', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (84, 'All', NULL, 'de', NULL, 'axfullscreenbutton', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'vollbild ein', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (85, 'Finder', NULL, 'de', NULL, NULL, NULL, NULL, 'weiter', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'vorwärts', 'gehe zu', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (86, 'Finder', NULL, 'de', NULL, NULL, NULL, NULL, 'symboldarstellung', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'als symbole', 'darstellung', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (87, 'Finder', NULL, 'de', NULL, NULL, NULL, NULL, 'listendarstellung', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'als liste', 'darstellung', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (88, 'Finder', NULL, 'de', NULL, NULL, NULL, NULL, 'spaltendarstellung', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'als spalten', 'darstellung', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (89, 'Finder', NULL, 'de', NULL, NULL, NULL, NULL, 'cover flow darstellung', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'als cover flow', 'darstellung', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (90, 'Finder', NULL, 'de', NULL, NULL, NULL, 'name', NULL, NULL, NULL, NULL, NULL, 'ausrichten nach', NULL, NULL, NULL, 'name', 'ausrichten nach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (91, 'Finder', NULL, 'de', NULL, NULL, NULL, 'art', NULL, NULL, NULL, NULL, NULL, 'ausrichten nach', NULL, NULL, NULL, 'art', 'ausrichten nach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (92, 'Finder', NULL, 'de', NULL, NULL, NULL, 'zuletzt geöffnet', NULL, NULL, NULL, NULL, NULL, 'ausrichten nach', NULL, NULL, NULL, 'zuletzt geöffnet', 'ausrichten nach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (93, 'Finder', NULL, 'de', NULL, NULL, NULL, 'hinzugefügt am', NULL, NULL, NULL, NULL, NULL, 'ausrichten nach', NULL, NULL, NULL, 'hinzugefügt am', 'ausrichten nach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (94, 'Finder', NULL, 'de', NULL, NULL, NULL, 'änderungsdatum', NULL, NULL, NULL, NULL, NULL, 'ausrichten nach', NULL, NULL, NULL, 'änderungsdatum', 'ausrichten nach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (95, 'Finder', NULL, 'de', NULL, NULL, NULL, 'größe', NULL, NULL, NULL, NULL, NULL, 'ausrichten nach', NULL, NULL, NULL, 'größe', 'ausrichten nach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (96, 'Finder', NULL, 'de', NULL, NULL, NULL, 'etikett', NULL, NULL, NULL, NULL, NULL, 'ausrichtenausrichten ausrichten nach', NULL, NULL, NULL, 'etikett', 'ausrichten nach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (97, 'Finder', NULL, 'de', NULL, NULL, NULL, 'ohne', NULL, NULL, NULL, NULL, NULL, 'ausrichten nach', NULL, NULL, NULL, 'ohne', 'ausrichten nach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (98, 'Finder', NULL, 'de', NULL, NULL, NULL, 'auswerfen', 'auswerfen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'auswerfen', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (99, 'Finder', NULL, 'de', NULL, NULL, NULL, 'neuer ordner', 'neuer ordner', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'neuer ordner', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (100, 'Finder', NULL, 'de', NULL, NULL, NULL, 'löschen', 'löschen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'in den papierkorb legen', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (101, 'Finder', NULL, 'de', NULL, NULL, NULL, 'verbinden', 'verbinden', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'mit server verbinden ', 'gehe zu', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (102, 'Finder', NULL, 'de', NULL, NULL, NULL, 'informationen', 'informationen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'informationen', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (103, 'Finder', NULL, 'de', NULL, NULL, NULL, 'suchen', 'suchen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'suchen', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (104, 'Finder', NULL, 'de', NULL, NULL, NULL, 'übersicht', 'übersicht', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'übersicht von', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (105, 'Finder', NULL, 'de', 'axstatictext', NULL, NULL, '', '', 'alle meine dateien', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'alle meine dateien', 'gehe zu', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (106, 'Finder', NULL, 'de', 'axstatictext', NULL, NULL, '', '', 'airdrop', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'airdrop', 'gehe zu', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (107, 'Finder', NULL, 'de', 'axstatictext', NULL, NULL, '', '', 'schreibtisch', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'schreibtisch', 'gehe zu', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (108, 'Finder', NULL, 'de', 'axstatictext', NULL, NULL, '', '', 'benutzerordner', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'benutzerordner', 'gehe zu', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (109, 'Finder', NULL, 'de', 'axstatictext', NULL, NULL, '', '', 'programme', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'programme', 'gehe zu', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (110, 'Finder', NULL, 'de', 'axstatictext', NULL, NULL, '', '', 'dokumente', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'dokumente', 'gehe zu', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (111, 'Finder', NULL, 'de', 'axstatictext', NULL, NULL, '', '', 'downloads', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'downloads', 'gehe zu', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (112, 'Finder', NULL, 'de', NULL, NULL, NULL, NULL, 'zurück', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'zurück', 'gehe zu', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (113, 'Finder', NULL, 'de', NULL, NULL, NULL, 'name', NULL, NULL, NULL, NULL, 'aufräumen nach', NULL, NULL, NULL, NULL, 'name', 'aufräumen nach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (114, 'Finder', NULL, 'de', NULL, NULL, NULL, 'art', NULL, NULL, NULL, NULL, 'aufräumen nach', NULL, NULL, NULL, NULL, 'art', 'aufräumen nach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (115, 'Finder', NULL, 'de', NULL, NULL, NULL, 'zuletzt geöffnet', NULL, NULL, NULL, NULL, 'aufräumen nach', NULL, NULL, NULL, NULL, 'zuletzt geöffnet', 'aufräumen nach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (116, 'Finder', NULL, 'de', NULL, NULL, NULL, 'hinzugefügt am', NULL, NULL, NULL, NULL, 'aufräumen nach', NULL, NULL, NULL, NULL, 'hinzugefügt am', 'aufräumen nach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (117, 'Finder', NULL, 'de', NULL, NULL, NULL, 'änderungsdatum', NULL, NULL, NULL, NULL, 'aufräumen nach', NULL, NULL, NULL, NULL, 'änderungsdatum', 'aufräumen nach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (118, 'Finder', NULL, 'de', NULL, NULL, NULL, 'größe', NULL, NULL, NULL, NULL, 'aufräumen nach', NULL, NULL, NULL, NULL, 'größe', 'aufräumen nach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (119, 'Finder', NULL, 'de', NULL, NULL, NULL, 'etikett', NULL, NULL, NULL, NULL, 'aufräumen nach', NULL, NULL, NULL, NULL, 'etikett', 'aufräumen nach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (120, 'Google Chrome', NULL, 'de', 'axbutton', NULL, NULL, NULL, 'zurück', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'zurück', 'verlauf', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (121, 'Google Chrome', NULL, 'de', 'axbutton', NULL, NULL, NULL, 'vorwärts', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'vorwärts', 'verlauf', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (122, 'Google Chrome', NULL, 'de', 'axbutton', NULL, NULL, NULL, 'neuer tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'neuer tab', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (123, 'Google Chrome', NULL, 'de', 'axbutton', NULL, NULL, NULL, 'schließen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'tab schließen', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (124, 'Google Chrome', NULL, 'de', 'axradiobutton', NULL, 'tab', 'neuer tab', 'neuer tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'dont display', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (125, 'Google Chrome', NULL, 'de', 'axbutton', NULL, NULL, NULL, 'neu laden', NULL, 'diese seite neu laden', NULL, NULL, NULL, NULL, NULL, NULL, 'diese seite neu laden', 'anzeigen', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (126, 'Google Chrome', NULL, 'de', 'axbutton', NULL, NULL, NULL, 'neu laden', NULL, 'laden dieser seite anhalten', NULL, NULL, NULL, NULL, NULL, NULL, 'stopp', 'anzeigen', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (127, 'Google Chrome', NULL, 'de', 'axbutton', NULL, NULL, NULL, 'startseite', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'startseite', 'verlauf', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (128, 'Google Chrome', NULL, 'de', 'axbutton', NULL, NULL, NULL, '1password', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1password', NULL, NULL, 'Command \\ ');"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (129, 'Google Chrome', NULL, 'de', 'axtextfield', NULL, NULL, NULL, 'adresse', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'adresse öffnen', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (130, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'zurück', 'zurück', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'zurück', 'verlauf', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (131, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'vorwärts', 'vorwärts', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'vorwärts', 'verlauf', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (132, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, '1password', '1password', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1password', NULL, NULL, 'Command \');"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (133, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'downloads', 'downloads', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'downloads anzeigen', 'darstellung', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (134, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'webinformationen', 'webinformationen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'webinformationen einblenden', 'entwickler', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (135, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'drucken', 'drucken', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'drucken ', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (136, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'mail', 'mail', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'link zu dieser seite als e-Mail senden', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (137, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'vergrößern', 'vergrößern', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'vergrößern', 'darstellung', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (138, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'verkleinern', 'verkleinern', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'verkleinern', 'darstellung', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (139, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'lesezeichenleiste', 'lesezeichenleiste', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lesezeichenleiste', NULL, NULL, 'Command Shift B');"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (140, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'lesezeichen hinzufügen', 'lesezeichen hinzufügen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lesezeichen hinzufügen ', 'lesezeichen', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (141, 'Safari', NULL, 'de', NULL, NULL, NULL, 'lesezeichen', 'lesezeichen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'alle lesezeichen einblenden', NULL, NULL, 'Command Option B');"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (142, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'verlauf', 'verlauf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'gesamten verlauf anzeigen', 'verlauf', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (143, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'neuer tab', 'neuer tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'neuer tab', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (144, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'startseite', 'startseite', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'startseite', 'verlauf', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (145, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'top sites', 'top sites', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'top sites einblenden', 'verlauf', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (146, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'leseliste', 'leseliste', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'leseliste einblenden', NULL, NULL, 'Command Shift L');"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (147, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, NULL, NULL, NULL, 'reader einblenden', NULL, NULL, NULL, NULL, NULL, NULL, 'reader einblenden', 'darstellung', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (148, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'neu laden', 'neu laden', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'seite neu laden', 'darstellung', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (149, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'stopp', 'stopp', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'stopp', 'darstellung', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (150, 'Safari', NULL, 'de', 'axtextfield', NULL, NULL, 'adresse und suchen', 'adresse und suchen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'adresse öffnen ', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (151, 'Safari', NULL, 'de', NULL, NULL, NULL, NULL, NULL, NULL, 'leseliste einblenden', NULL, NULL, NULL, NULL, NULL, NULL, 'leseliste einblenden', 'darstellung', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (152, 'Safari', NULL, 'de', NULL, NULL, NULL, NULL, NULL, NULL, 'leseliste ausblenden', NULL, NULL, NULL, NULL, NULL, NULL, 'leseliste ausblenden', 'darstellung', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (153, 'Safari', NULL, 'de', NULL, NULL, NULL, NULL, NULL, NULL, 'alle lesezeichen einblenden', NULL, NULL, NULL, NULL, NULL, NULL, 'alle lesezeichen einblenden', 'lesezeichen', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (154, 'Safari', NULL, 'de', NULL, NULL, NULL, NULL, NULL, NULL, 'alle lesezeichen ausblenden', NULL, NULL, NULL, NULL, NULL, NULL, 'alle Lesezeichen ausblenden', 'lesezeichen', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (155, 'Safari', NULL, 'de', NULL, NULL, NULL, NULL, NULL, NULL, 'top sites einblenden', NULL, NULL, NULL, NULL, NULL, NULL, 'top sites einblenden', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (156, 'Safari', NULL, 'de', NULL, NULL, NULL, NULL, NULL, NULL, 'top sites ausblenden', NULL, NULL, NULL, NULL, NULL, NULL, 'top sites einblenden', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (157, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'tab schließen', 'tab schließen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'tab schließen', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (158, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'neuer tab', 'neuer tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'neuer tab', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (159, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, NULL, NULL, NULL, 'reader ausblenden', NULL, NULL, NULL, NULL, NULL, NULL, 'reader ausblenden', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (160, 'Safari', NULL, 'de', 'axradiobutton', NULL, 'tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'dont display', '', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (161, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'autom. ausfüllen', 'autom. ausfüllen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'formular automatisch ausfüllen', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (162, 'Safari', NULL, 'de', 'axbutton', NULL, NULL, 'alle tabs einblenden', 'alle tabs einblenden', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'alle tabs einblenden', 'darstellung', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (163, 'Mail', 5.2, 'en', 'axbutton', NULL, NULL, 'get mail', 'get mail', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'get all new mail', 'mailbox', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (164, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'delete', 'delete', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'delete', 'edit', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (165, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'junk', NULL, 'mark selected messages as not junk', NULL, NULL, NULL, NULL, NULL, NULL, 'as junk mail', 'mark', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (166, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'junk', NULL, 'mark selected messages as junk', NULL, NULL, NULL, NULL, NULL, NULL, 'as not junk mail', 'mark', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (167, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'reply', 'reply', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'reply', 'message', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (168, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'reply all', 'reply all', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'reply all', 'message', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (169, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'forward', 'forward', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'forward', 'message', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (170, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'flag red', 'flag red', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'red', 'flag', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (171, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'archive', 'archive', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'archive', 'message', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (172, 'Mail', NULL, 'en', 'axmenuitem', NULL, NULL, 'inbox', NULL, NULL, NULL, NULL, NULL, NULL, 'axgroup', NULL, NULL, 'dont show', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (173, 'Mail', NULL, 'en', 'axmenuitem', NULL, NULL, 'sent', NULL, NULL, NULL, NULL, NULL, NULL, 'axgroup', NULL, NULL, 'dont show', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (174, 'Mail', NULL, 'en', 'axmenuitem', NULL, NULL, 'notes', NULL, NULL, NULL, NULL, NULL, NULL, 'axgroup', NULL, NULL, 'dont show', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (175, 'Mail', NULL, 'en', 'axmenuitem', NULL, NULL, 'flagged', NULL, NULL, NULL, NULL, NULL, NULL, 'axgroup', NULL, NULL, 'dont show', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (176, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'new message', 'new message', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'new message', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (177, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'note', 'note', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'new note', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (178, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'sidebar', 'sidebar', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'hide mailbox list', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (179, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'print', 'print', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'print', 'file', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (180, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'all headers', 'all headers', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'all headers', 'message', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (181, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'unread', 'unread', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'as unread', 'mark', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (182, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'read', 'read', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'as read', 'mark', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (183, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'address', 'address', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'address panel', 'window', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (184, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'smaller', 'smaller', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'smaller', 'style', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (185, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'bigger', 'bigger', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'bigger', 'style', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (186, 'Mail', 5.2, 'en', 'axbutton', NULL, NULL, 'add sender', 'add sender', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'add sender to address book', 'message', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (187, 'Mail', NULL, 'en', 'axtextfield', NULL, NULL, 'search', 'search', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'mailbox search', 'find', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (188, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'hide mailbox list', 'hide mailbox list', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'hide mailbox list', 'view', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (189, 'Mail', NULL, 'en', 'axtextfield', NULL, NULL, NULL, 'mailbox', 'inbox', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'inbox', 'go to favorite mailbox', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (190, 'Mail', NULL, 'en', 'axtextfield', NULL, NULL, NULL, 'mailbox', 'sent', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sent', 'go to favorite mailbox', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (191, 'Mail', NULL, 'en', 'axtextfield', NULL, NULL, NULL, 'mailbox', 'notes', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'notes', 'go to favorite mailbox', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (192, 'Mail', NULL, 'en', 'axtextfield', NULL, NULL, NULL, 'mailbox', 'flagged', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'flagged', 'go to favorite mailbox', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (193, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'send', 'send', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'send', NULL, NULL, 'Command Shift D');"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (194, 'Mail', NULL, 'en', 'axbutton', NULL, NULL, 'attach', 'attach', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'attach files', 'message', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (195, 'Mail', NULL, 'en', 'axcheckbox', NULL, NULL, 'bold', 'bold', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'bold', 'style', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (196, 'Mail', NULL, 'en', 'axcheckbox', NULL, NULL, NULL, NULL, NULL, 'make text italic', NULL, NULL, NULL, NULL, NULL, NULL, 'italic', 'style', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (197, 'Mail', NULL, 'en', 'axcheckbox', NULL, NULL, 'underline', 'underline', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'underline', 'style', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (198, 'Mail', 6, 'en', 'axbutton', NULL, NULL, 'get mail', 'get mail', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'get new mail', 'mailbox', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (199, 'Mail', 6, 'en', 'axbutton', NULL, NULL, 'add sender', 'add sender', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'add sender to contacts', 'message', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (200, 'Mail', 5.2, 'de', 'axbutton', NULL, NULL, 'empfangen', 'empfangen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'alle neuen e-mails empfangen', 'e-mail', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (201, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'löschen', 'löschen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'löschen', 'edit', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (204, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'antworten', 'antworten', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'antworten', 'e-mail', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (205, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'an alle', 'an alle', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'an alle', 'e-mail', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (206, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'weiterleiten', 'weiterleiten', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'weiterleiten', 'e-mail', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (207, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'etikett', 'etikett', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'red', 'etikett', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (208, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'archivieren', 'archivieren', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'archivieren', 'e-mail', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (209, 'Mail', NULL, 'de', 'axmenuitem', NULL, NULL, 'eingang', NULL, NULL, NULL, NULL, NULL, NULL, 'axgroup', NULL, NULL, 'dont show', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (210, 'Mail', NULL, 'de', 'axmenuitem', NULL, NULL, 'gesendet', NULL, NULL, NULL, NULL, NULL, NULL, 'axgroup', NULL, NULL, 'dont show', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (211, 'Mail', NULL, 'de', 'axmenuitem', NULL, NULL, 'notizen', NULL, NULL, NULL, NULL, NULL, NULL, 'axgroup', NULL, NULL, 'dont show', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (212, 'Mail', NULL, 'de', 'axmenuitem', NULL, NULL, 'markiert', NULL, NULL, NULL, NULL, NULL, NULL, 'axgroup', NULL, NULL, 'dont show', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (213, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'neue e-mail', 'neue e-mail', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'neue e-mail', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (214, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'notiz', 'notiz', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'neue notiz', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (215, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'seitenleiste', 'seitenleiste', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'postfachliste ausblenden', 'darstellung', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (216, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'drucken', 'drucken', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'drucken', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (217, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'alle header', 'alle header', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'alle header', 'e-mail', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (218, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'ungelesen', 'ungelesen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'als ungelesen', 'markieren', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (219, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'gelesen', 'gelesen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'als gelesen', 'markieren', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (220, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'adressen', 'adressen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'adressen', 'fenster', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (221, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'kleiner', 'kleiner', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'kleiner', 'stil', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (222, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'größer', 'größer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'größer', 'stil', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (223, 'Mail', 5.2, 'de', 'axbutton', NULL, NULL, 'absender hinzufügen', 'absender hinzufügen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'absender zum adressbuch hinzufügen', 'e-mail', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (224, 'Mail', NULL, 'de', 'axtextfield', NULL, NULL, 'suchen', 'suchen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'postfach durchsuchen', 'find', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (225, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'postfachliste ausblenden', 'postfachliste ausblenden', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'postfachliste ausblenden', 'darstellung', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (226, 'Mail', NULL, 'de', 'axtextfield', NULL, NULL, NULL, 'postfach', 'eingang', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'eingang', 'gehe zum favoriten-postfach ', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (227, 'Mail', NULL, 'de', 'axtextfield', NULL, NULL, NULL, 'postfach', 'gesendet', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'gesendet', 'gehe zum favoriten-postfach ', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (228, 'Mail', NULL, 'de', 'axtextfield', NULL, NULL, NULL, 'postfach', 'notizen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'notizen', 'gehe zum favoriten-postfach ', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (229, 'Mail', NULL, 'de', 'axtextfield', NULL, NULL, NULL, 'postfach', 'markiert', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'markiert', 'gehe zum favoriten-postfach ', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (230, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'senden', 'senden', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'senden', NULL, NULL, 'Command Shift D');"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (231, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'anhang', 'anhang', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'anhänge hinzufügen ', 'ablage', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (232, 'Mail', NULL, 'de', 'axcheckbox', NULL, NULL, 'fett', 'fett', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'fett', 'stil', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (233, 'Mail', NULL, 'de', 'axcheckbox', NULL, NULL, NULL, NULL, NULL, 'text als kursivschrift', NULL, NULL, NULL, NULL, NULL, NULL, 'italic', 'stil', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (234, 'Mail', NULL, 'de', 'axcheckbox', NULL, NULL, 'unterstrichen', 'unterstrichen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'unterstrichen', 'stil', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (235, 'Mail', 6, 'de', 'axbutton', NULL, NULL, 'neue e-mail', 'neue e-mail', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'neue e-mails empfangen', 'postfach', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (236, 'Mail', 6, 'de', 'axbutton', NULL, NULL, 'absender hinzufügen', 'absender hinzufügen', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'absender zu kontakten hinzufügen', 'message', NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (237, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'postfachliste einblenden', 'postfachliste einblenden', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'postfachliste einblenden', NULL, NULL, NULL);"];
//  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (202, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'ist werbung', 'ist werbung', NULL, 'ausgewählte e-mails als unerwünschte werbung markieren', NULL, NULL, NULL, NULL, NULL, NULL, 'als unerwünschte werbung', 'markieren', NULL, NULL);"];
//   [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (203, 'Mail', NULL, 'de', 'axbutton', NULL, NULL, 'ist werbung', 'ist werbung', NULL, 'markierung als unerwünschte werbung für ausgewählte e-mails aufheben', NULL, NULL, NULL, NULL, NULL, NULL, 'als keine unerwünschte werbung', 'markieren', NULL, NULL);"];
//    
  
}



@end
