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
  FMDatabase *db = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
  
  FMResultSet *rs = [db executeQuery:@"select distinct rowid from menu_bar_shortcuts where AppName = ?", [StringUtilities getActiveApplicationName]];
  if ([rs next])
    return YES;
  else
    return NO;
}

+ (BOOL) checkIfAppIsDisabled {
  ApplicationSettings *sharedApplicationSettings = [ApplicationSettings sharedApplicationSettings];
  FMDatabase *db = [sharedApplicationSettings getSharedDatabase];
  
  FMResultSet *rs = [db executeQuery:@"select distinct rowid from disabled_applications where AppName = ? and User = ? and Language = ?",
                     [StringUtilities getActiveApplicationName],
                     [sharedApplicationSettings user],
                     [sharedApplicationSettings userLanguage]
                     ];
  if ([rs next])
    return YES;
  else
    return NO;
}

+ (BOOL) checkGUISupport {
  FMDatabase *db = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
  
  FMResultSet *rs = [db executeQuery:@"select rowid, * FROM gui_supported_applications where AppName = ? and Language = ? and GUISupport = 'YES'",
                     [StringUtilities getActiveApplicationName],
                    // [StringUtilities getActiveApplicationVersionString],
                     [[ApplicationSettings sharedApplicationSettings] userLanguage]
                     ];
  if ([db hadError])
    NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
  

  
  DDLogInfo(@"%@", [StringUtilities getActiveApplicationName]);
  DDLogInfo(@"%@",[[ApplicationSettings sharedApplicationSettings] userLanguage]);
             
  if([rs next]) {
      DDLogInfo(@"%@ has GUISupport!", [StringUtilities getActiveApplicationName]);
      return YES;
  } else {
       DDLogInfo(@"%@ has NO GUISupport!", [StringUtilities getActiveApplicationName]);
      return NO;
  }
}

@end
