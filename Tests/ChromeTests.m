//
//  ChromeTests.m
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

@interface ChromeTests  : GHTestCase {
  FMDatabase *db;
  UIElementItem *uiItem;
}
@end

@implementation ChromeTests

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
  uiItem.appName = @"Google Chrome";
  uiItem.language = @"en";
}

- (void)tearDown {
}

- (void) testForwardButton {
  uiItem.descriptionAttribute = @"forward";
  uiItem.roleAttribute = @"axbutton";
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  
  GHAssertNotEqualStrings(uiItem.titleAttribute, @"", @"Title Attribute darf nicht leer sein");
  GHAssertEqualStrings(@"forward", uiItem.titleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.titleAttribute);
  GHAssertEqualStrings(@"history", uiItem.parentTitleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.parentTitleAttribute);
  
  NSString *shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  
  GHAssertEqualObjects(shortcutString, @"Command ]", @"Fail Forward Button: %@.", shortcutString);
  GHAssertNotEqualObjects(shortcutString, @"Command GG", @"Fail Forward Button: %@.", shortcutString);
}

- (void) testBackButton {
  uiItem.descriptionAttribute = @"back";
  uiItem.roleAttribute = @"axbutton";
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  GHAssertNotEqualStrings(uiItem.titleAttribute, @"", @"Title Attribute darf nicht leer sein");
  GHAssertEqualStrings(@"back", uiItem.titleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.titleAttribute);
  GHAssertEqualStrings(@"history", uiItem.parentTitleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.parentTitleAttribute);
  
  NSString *shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  GHAssertNotNULL(shortcutString, NULL);
  GHAssertNotEqualStrings(shortcutString, @"", @"Shortcuts is empty");
  
  GHAssertEqualObjects(shortcutString, @"Command [", @"Fail Forward Button: %@.", shortcutString);
  GHAssertNotEqualObjects(shortcutString, @"Command GG", @"Fail Forward Button: %@.", shortcutString);
}

- (void) testNewTabButton {
  uiItem.descriptionAttribute = @"new tab";
  uiItem.roleAttribute = @"axbutton";
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  GHAssertNotEqualStrings(uiItem.titleAttribute, @"", @"Title Attribute darf nicht leer sein");
  GHAssertEqualStrings(@"new tab", uiItem.titleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.titleAttribute);
  GHAssertEqualStrings(@"file", uiItem.parentTitleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.parentTitleAttribute);
  
  NSString *shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  GHAssertNotNULL(shortcutString, NULL);
  GHAssertNotEqualStrings(shortcutString, @"", @"Shortcuts is empty");
  
  GHAssertEqualObjects(shortcutString, @"Command T", @"Fail Forward Button: %@.", shortcutString);
  GHAssertNotEqualObjects(shortcutString, @"Command GG", @"Fail Forward Button: %@.", shortcutString);
}

- (void) testReloadButton {
  uiItem.helpAttribute = @"reload this page";
  uiItem.descriptionAttribute = @"reload";
  uiItem.roleAttribute = @"axbutton";

  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  GHAssertNotEqualStrings(uiItem.titleAttribute, @"", @"Title Attribute darf nicht leer sein");
  GHAssertEqualStrings(@"reload this page", uiItem.titleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.titleAttribute);
  GHAssertEqualStrings(@"view", uiItem.parentTitleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.parentTitleAttribute);
  
  NSString *shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  
  GHAssertEqualObjects(shortcutString, @"Command R", @"Fail Forward Button: %@.", shortcutString);
  GHAssertNotEqualObjects(shortcutString, @"Command GG", @"Fail Forward Button: %@.", shortcutString);
}

- (void) testStopButton {
  uiItem.descriptionAttribute = @"reload";
  uiItem.helpAttribute = @"stop loading this page";
  uiItem.roleAttribute = @"axbutton";
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  
  NSString *shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  
  GHAssertEqualObjects(shortcutString, @"Command .", @"Fail Forward Button: %@.", shortcutString);
  GHAssertNotEqualObjects(shortcutString, @"Command GG", @"Fail Forward Button: %@.", shortcutString);
}

- (void) testHomeButton {
  uiItem.descriptionAttribute = @"home";
  uiItem.roleAttribute = @"axbutton";
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  GHAssertNotEqualStrings(uiItem.titleAttribute, @"", @"Title Attribute darf nicht leer sein");
  GHAssertEqualStrings(@"home", uiItem.titleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.titleAttribute);
  GHAssertEqualStrings(@"history", uiItem.parentTitleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.parentTitleAttribute);
  
  NSString *shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  GHAssertNotNULL(shortcutString, NULL);
  GHAssertNotEqualStrings(shortcutString, @"", @"Shortcuts is empty");
  
  GHAssertEqualObjects(shortcutString, @"Command Shift H", @"Fail Forward Button: %@.", shortcutString);
  GHAssertNotEqualObjects(shortcutString, @"Command GG", @"Fail Forward Button: %@.", shortcutString);
}

- (void) testLocationButton {
  uiItem.descriptionAttribute = @"address";
  uiItem.roleAttribute = @"axtextfield";
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  GHAssertNotEqualStrings(uiItem.titleAttribute, @"", @"Title Attribute darf nicht leer sein");
  GHAssertEqualStrings(@"open location", uiItem.titleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.titleAttribute);
  GHAssertEqualStrings(@"file", uiItem.parentTitleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.parentTitleAttribute);
  
  NSString *shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  GHAssertNotNULL(shortcutString, NULL);
  GHAssertNotEqualStrings(shortcutString, @"", @"Shortcuts is empty");
  
  GHAssertEqualObjects(shortcutString, @"Command L", @"Fail Forward Button: %@.", shortcutString);
  GHAssertNotEqualObjects(shortcutString, @"Command GG", @"Fail Forward Button: %@.", shortcutString);
}


- (void) test1PasswordButton {
  uiItem.descriptionAttribute = @"1password";
  uiItem.roleAttribute = @"axbutton";
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db]; 

  
  GHAssertEqualStrings(uiItem.shortcutString, @"Command \\", @"Fail Forward Button: %@.", uiItem.shortcutString);
  GHAssertNotEqualStrings(uiItem.shortcutString, @"Command GG", @"Fail Forward Button: %@.", uiItem.shortcutString);
}


@end
