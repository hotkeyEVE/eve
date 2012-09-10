//
//  ServiceProcessPerformedAction.m
//  EVE
//
//  Created by Tobias Sommer on 8/17/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "ServiceProcessPerformedAction.h"
#import "ApplicationSettings.h"
#import "Constants.h"
#import "DateUtilities.h"
#import "ApplicationSettings.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation ServiceProcessPerformedAction

+ (UIElementItem*) getFixedGUIElement :(UIElementItem*) theClickedUIElementItem :(FMDatabaseQueue*) queue  {
  
  NSMutableString *query = [[NSMutableString alloc] init];
  [query appendFormat:@"  select rowid, * from gui_elements"];
  [query appendFormat:@"  WHERE CASE WHEN AppName ISNULL  THEN ifnull(AppName, 1) else AppName = 'All' or ( AppName = '%@' or AppName2 = '%@') end", theClickedUIElementItem.appName, theClickedUIElementItem.appName];
  [query appendFormat:@"  AND   CASE WHEN AppVersion ISNULL THEN ifnull(AppVersion, 1) else AppVersion = '%@' end", theClickedUIElementItem.appVersion];
  [query appendFormat:@"  AND   Language = '%@'", theClickedUIElementItem.language];
  [query appendFormat:@"  AND   CASE WHEN RoleAttribute ISNULL THEN ifnull(RoleAttribute, 1) else RoleAttribute = '%@' end", theClickedUIElementItem.roleAttribute];
  [query appendFormat:@"  AND   CASE WHEN SubroleAttribute ISNULL THEN ifnull(SubroleAttribute, 1) else SubroleAttribute = '%@' end", theClickedUIElementItem.subroleAttribute];
  [query appendFormat:@"	AND   CASE WHEN RoleDescriptionAttribute ISNULL THEN ifnull(RoleDescriptionAttribute, 1) else RoleDescriptionAttribute = '%@' end", theClickedUIElementItem.roleDescriptionAttribute];
  [query appendFormat:@"  AND   CASE WHEN ValueAttribute ISNULL THEN ifnull(ValueAttribute, 1) else ValueAttribute = '%@' end", theClickedUIElementItem.valueAttribute];
  [query appendFormat:@"  AND   CASE WHEN HelpAttribute ISNULL THEN ifnull(HelpAttribute, 1) else HelpAttribute = '%@' end", theClickedUIElementItem.helpAttribute];
  [query appendFormat:@"  AND   CASE WHEN ParentAttribute ISNULL THEN ifnull(ParentAttribute, 1) else ParentAttribute = '%@' end", theClickedUIElementItem.parentRoleAttribute];
  
  [query appendFormat:@"  AND   CASE WHEN (ParentTitleAttribute NOTNULL AND ParentDescriptionAttribute NOTNULL) then (ParentTitleAttribute = '%@' OR ParentDescriptionAttribute = '%@') ", theClickedUIElementItem.parentTitleAttribute, theClickedUIElementItem.parentDescriptionAttribute];
  [query appendFormat:@"   else ( (CASE WHEN ParentDescriptionAttribute ISNULL THEN ifnull(ParentDescriptionAttribute, 1) else ParentDescriptionAttribute = '%@' end) ", theClickedUIElementItem.parentDescriptionAttribute];
  [query appendFormat:@"   AND (CASE WHEN ParentTitleAttribute ISNULL THEN ifnull(ParentTitleAttribute, 1) else ParentTitleAttribute = '%@' end) ) end ", theClickedUIElementItem.parentTitleAttribute],
   [query appendFormat:@"  AND   CASE WHEN (TitleAttribute NOTNULL AND DescriptionAttribute NOTNULL) then (TitleAttribute = '%@' OR DescriptionAttribute = '%@') ", theClickedUIElementItem.titleAttribute, theClickedUIElementItem.descriptionAttribute];
  [query appendFormat:@"   else ( (CASE WHEN DescriptionAttribute ISNULL THEN ifnull(DescriptionAttribute, 1) else DescriptionAttribute = '%@' end) ", theClickedUIElementItem.descriptionAttribute];
    [query appendFormat:@"   AND (CASE WHEN TitleAttribute ISNULL THEN ifnull(TitleAttribute, 1) else TitleAttribute = '%@' end) ) end ", theClickedUIElementItem.titleAttribute];
  
    __block NSMutableArray *allResults = [[NSMutableArray alloc] init];
  [queue inDatabase:^(FMDatabase *db) {
    [db open];
    FMResultSet *rs = [db executeQuery:query];
    
    if ([db hadError]) {
      DDLogError(@" getFixedGUIElement Err %d: %@ \n Query: %@" , [db lastErrorCode], [db lastErrorMessage], query);
      [db close];
    } else {
//        DDLogInfo(@"getFixedGUIElement Table: %@", query);
    }
    
    while([rs next]) {
      NSMutableDictionary *oneResult = [[NSMutableDictionary alloc] init];
      [oneResult setValue:[[rs stringForColumn:@"TitleAttributeReference"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"TitleAttribute"];
      [oneResult setValue:[rs stringForColumn:@"ParentTitleAttributeReference"] forKey:@"ParentTitleAttributeReference"];
      [oneResult setValue:[rs stringForColumn:@"ShortcutString"] forKey:@"ShortcutString"];
      
      [allResults addObject:oneResult];
    }  
  }];

  for (NSDictionary *oneResult in allResults) {
      theClickedUIElementItem.titleAttribute =  [oneResult valueForKey:@"TitleAttribute"];
      theClickedUIElementItem.parentTitleAttribute = [oneResult valueForKey:@"ParentTitleAttributeReference"];
      theClickedUIElementItem.shortcutString = [oneResult valueForKey:@"ShortcutString"];
    
      // If there is a hard coded Shortcut String in gui_elements database stop working and return the element
      if ([theClickedUIElementItem.shortcutString length] > 0) {
        DDLogInfo(@"I found a hardcoded Shortcut: %@", theClickedUIElementItem.shortcutString);
        break;
      } else {
        DDLogInfo(@"Try to find a entry in the menu_bar database table");
        theClickedUIElementItem.shortcutString = [self getShortcutStringFromMenuBarItem :theClickedUIElementItem :queue];
      }
    }
  
  return theClickedUIElementItem;
}

+ (NSString*) getShortcutStringFromMenuBarItem :(UIElementItem*) theClickedUIElementItem :(FMDatabaseQueue*) queue {
  __block NSString *shortcutString;
  
  NSMutableString *query = [[NSMutableString alloc] init];
  [query appendFormat:@"select rowid, * from menu_bar_shortcuts \n"];
  [query appendFormat:@"where TitleAttribute LIKE '%@' \n", theClickedUIElementItem.titleAttribute];
  if (![theClickedUIElementItem.parentTitleAttribute isEqualToString:@""]) {
    [query appendFormat:@"and ParentTitleAttribute = '%@' \n", theClickedUIElementItem.parentTitleAttribute];
  }
  [query appendFormat:@"and AppName LIKE '%@' and language LIKE '%@' \n", theClickedUIElementItem.appName, theClickedUIElementItem.language];

  [queue inDatabase:^(FMDatabase *db) {
    [db open];
    FMResultSet *rs = [db executeQuery:query];
    
    if ([db hadError]) {
        [db closeOpenResultSets];
        [db close];
    } else {
        if ([rs next]) {
          shortcutString = [rs stringForColumn:@"ShortcutString"];
        } else {
          rs = [db executeQuery:@"select rowid, * from menu_bar_shortcuts where TitleAttribute LIKE ? and AppName LIKE ? and language = ?",
                // without parentTitle
                theClickedUIElementItem.titleAttribute,
                theClickedUIElementItem.appName,
                theClickedUIElementItem.language];
        }      
      if ([rs next]) {
        shortcutString = [rs stringForColumn:@"ShortcutString"];
      }
    }
    
    if ( [shortcutString length] > 0 ) {
        DDLogInfo(@"Found shortcut entry in the menu_bar_shortcut Table: %@", shortcutString);
    } else {
        DDLogInfo(@"getShortcutStringFromMenuBarItem Nothing found \n query: %@", query);
    }
      [db closeOpenResultSets];
      [db close];
  }];


  return shortcutString;
}

+ (void) insertDisplayedShortcutEntryToDatabase :(UIElementItem*) theClickedUIElementItem :(FMDatabaseQueue*) queue {
  
  [queue inDatabase:^(FMDatabase *db) {
    [db open];
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"insert into displayed_shortcuts (AppName, AppVersion, ShortcutString, Date, User, Language) "];
    [query appendFormat:@" values ('%@',  ", theClickedUIElementItem.appName];
    [query appendFormat:@" '%@', ",      theClickedUIElementItem.appVersion];
    [query appendFormat:@" '%@',  ",      theClickedUIElementItem.shortcutString];
    [query appendFormat:@" '%@',  ",      theClickedUIElementItem.date];
    [query appendFormat:@" '%@',  ",      theClickedUIElementItem.user];
    [query appendFormat:@" '%@' )",      theClickedUIElementItem.language];
    
    [db executeUpdate:query];
    
    if ([db hadError])
      DDLogError(@"getFixedGUIElement Err %d: %@ \n query: %@", [db lastErrorCode], [db lastErrorMessage], query);

    [db close];
  }];
}

+ (BOOL) checkIfShortcutAlreadySend :(UIElementItem*) theClickedUIElementItem :(FMDatabaseQueue*) queue {
  __block  BOOL alreadSend;
  [queue inDatabase:^(FMDatabase *db) {
    [db open];
    
    FMResultSet *rs = [db executeQuery:@"select max(rowid),* FROM displayed_shortcuts"];
    if ([db hadError])
      DDLogError(@"getFixedGUIElementErr %d: %@", [db lastErrorCode], [db lastErrorMessage]);

    [rs next];
    // Check if the Shortcut String is equal or the timeIntverall is under 10 seconds 
    if([[rs stringForColumn:@"ShortcutString"] isEqualToString:theClickedUIElementItem.shortcutString]
       && [DateUtilities calculateTimeIntervalBetweenToDates:[rs stringForColumn:@"Date"] :[DateUtilities getCurrentDateString]] < 10) {
      [db closeOpenResultSets];
      [db close];
      DDLogInfo(@"This Shortcut has already been send! Wait 10s!");
      alreadSend = YES;
    }  else {
      [db closeOpenResultSets];
      [db close];
      alreadSend = NO;
    }
  }];

  return alreadSend;
}

+ (BOOL) checkIfShortcutIsDisabled :(UIElementItem*) theClickedUIElementItem :(FMDatabaseQueue*) queue {
  
  __block  BOOL appIsDisabled;
  [queue inDatabase:^(FMDatabase *db) {
  [db open];
  
  FMResultSet *rs = [db executeQuery:@"select rowid, * FROM learned_shortcuts where AppName = ? and ShortcutString = ? and User = ? and Language = ?",
                     theClickedUIElementItem.appName,
                     theClickedUIElementItem.shortcutString,
                     theClickedUIElementItem.user,
                     theClickedUIElementItem.language];
  if ([db hadError])
    DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
  
  if([rs next]) {
      [db closeOpenResultSets];
      [db close];
    DDLogInfo(@"App is disabled!");
    appIsDisabled = YES;
  }  else {
    [db closeOpenResultSets];
    [db close];
    appIsDisabled = NO;
  }
  }];
  return appIsDisabled;
}

+ (BOOL) insertShortcutToLearnedTable :(FMDatabaseQueue*) queue {
  __block  BOOL returnValue = true;
  
  [queue inDatabase:^(FMDatabase *db) {
    [db open];

    
    NSDictionary *clickContext = [[ApplicationSettings sharedApplicationSettings] getSharedClickContext];
    if(clickContext) {
    
      NSMutableString *query = [[NSMutableString alloc] init];
      [query appendFormat:@"insert into displayed_shortcuts insert into learned_shortcuts ( AppName, AppVersion, TitleAttribute, ShortcutString, Date, User, Language) "];
      [query appendFormat:@" values ('%@',  ",  [clickContext valueForKey:@"AppName"]];
      [query appendFormat:@" '%@', ",          [clickContext valueForKey:@"AppVersion"]];
      [query appendFormat:@" '%@',  ",          [clickContext valueForKey:@"TitleAttribute"]];
      [query appendFormat:@" '%@',  ",          [clickContext valueForKey:@"ShortcutString"]];
      [query appendFormat:@" '%@',  ",          [clickContext valueForKey:@"Date"]];
      [query appendFormat:@" '%@',  ",           [clickContext valueForKey:@"User"]];
      [query appendFormat:@" '%@' )",          [clickContext valueForKey:@"Language"]];
      
      
      [db executeUpdate:query];
    
      if ([db hadError]) {
        DDLogError(@"insertShortcutToLearnedTable Err %d: %@ \n query: %@", [db lastErrorCode], [db lastErrorMessage], query);
        [db close];
        returnValue = false;
      }
    }
    
    [db close];
    }];
  return true;
}
  
+ (BOOL) insertApplicationToDisabledApplicationTable :(FMDatabaseQueue*) queue {
  
  __block  BOOL returnValue = true;
  [queue inDatabase:^(FMDatabase *db) {
      [db open];
      
        NSDictionary *clickContext = [[ApplicationSettings sharedApplicationSettings] getSharedClickContext];
        if(clickContext) {
          
          NSMutableString *query = [[NSMutableString alloc] init];
          [query appendFormat:@"insert into disabled_applications ( AppName, AppVersion, Date, User, Language) "];
          [query appendFormat:@" values ('%@',  ",  [clickContext valueForKey:@"AppName"]];
          [query appendFormat:@" '%@', ",          [clickContext valueForKey:@"AppVersion"]];
          [query appendFormat:@" '%@',  ",          [clickContext valueForKey:@"Date"]];
          [query appendFormat:@" '%@',  ",           [clickContext valueForKey:@"User"]];
          [query appendFormat:@" '%@' )",          [clickContext valueForKey:@"Language"]];
          
          [db executeUpdate:query];
          
          if ([db hadError]) {
            DDLogError(@"insertShortcutToLearnedTable Err %d: %@ \n query: %@", [db lastErrorCode], [db lastErrorMessage], query);
            [db close];
            returnValue = false;
          }
        }

      [db close];
    }];
  
  return returnValue;
}



@end
	