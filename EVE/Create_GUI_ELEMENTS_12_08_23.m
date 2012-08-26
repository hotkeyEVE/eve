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
  FMDatabase *sharedDatabase = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
  NSMutableArray *allInserts = [[NSMutableArray alloc] init];
  
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'All', NULL, 'en', NULL, 'axclosebutton', 'close button', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'close window', NULL, NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'All', NULL, 'en', NULL, 'axminimizebutton', 'minimize button', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'minimize', NULL, NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'All', NULL, 'en', NULL, NULL, 'full screen button', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'enter full screen', NULL, NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'forward', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'forward', 'go', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'icon view', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'as icons', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'list view', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'as list', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'column view', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'as columns', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'cover flow view', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'as cover flow', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'name', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'name', 'arrange by', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'kind', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'kind', 'arrange by', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date last opened', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'date last opened', 'arrange by', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date added', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'date added', 'arrange by', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date modified', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'date modified', 'arrange by', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'size', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'size', 'arrange by', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'label', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'label', 'arrange by', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'none', NULL, NULL, NULL, NULL, 'arrange by', 'arrange', NULL, NULL, NULL, 'none', 'arrange by', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'eject', 'eject', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'eject', 'file', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'new folder', 'new folder', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'new folder', 'file', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'delete', 'delete', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'move to trash', 'file', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'connect', 'connect', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'connect to server', 'go', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'get info', 'get info', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'get info', 'file', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'search', 'search', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'find', 'file', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'quick look', 'quick look', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'quick look', 'file', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'all my files', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'all my files', 'go', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'airdrop', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'airdrop', 'go', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'desktop', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'desktop', 'go', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'home', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'home', 'go', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'applications', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'applications', 'go', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'documents', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'documents', 'go', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', 'axstatictext', NULL, NULL, '', '', 'downloads', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'downloads', 'go', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, NULL, 'back', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'back', 'go', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'name', NULL, NULL, NULL, NULL, 'sort by', NULL, NULL, NULL, NULL, 'name', 'sort by', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'kind', NULL, NULL, NULL, NULL, 'sort  by', NULL, NULL, NULL, NULL, 'kind', 'sort  by', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date last opened', NULL, NULL, NULL, NULL, 'sort by', NULL, NULL, NULL, NULL, 'date last opened', 'sort by', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date added', NULL, NULL, NULL, NULL, 'sort by', NULL, NULL, NULL, NULL, 'date added', 'sort by', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'date modified', NULL, NULL, NULL, NULL, 'sort by', NULL, NULL, NULL, NULL, 'date modified', 'sort by', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'size', NULL, NULL, NULL, NULL, 'sort by', NULL, NULL, NULL, NULL, 'size', 'sort by', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Finder', NULL, 'en', NULL, NULL, NULL, 'label', NULL, NULL, NULL, NULL, 'sort by', NULL, NULL, NULL, NULL, 'label', 'sort by', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'forward', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'forward', 'history', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'back', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'back', 'history', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'new tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'new tab', 'file', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'close', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'close tab', 'file', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Google Chrome', NULL, 'en', 'axradiobutton', NULL, 'tab', 'new tab', 'new tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'dont display', NULL, NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'reload', NULL, 'stop loading this page', NULL, NULL, NULL, NULL, NULL, NULL, 'stop', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'reload', NULL, 'reload this page', NULL, NULL, NULL, NULL, NULL, NULL, 'reload this page', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, 'home', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'home', 'history', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Google Chrome', NULL, 'en', 'axbutton', NULL, NULL, NULL, '1password', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1password', NULL, NULL, 'Command \\');"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Google Chrome', NULL, 'en', 'axtextfield', NULL, NULL, NULL, 'address', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'open location', 'file', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'back', 'back', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'back', 'history', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'forward', 'forward', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'forward', 'history', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, '1password', '1password', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1password', NULL, NULL, 'Command \\');"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'downloads', 'downloads', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'show downloads', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'web inspector', 'web inspector', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'show web inspector', 'develop', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'print', 'print', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'print', 'file', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'mail', 'mail', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'mail link to this page', 'file', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'zoom in', 'zoom in', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'zoom in', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'zoom out', 'zoom out', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'zoom out', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'bookmarks bar', 'bookmarks bar', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'bookmarks bar', NULL, NULL, 'Command Shift B');"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'add bookmark', 'add bookmark', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'add bookmark', 'bookmarks', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'bookmarks', 'bookmarks', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'bookmarks', NULL, NULL, 'Command Option B');"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'history', 'history', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'show all history', 'history', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'new tab', 'new tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'new tab', 'file', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'home', 'home', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'home', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'top sites', 'top sites', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'show top sites', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'reading list', 'reading list', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'reading list', NULL, NULL, 'Command Shift L');"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, NULL, NULL, NULL, 'show reader', NULL, NULL, NULL, NULL, NULL, NULL, 'show reader', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'reload', 'reload', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'reload page', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'stop', 'stop', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'stop', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axtextfield', NULL, NULL, 'address and search', 'address and search', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'open location', 'file', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', NULL, NULL, NULL, NULL, NULL, NULL, 'show reading list', NULL, NULL, NULL, NULL, NULL, NULL, 'show reading list', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', NULL, NULL, NULL, NULL, NULL, NULL, 'hide reading list', NULL, NULL, NULL, NULL, NULL, NULL, 'hide reading list', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', NULL, NULL, NULL, NULL, NULL, NULL, 'show all bookmarks', NULL, NULL, NULL, NULL, NULL, NULL, 'show all bookmarks', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', NULL, NULL, NULL, NULL, NULL, NULL, 'hide all bookmarks', NULL, NULL, NULL, NULL, NULL, NULL, 'hide all bookmarks', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', NULL, NULL, NULL, NULL, NULL, NULL, 'show top sites', NULL, NULL, NULL, NULL, NULL, NULL, 'show top sites', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', NULL, NULL, NULL, NULL, NULL, NULL, 'hide top sites', NULL, NULL, NULL, NULL, NULL, NULL, 'hide top sites', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'close tab', 'close tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'close tab', 'file', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'new tab', 'new tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'new tab', 'file', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, NULL, NULL, NULL, 'hide reader', NULL, NULL, NULL, NULL, NULL, NULL, 'hider reader', 'view', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axradiobutton', NULL, 'tab', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'dont display', '', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'autofill', 'autofill', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'autofill form', 'edit', NULL, NULL);"];
  [allInserts addObject:@"INSERT INTO \"gui_elements\" VALUES (NULL, 'Safari', NULL, 'en', 'axbutton', NULL, NULL, 'show all tabs', 'show all tabs', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'show all tabs', 'view', NULL, NULL);"];

  
  [sharedDatabase open];
  for(NSString *query in allInserts) {
    [sharedDatabase executeUpdate:query];
  }
  [sharedDatabase close];
  
}



@end
