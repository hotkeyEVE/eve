//
//  ServiceAppDelegate.m
//  EVE
//
//  Created by Tobias Sommer on 8/18/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "ServiceAppDelegate.h"
#import "ApplicationSettings.h"
#import "UIElementUtilities.h"
#import "StringUtilities.h"
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation ServiceAppDelegate

+ (BOOL) checkIfAppAlreadyInDatabase {
  __block  BOOL alreadyInDatabase;
  [[[ApplicationSettings sharedApplicationSettings] getSharedDatabase] inDatabase:^(FMDatabase *db) {
    [db open];
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"SELECT rowid from menu_bar_shortcuts "];
    [query appendFormat:@"where AppName LIKE '%@' LIMIT 1", [StringUtilities getActiveApplicationName]];
    FMResultSet *rs = [db executeQuery:query];
      if ([db hadError]) {
        DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
      } else {
      if ([rs next]) {
        [db closeOpenResultSets];
        [db close];
        alreadyInDatabase = YES;
      } else {
        [db closeOpenResultSets];
        [db close];
         alreadyInDatabase = NO;
      }
    }
  }];
  return alreadyInDatabase;
}

+ (BOOL) checkIfAppIsDisabled {
  ApplicationSettings *sharedApplicationSettings = [ApplicationSettings sharedApplicationSettings];
  
      __block  BOOL returnValue;
      [[sharedApplicationSettings getSharedDatabase] inDatabase:^(FMDatabase *db) {
      [db open];
      //    FMDatabase *db = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
      //    [db open];
      [db open];
    
    FMResultSet *rs = [db executeQuery:@"select rowid from disabled_applications where AppName = ? and User = ? and Language = ?",
                       [StringUtilities getActiveApplicationName],
                       [sharedApplicationSettings user],
                       [sharedApplicationSettings userLanguage]
                       ];
    if ([db hadError]) {
      DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    } else {
      if ([rs next]){
        [db closeOpenResultSets];
        [db close];
        returnValue = YES;
      }  else {
        [db closeOpenResultSets];
        [db close];
        returnValue = NO;
      }
    }
  }];
  return returnValue;
}

+ (BOOL) checkGUISupport {
  
  ApplicationSettings *sharedApplicationSettings = [ApplicationSettings sharedApplicationSettings];
  __block BOOL returnValue;
  [[sharedApplicationSettings getSharedDatabase] inDatabase:^(FMDatabase *db) {
    [db open];
  
      FMResultSet *rs = [db executeQuery:@"select rowid, * FROM gui_supported_applications where AppName = ? and Language = ? and GUISupport = 'YES'",
                         [StringUtilities getActiveApplicationName],
                        // [StringUtilities getActiveApplicationVersionString],
                         [[ApplicationSettings sharedApplicationSettings] userLanguage]
                         ];
      if ([db hadError])
        DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
      
    if([rs next]) {
          [db closeOpenResultSets];
          [db close];
          returnValue = YES;
      } else {
          [db closeOpenResultSets];
          [db close];
          returnValue = NO;
      }
    }];  
  return returnValue;
}

+ (int) countShortcutsForActiveApp {
  __block int count = 0;
  [[[ApplicationSettings sharedApplicationSettings] getSharedDatabase] inDatabase:^(FMDatabase *db) {
    [db open];
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"select count(*) FROM menu_bar_shortcuts "];
    [query appendFormat:@"where AppName Like '%@' and Language = '%@' ", [StringUtilities getActiveApplicationName],
     [[ApplicationSettings sharedApplicationSettings] userLanguage]];
    
    FMResultSet *rs = [db executeQuery:query];
    if ([db hadError])
      DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    if([rs next]) {
      count = [rs intForColumnIndex:0];
    }
    [db closeOpenResultSets];
    [db close];
  }];
  return count;
}

+ (void) resetDatabase {
  [[[ApplicationSettings sharedApplicationSettings] getSharedDatabase] inDatabase:^(FMDatabase *db) {
    [db open];

    [db executeUpdate:@"DELETE FROM menu_bar_shortcuts;"];
    [db executeUpdate:@"DELETE FROM sqlite_sequence WHERE name = 'menu_bar_shortcuts';"];
    [db executeUpdate:@"DELETE FROM indexing_log;"];
    [db executeUpdate:@"DELETE FROM disabled_applications;"];
    [db executeUpdate:@"DELETE FROM displayed_shortcuts;"];
    [db executeUpdate:@"DELETE FROM learned_shortcuts;"];
    
    if ([db hadError])
      DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);

  }];
}

@end
