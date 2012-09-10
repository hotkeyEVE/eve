//
//  GlobalButtons.m
//  EVE
//
//  Created by Tobias Sommer on 8/21/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

// For iOS
//#import <GHUnitIOS/GHUnit.h>
// For Mac OS X
#import <GHUnit/GHUnit.h>
#import "ApplicationSettings.h"
#import "FMDatabase.h"
#import "UIElementItem.h"
#import "ServiceProcessPerformedAction.h"

@interface GlobalButtons  : GHTestCase {
  FMDatabase *db;
  UIElementItem *uiItem;
}
@end

@implementation GlobalButtons

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void)setUpClass {
  NSString *dbPath = @"/Users/Togo/Library/Application Support/EVE/database.db";
  db = [FMDatabase databaseWithPath:dbPath];
}

- (void)tearDownClass {
  // Run at end of all tests in the class
}

- (void)setUp {
  uiItem = [UIElementItem initBlankElement];
  uiItem.appName = @"Finder";
  uiItem.language = @"en";
}

- (void)tearDown {
  
}

- (void) testCloseWindowButton {
  uiItem.roleDescriptionAttribute = @"close button";
  uiItem.subroleAttribute = @"axclosebutton";
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  
  GHAssertNotEqualStrings(uiItem.titleAttribute, @"", @"Title Attribute darf nicht leer sein");
  GHAssertEqualStrings(@"close window", uiItem.titleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.titleAttribute) ;

    // Assert a is not NULL, with no custom error description
  NSString *shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  GHAssertNotNULL(shortcutString, NULL);
  GHAssertNotEqualStrings(shortcutString, @"", @"Shortcuts is empty");
  
  GHAssertEqualObjects(@"Command W", shortcutString, @"Fail Global Close Button: %@.", shortcutString);

  GHAssertNotEqualObjects(@"Command G", shortcutString, @"Fail Global Close Button: %@.", shortcutString);
}

- (void) testMinimizeWindowButton {
  uiItem.roleDescriptionAttribute = @"minimize button";
  uiItem.subroleAttribute = @"axminimizebutton";
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  
  GHAssertNotEqualStrings( @"",         uiItem.titleAttribute, @"Title Attribute darf nicht leer sein");
  GHAssertEqualStrings(@"minimize", uiItem.titleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.titleAttribute);
  
  // Assert a is not NULL, with no custom error description
  NSString *shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  GHAssertNotNULL(shortcutString, NULL);
  GHAssertNotEqualStrings(shortcutString, @"", @"Shortcuts is empty");
  
  GHAssertEqualObjects(@"Command M", shortcutString, @"Fail Global Close Button: %@.", shortcutString);
  
  GHAssertNotEqualObjects(@"Command G", shortcutString, @"Fail Global Close Button: %@.", shortcutString);
}

- (void) testFullScreenButton {
  uiItem.appName = @"Google Chrome";
  uiItem.roleDescriptionAttribute = @"full screen button";
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  
  GHAssertNotEqualStrings(@"",         uiItem.titleAttribute, @"Title Attribute darf nicht leer sein");
  GHAssertEqualStrings(@"enter full screen", uiItem.titleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.titleAttribute);
  
  // Assert a is not NULL, with no custom error description
  NSString *shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  GHAssertNotNULL(shortcutString, NULL);
  GHAssertNotEqualStrings(shortcutString, @"", @"Shortcuts is empty");
  
//  GHAssertEqualObjects(@"Command Control F", shortcutString, @"Fail Global Close Button: %@.", shortcutString);
  GHAssertNotEqualObjects(@"Command G", shortcutString, @"Fail Global Close Button: %@.", shortcutString);
}

@end
