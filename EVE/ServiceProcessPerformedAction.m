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

+ (UIElementItem*) getFixedGUIElement :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db  {
  [db open];
  
      DDLogInfo(@"Im in the guiElement Table:");
  
  NSMutableString *query = [[NSMutableString alloc] init];
  [query appendFormat:@"  select rowid, * from gui_elements"];
  [query appendFormat:@"  WHERE CASE WHEN AppName   ISNULL  THEN ifnull(AppName, 1)    else AppName = 'All' or AppName = '%@' end", theClickedUIElementItem.appName];
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
  [query appendFormat:@"   AND (CASE WHEN ParentTitleAttribute ISNULL THEN ifnull(ParentTitleAttribute, 1) else TitleAttribute = '%@' end) ) end ", theClickedUIElementItem.parentTitleAttribute];
  
  [query appendFormat:@"  AND   CASE WHEN (TitleAttribute NOTNULL AND DescriptionAttribute NOTNULL) then (TitleAttribute = '%@' OR DescriptionAttribute = '%@') ", theClickedUIElementItem.titleAttribute, theClickedUIElementItem.descriptionAttribute];
  [query appendFormat:@"   else ( (CASE WHEN DescriptionAttribute ISNULL THEN ifnull(DescriptionAttribute, 1) else DescriptionAttribute = '%@' end) ", theClickedUIElementItem.descriptionAttribute];
    [query appendFormat:@"   AND (CASE WHEN TitleAttribute ISNULL THEN ifnull(TitleAttribute, 1) else TitleAttribute = '%@' end) ) end ", theClickedUIElementItem.titleAttribute];

  DDLogInfo(@"Build query array");
  
  FMResultSet *rs = [db executeQuery:query];
  
  DDLogInfo(@"Performed db select");
  
  if ([db hadError]) {
    DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
//    [db close];
//    [db closeOpenResultSets];
    return NULL;
  }
  
    DDLogInfo(@"Try to open the result set");
  
  [rs next];
  
    theClickedUIElementItem.titleAttribute =  [rs stringForColumn:@"TitleAttributeReference"];
    theClickedUIElementItem.parentTitleAttribute = [rs stringForColumn:@"ParentTitleAttributeReference"];
    theClickedUIElementItem.shortcutString = [rs stringForColumn:@"ShortcutString"];
    
    DDLogInfo(@"Values Found:");
    DDLogInfo(@"titleAttribute : %@",     theClickedUIElementItem.titleAttribute);
    DDLogInfo(@"descriptionAttribute : %@",  theClickedUIElementItem.parentTitleAttribute);
    DDLogInfo(@"shortcutString : %@",      theClickedUIElementItem.shortcutString);
    
//  }
//  else {
//    DDLogInfo(@"--------->>>>>>>>>>>>>>>>>Nothing found in db");
//  }
  
  [db closeOpenResultSets];
  [db close];
  
  return theClickedUIElementItem;
}

+ (NSString*) getShortcutStringFromMenuBarItem :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db {
  [db open];
  
  NSMutableString *query = [[NSMutableString alloc] init];
  [query appendFormat:@"select rowid, * from menu_bar_shortcuts \n"];
  [query appendFormat:@"where TitleAttribute = '%@' \n", theClickedUIElementItem.titleAttribute];
  if (![theClickedUIElementItem.parentTitleAttribute isEqualToString:@""]) {
    [query appendFormat:@"and ParentTitleAttribute = '%@' \n", theClickedUIElementItem.parentTitleAttribute];
  }
  [query appendFormat:@"and AppName = '%@' and language = '%@' \n", theClickedUIElementItem.appName, theClickedUIElementItem.language];

  FMResultSet *rs = [db executeQuery:query];
  
  if ([db hadError]) {
    DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
      [db closeOpenResultSets];
      [db close];
    return NULL;
  }
  
//  DDLogInfo(@".........................................................");
  DDLogInfo(@"Search for menuItem");
//  DDLogInfo(@"GUIElement search with parentTitle:");  
//  DDLogInfo(@"--------------and-----------------------------");
//  DDLogInfo(@"titleAttribute : %@", theClickedUIElementItem.titleAttribute);
//  DDLogInfo(@"parenttitleAttribute : %@", theClickedUIElementItem.parentTitleAttribute);
//  DDLogInfo(@"appName : %@", theClickedUIElementItem.appName);
//  DDLogInfo(@"language : %@", theClickedUIElementItem.language);
//  DDLogInfo(@"------------------------------------------------------------");
//  
  if ([rs next]) {
    NSString *shortcutString = [rs stringForColumn:@"ShortcutString"];
    [db closeOpenResultSets];
    [db close];
    return shortcutString;
  } else {
    rs = [db executeQuery:@"select rowid, * from menu_bar_shortcuts where TitleAttribute = ? and AppName = ? and language = ?",
                        // without parentTitle
                        theClickedUIElementItem.titleAttribute,
                        theClickedUIElementItem.appName,
                        theClickedUIElementItem.language,
                        theClickedUIElementItem.titleAttribute
                        ];
  }
//  DDLogInfo(@"GUIElement search with title:");
//  DDLogInfo(@"--------------and-----------------------------");
//  DDLogInfo(@"titleAttribute : %@", theClickedUIElementItem.titleAttribute);
//  DDLogInfo(@"appName : %@", theClickedUIElementItem.appName);
//  DDLogInfo(@"language : %@", theClickedUIElementItem.language);
//  DDLogInfo(@".........................................................");
  
  if ([rs next]) {
    NSString *shortcutString = [rs stringForColumn:@"ShortcutString"];
    [db closeOpenResultSets];
    [db close];
    return shortcutString;
  }
  
  [db closeOpenResultSets];
  [db close];
  return NULL;
}

