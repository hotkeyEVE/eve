//
//  ApplicationSettings.m
//  EVE
//
//  Created by Tobias Sommer on 8/15/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "ApplicationSettings.h"
#import "NSFileManager+DirectoryLocations.h"
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation ApplicationSettings

@synthesize user;
@synthesize applicationSupportDictionary;
@synthesize sharedAppDelegate;
@synthesize sharedDatabase;
@synthesize sharedClickContext;
@synthesize menuBar;
@synthesize userLanguage;

+ (id) sharedApplicationSettings {
  static ApplicationSettings *sharedApplicationSettings = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedApplicationSettings = [[self alloc] init];
  });
  return sharedApplicationSettings;
}

- (id)init {
  if (self = [super init]) {
    userLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    user = NSUserName();
    applicationSupportDictionary = [[NSFileManager defaultManager] applicationSupportDirectory];
    sharedDatabase = [self loadDatabase];
  }
  
  return self;
}

- (FMDatabase*) loadDatabase {
  NSString *dbPath = [applicationSupportDictionary stringByAppendingPathComponent:[NSString stringWithFormat:@"database.db"]];
  FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
  
  
  NSLog(@"Is SQLite compiled with it's thread safe options turned on? %@!", [FMDatabase isSQLiteThreadSafe] ? @"Yes" : @"No");
  {
    // -------------------------------------------------------------------------------
    // Un-opened database check.
    [db executeQuery:@"select * from table"];
    NSLog(@"%d: %@", [db lastErrorCode], [db lastErrorMessage]);
  }
  
  if (![db open]) {
    DDLogError(@"Could not open db.");
    [NSApp terminate:self];
  }
  
  db.logsErrors = YES;
  
  // Clear Databases
 // [db executeUpdate:@"DELETE FROM menu_bar_shortcuts"];
  
  DDLogInfo(@"Load database...");
  
  return db;
}


@end
