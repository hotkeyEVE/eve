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

+ (NSString*) getShortcutStringFromGUIElement :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db {

  NSString *theShortcut = NULL;
    
  FMResultSet *rs = [db executeQuery:@"select rowid, * from gui_elements "
      " where 		( case when SubroleAttribute        <> '' then SubroleAttribute = ?         else SubroleAttribute is NULL end "
      "           and case when RoleDescriptionAttribute <> '' then RoleDescriptionAttribute = ? else RoleDescriptionAttribute is NULL end "
      "           and  case when ValueAttribute           <> '' then ValueAttribute = ?            else ValueAttribute is NULL end "
      "           and  case when helpAttribute            <> '' then helpAttribute = ?            else helpAttribute is null end ) "
      "           and (  TitleAttribute = ? or DescriptionAttribute = ?  )      "
      "           and ( case when RoleAttribute         <> '' then RoleAttribute = ?            else RoleAttribute is null end "
      "           and  case when AppName                <> '' then AppName = ?                  else AppName is null end "
      "           and  case when AppVersion             <> '' then AppVersion = ?               else AppVersion is null end "
      "           and  case when language               <> '' then language = ?                 else language is null end ) ",
                     theClickedUIElementItem.subroleAttribute,
                     theClickedUIElementItem.roleDescriptionAttribute,
                     theClickedUIElementItem.valueAttribute,
                     theClickedUIElementItem.helpAttribute,
                     theClickedUIElementItem.titleAttribute,
                     theClickedUIElementItem.descriptionAttribute,
                     theClickedUIElementItem.roleAttribute,
                     theClickedUIElementItem.appName,
                     theClickedUIElementItem.appVersion,
                     theClickedUIElementItem.language];


  
  NSLog(@".........................................................");
  DDLogInfo(@"Search for GUIElement");
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

  
  if ([db hadError]) {
    DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    return NULL;
  }
  
  if ([rs next]) {
    
    NSString *titleAttributeReference = [rs stringForColumn:@"TitleAttributeReference"];
    NSString *parentTitleAttributeReference = [rs stringForColumn:@"ParentTitleAttributeReference"];
    if (titleAttributeReference) {
      // fix the clicke uiItem object so that you find the entry in the menu_bar_shortcuts table
      theClickedUIElementItem.titleAttribute = titleAttributeReference;
      theClickedUIElementItem.parentTitleAttribute = parentTitleAttributeReference;
      NSLog(@"parentTitleAtribtute : %@", titleAttributeReference);
      
      theShortcut = [self getShortcutStringFromMenuBarItem:theClickedUIElementItem :db];
    }
  }
  
    NSLog(@".........................................................");
  
    return theShortcut;
}

+ (NSString*) getShortcutStringFromMenuBarItem :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db {

  FMResultSet *rs = [db executeQuery:@"select rowid, * from menu_bar_shortcuts where (TitleAttribute = ? and ParentTitleAttribute = ? and AppName = ? and language = ? )",
                     theClickedUIElementItem.titleAttribute,
                     theClickedUIElementItem.parentTitleAttribute,
                     theClickedUIElementItem.appName,
                     theClickedUIElementItem.language
                     ];
  
  if ([db hadError]) {
    DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    return NULL;
  }
  
  NSLog(@".........................................................");
  DDLogInfo(@"Search for menuItem");
  NSLog(@"GUIElement search with parentTitle:");  
  NSLog(@"--------------and-----------------------------");
  NSLog(@"titleAttribute : %@", theClickedUIElementItem.titleAttribute);
  NSLog(@"parenttitleAttribute : %@", theClickedUIElementItem.parentTitleAttribute);
  NSLog(@"appName : %@", theClickedUIElementItem.appName);
  NSLog(@"language : %@", theClickedUIElementItem.language);
  NSLog(@"------------------------------------------------------------");
  
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
  NSLog(@"GUIElement search with title:");
  NSLog(@"--------------and-----------------------------");
  NSLog(@"titleAttribute : %@", theClickedUIElementItem.titleAttribute);
  NSLog(@"appName : %@", theClickedUIElementItem.appName);
  NSLog(@"language : %@", theClickedUIElementItem.language);
  NSLog(@".........................................................");
  
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

+ (BOOL) checkGUISupport  :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db {
  
  FMResultSet *rs = [db executeQuery:@"select rowid, * FROM gui_supported_applications where AppName = ? and AppVersion = ? and Language = ? and GUISupport = 'YES'",
                     theClickedUIElementItem.appName,
                     theClickedUIElementItem.appVersion,
                     theClickedUIElementItem.language
                     ];
  if ([db hadError])
    DDLogError(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
  
  if([rs next])
    return YES;
  else
    return NO;
}

@end
	