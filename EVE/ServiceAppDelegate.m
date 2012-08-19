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

@implementation ServiceAppDelegate

+ (BOOL) checkIfAppAlreadyInDatabase :(NSString*) appName {
  FMDatabase *db = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
  
  FMResultSet *rs = [db executeQuery:@"select distinct rowid from menu_bar_shortcuts where AppName = ?", appName ];
  if ([rs next])
    return YES;
  else
    return NO;
}

+ (BOOL) checkIfAppIsDisabled :(NSString*) appName {
  ApplicationSettings *sharedApplicationSettings = [ApplicationSettings sharedApplicationSettings];
  FMDatabase *db = [sharedApplicationSettings getSharedDatabase];
  
  FMResultSet *rs = [db executeQuery:@"select distinct rowid from disabled_applications where AppName = ? and User = ? and Language = ?",
                     appName,
                     [sharedApplicationSettings user],
                     [sharedApplicationSettings language]
                     ];
  if ([rs next])
    return YES;
  else
    return NO;
}

@end
