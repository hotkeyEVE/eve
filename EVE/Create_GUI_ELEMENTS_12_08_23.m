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
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_ERROR;

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
        if ([db hadError])
          DDLogError(@"%d: %@", [db lastErrorCode], [db lastErrorMessage]);
      }
      [db close];
    }];

  }
}



@end
