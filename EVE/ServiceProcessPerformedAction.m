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
  [query appendFormat:@"  AND   CASE WHEN ParentAttribute ISNULL THEN ifnull(ParentAttribute, 1) else ParentAttribute = '%@' end", theClickedUIElementItem.parentRoleAttribute];
  [query appendFormat:@"  AND   CASE WHEN (TitleAttribute NOTNULL AND DescriptionAttribute NOTNULL) then (TitleAttribute = '%@' OR DescriptionAttribute = '%@') ", theClickedUIElementItem.titleAttribute, theClickedUIElementItem.descriptionAttribute];
  [query appendFormat:@"   else ( (CASE WHEN DescriptionAttribute ISNULL THEN ifnull(DescriptionAttribute, 1) else DescriptionAttribute = '%@' end) ", theClickedUIElementItem.descriptionAttribute];
    [query appendFormat:@"   AND (CASE WHEN TitleAttribute ISNULL THEN ifnull(TitleAttribute, 1) else TitleAttribute = '%@' end) ) end ", theClickedUIElementItem.titleAttribute];

  FMResultSet *rs = [db executeQuery:query];

  
  NSLog(@".........................................................");
  DDLogInfo(@"Search for GUIElement");
  NSLog(@".........................................................");
  NSLog(@"GUIElement search with:");
  NSLog(@"titleAttribute : %@", theClickedUIElementItem.titleAttribute);
  NSLog(@"descriptionAttribute : %@", theClickedUIElementItem.descriptionAttribute);
  NSLog(@"valueAttribute : %@", theClickedUIElementItem.valueAttribute);
  NSLog(@"helpAttribute : %@", theClickedUIElementItem.helpAttribute);
  NSLog(@"subroleAttribute : %@", theClickedUIElementItem.subroleAttribute);
  NSLog(@"roleDescriptionAttribute : %@", theClickedUIElementItem.roleDescriptionAttribute);
  NSLog(@"--------------and-----------------------------");
  NSLog(@"roleAttribute: %@", theClickedUIElementItem.roleAttribute);
  NSLog(@"appName : %@", theClickedUIElementItem.appName);
  NSLog(@"language : %@", theClickedUIElementItem.language);
  NSLog(@".........................................................");
  DDLogInfo(@"Search for GUIElement");
  NSLog(@".........................................................");
  
  if ([db hadError]) {
    DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    return NULL;
  }
  
  if ([rs next]) {
    
    theClickedUIElementItem.titleAttribute =  [rs stringForColumn:@"TitleAttributeReference"];
    theClickedUIElementItem.parentTitleAttribute = [rs stringForColumn:@"ParentTitleAttributeReference"];
    theClickedUIElementItem.shortcutString = [rs stringForColumn:@"ShortcutString"];
    
    DDLogInfo(@"Values Found:");
    NSLog(@".........................................................");
    NSLog(@"titleAttribute : %@",     theClickedUIElementItem.titleAttribute);
    NSLog(@"descriptionAttribute : %@",  theClickedUIElementItem.parentTitleAttribute);
    NSLog(@"shortcutString : %@",      theClickedUIElementItem.shortcutString);
    
  }
  else {
    NSLog(@".........................................................");
    DDLogInfo(@"--------->>>>>>>>>>>>>>>>>Nothing found in db");
    NSLog(@".........................................................");
  }
  
    return theClickedUIElementItem;
}