+ (void) insertDisplayedShortcutEntryToDatabase :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db {
  [db open];
  
  [db executeUpdate:@"insert into displayed_shortcuts (AppName, AppVersion, ShortcutString, Date, User, Language) values (?, ?, ?, ?, ?, ?)",
   theClickedUIElementItem.appName,
   theClickedUIElementItem.appVersion,
   theClickedUIElementItem.shortcutString,
   theClickedUIElementItem.date,
   theClickedUIElementItem.user,
   theClickedUIElementItem.language];
  
  if ([db hadError])
    DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
  
  DDLogInfo(@"Add displayed Shortcut to database");
  
  [db close];
}

+ (BOOL) checkIfShortcutAlreadySend :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db {
  [db open];
  
  FMResultSet *rs = [db executeQuery:@"select max(rowid),* FROM displayed_shortcuts"];
  if ([db hadError])
    DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);

  [rs next];
  // Check if the Shortcut String is equal or the timeIntverall is under 10 seconds 
  if([[rs stringForColumn:@"ShortcutString"] isEqualToString:theClickedUIElementItem.shortcutString]
     && [DateUtilities calculateTimeIntervalBetweenToDates:[rs stringForColumn:@"Date"] :[DateUtilities getCurrentDateString]] < 10) {
    [db closeOpenResultSets];
    [db close];
    return YES;
  }  else {
    [db closeOpenResultSets];
    [db close];
    return NO;
  }
}

+ (BOOL) checkIfShortcutIsDisabled :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db {
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
    return YES;
  }  else {
    [db closeOpenResultSets];
    [db close];
    return NO;
  }
}

+ (void) insertShortcutToLearnedTable :(FMDatabase*) db {
  [db open];
  
  NSDictionary *clickContext = [[ApplicationSettings sharedApplicationSettings] getSharedClickContext];
  if(clickContext) {
  
  [db executeUpdate:@"insert into learned_shortcuts ( AppName, AppVersion, TitleAttribute, ShortcutString, Date, User, Language) values (?, ?, ?, ?, ?, ?, ?)",
   [clickContext valueForKey:@"AppName"],
   [clickContext valueForKey:@"AppVersion"],
   [clickContext valueForKey:@"TitleAttribute"],
   [clickContext valueForKey:@"ShortcutString"],
   [clickContext valueForKey:@"Date"],
   [clickContext valueForKey:@"User"],
   [clickContext valueForKey:@"Language"]
   ];

  if ([db hadError])
    DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
  }
  
  [db close];
}
  
+ (void) insertApplicationToDisabledApplicationTable :(FMDatabase*) db {
  [db open];
  
    NSDictionary *clickContext = [[ApplicationSettings sharedApplicationSettings] getSharedClickContext];
    if(clickContext) {
      [db executeUpdate:@"insert into disabled_applications ( AppName, AppVersion, Date, User, Language) values (?, ?, ?, ?, ?)",
       [clickContext valueForKey:@"AppName"],
       [clickContext valueForKey:@"AppVersion"],
       [clickContext valueForKey:@"Date"],
       [clickContext valueForKey:@"User"],
       [clickContext valueForKey:@"Language"]
       ];
      
      if ([db hadError])
        DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }

  [db close];
}



@end
	