//
//  ServiceLogging.m
//  EVE
//
//  Created by Tobias Sommer on 9/10/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "ServiceLogging.h"
#import "ApplicationSettings.h"
#import "DDLog.h"
#import "StringUtilities.h"
#import "DateUtilities.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation ServiceLogging

+ (sqlite_int64) insertIndexingEntry :(NSString*) appName {
    __block sqlite_int64 rowid;
    [[[ApplicationSettings sharedApplicationSettings] getSharedDatabase] inDatabase:^(FMDatabase *db) {
    [db open];
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"insert into indexing_log Values  "];
    [query appendFormat:@"( %@, ",     NULL];
    [query appendFormat:@" '%@', ",     appName];
    [query appendFormat:@" '%@', ",     @""];
    [query appendFormat:@" '%@', ",     [[ApplicationSettings sharedApplicationSettings] userLanguage]];
    [query appendFormat:@" '%@', ",     [[ApplicationSettings sharedApplicationSettings] user]];
    [query appendFormat:@" '%@', ",     [DateUtilities getCurrentDateString]];
    [query appendFormat:@" '%@' )",     @"NO"];
      
    [db executeUpdate:query];
    
    rowid = [db lastInsertRowId];
    if ([db hadError])
      DDLogError(@"insertIndexingEntry Err %d: %@ \n query: %@", [db lastErrorCode], [db lastErrorMessage], query);
    
    [db close];
  }];
  
  return rowid;
}

+ (void) updateIndexingEntry :(sqlite_int64) rowId {
  
  [[[ApplicationSettings sharedApplicationSettings] getSharedDatabase] inDatabase:^(FMDatabase *db) {
    [db open];
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"update  indexing_log  "];
    [query appendFormat:@" set Finished = 'YES' "];
    [query appendFormat:@" WHERE rowid = %lli ",   rowId];
    
    [db executeUpdate:query];
    
    if ([db hadError])
      DDLogError(@"updateIndexingEntry Err %d: %@ \n query: %@", [db lastErrorCode], [db lastErrorMessage], query);
    
    [db close];
  }];
}

+ (BOOL) isIndexingActive :(NSString*) appName {
  __block BOOL returnValue;
  [[[ApplicationSettings sharedApplicationSettings] getSharedDatabase] inDatabase:^(FMDatabase *db) {
    [db open];
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"SELECT * FROM indexing_log "];
    [query appendFormat:@" WHERE AppName like '%@' ", appName];
    [query appendFormat:@" AND id = (select max(id) from indexing_log WHERE AppName like '%@' ) ", appName];
    
    FMResultSet *rs = [db executeQuery:query];
    
    if ([db hadError]) {
      DDLogError(@"updateIndexingEntry Err %d: %@ \n query: %@", [db lastErrorCode], [db lastErrorMessage], query);
      returnValue = YES;
    } else if ([rs next]) {
      returnValue = [[rs stringForColumn:@"Finished"] boolValue];
    } else {
      returnValue = YES;
    }
    [db close];
  }];
  
  return  returnValue;
}

@end