+ (NSString*) getShortcutStringFromMenuBarItem :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db {
  
  NSMutableString *query = [[NSMutableString alloc] init];
  [query appendString:@"select rowid, * from menu_bar_shortcuts \n"];
  [query appendString:@"where TitleAttribute = ? \n"];
  if (![theClickedUIElementItem.parentTitleAttribute isEqualToString:@""]) {
    [query appendString:@"and ParentTitleAttribute = ? \n"];
  }
  [query appendString:@"and AppName = ? and language = ? \n"];

  FMResultSet *rs = [db executeQuery:query,
                     theClickedUIElementItem.titleAttribute,
                     theClickedUIElementItem.parentTitleAttribute,
                     theClickedUIElementItem.appName,
                     theClickedUIElementItem.language
                     ];
  
  if ([db hadError]) {
    DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    return NULL;
  }
  
//  NSLog(@".........................................................");
//  DDLogInfo(@"Search for menuItem");
//  NSLog(@"GUIElement search with parentTitle:");  
//  NSLog(@"--------------and-----------------------------");
//  NSLog(@"titleAttribute : %@", theClickedUIElementItem.titleAttribute);
//  NSLog(@"parenttitleAttribute : %@", theClickedUIElementItem.parentTitleAttribute);
//  NSLog(@"appName : %@", theClickedUIElementItem.appName);
//  NSLog(@"language : %@", theClickedUIElementItem.language);
//  NSLog(@"------------------------------------------------------------");
//  
  if ([rs next]) {
      return [rs stringForColumn:@"ShortcutString"];
  } else {
    rs = [db executeQuery:@"select rowid, * from menu_bar_shortcuts where TitleAttribute = ? and AppName = ? and language = ?",
                        // without parentTitle
                        theClickedUIElementItem.titleAttribute,
                        theClickedUIElementItem.appName,
                        theClickedUIElementItem.language,
                        theClickedUIElementItem.titleAttribute
                        ];
  }
//  NSLog(@"GUIElement search with title:");
//  NSLog(@"--------------and-----------------------------");
//  NSLog(@"titleAttribute : %@", theClickedUIElementItem.titleAttribute);
//  NSLog(@"appName : %@", theClickedUIElementItem.appName);
//  NSLog(@"language : %@", theClickedUIElementItem.language);
//  NSLog(@".........................................................");
  
  if ([rs next]) {
      return [rs stringForColumn:@"ShortcutString"];
  }
  return NULL;
}

+ (void) insertDisplayedShortcutEntryToDatabase :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db {

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
}

+ (BOOL) checkIfShortcutAlreadySend :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db {
    
  FMResultSet *rs = [db executeQuery:@"select max(rowid),* FROM displayed_shortcuts"];
  if ([db hadError])
    DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);

  [rs next];
  
  // Check if the Shortcut String is equal or the timeIntverall is under 10 seconds 
  if([[rs stringForColumn:@"ShortcutString"] isEqualToString:theClickedUIElementItem.shortcutString]
     && [DateUtilities calculateTimeIntervalBetweenToDates:[rs stringForColumn:@"Date"] :[DateUtilities getCurrentDateString]] < 10)
    return YES;
  else
    return NO;
}

+ (BOOL) checkIfShortcutIsDisabled :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db {
  
  FMResultSet *rs = [db executeQuery:@"select rowid, * FROM learned_shortcuts where AppName = ? and ShortcutString = ? and User = ? and Language = ?",
                     theClickedUIElementItem.appName,
                     theClickedUIElementItem.shortcutString,
                     theClickedUIElementItem.user,
                     theClickedUIElementItem.language];
  if ([db hadError])
    DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
  
  if([rs next])
    return YES;
  else
    return NO;
}

+ (void) insertShortcutToLearnedTable {
  FMDatabase *db = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
  
  NSDictionary *clickContext = [[ApplicationSettings sharedApplicationSettings] getSharedClickContext];
  if(clickContext) {
  
  [db executeUpdate:@"insert into learned_shortcuts (AppName, AppVersion, TitleAttribute, ShortcutString, Date, User, Language) values (?, ?, ?, ?, ?, ?, ?)",
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
}
  
+ (void) insertApplicationToDisabledApplicationTable {
    FMDatabase *db = [[ApplicationSettings sharedApplicationSettings] getSharedDatabase];
    
    NSDictionary *clickContext = [[ApplicationSettings sharedApplicationSettings] getSharedClickContext];
    if(clickContext) {
      [db executeUpdate:@"insert into disabled_applications (AppName, AppVersion, Date, User, Language) values (?, ?, ?, ?, ?)",
       [clickContext valueForKey:@"AppName"],
       [clickContext valueForKey:@"AppVersion"],
       [clickContext valueForKey:@"Date"],
       [clickContext valueForKey:@"User"],
       [clickContext valueForKey:@"Language"]
       ];
      
      if ([db hadError])
        DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
}



@end
	