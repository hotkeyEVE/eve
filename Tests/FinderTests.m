//
//  FinderTests.m
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

@interface FinderTests  : GHTestCase {
  FMDatabase *db;
  UIElementItem *uiItem;
}
@end

@implementation FinderTests 

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void)setUpClass {
  // Run at start of all tests in the class
  ApplicationSettings *appSettings = [ApplicationSettings sharedApplicationSettings];
  db =  [appSettings getSharedDatabase];
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

- (void) testForwardButton {
  uiItem.descriptionAttribute = @"forward";
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  GHAssertNotEqualStrings(uiItem.titleAttribute, @"", @"Title Attribute darf nicht leer sein");
  GHAssertEqualStrings(@"forward", uiItem.titleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.titleAttribute);
  GHAssertEqualStrings(@"go", uiItem.parentTitleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.parentTitleAttribute);
  
  NSString *shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  GHAssertNotNULL(shortcutString, NULL);
  GHAssertNotEqualStrings(shortcutString, @"", @"Shortcuts is empty");
  
  GHAssertEqualObjects(shortcutString, @"Command ]", @"Fail Forward Button: %@.", shortcutString);
  GHAssertNotEqualObjects(shortcutString, @"Command GG", @"Fail Forward Button: %@.", shortcutString);
}

- (void) testBackButton {
  uiItem.descriptionAttribute = @"back";
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  GHAssertNotEqualStrings(uiItem.titleAttribute, @"", @"Title Attribute darf nicht leer sein");
  GHAssertEqualStrings(@"back", uiItem.titleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.titleAttribute);
  GHAssertEqualStrings(@"go", uiItem.parentTitleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.parentTitleAttribute);
  
  NSString *shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  GHAssertNotNULL(shortcutString, NULL);
  GHAssertNotEqualStrings(shortcutString, @"", @"Shortcuts is empty");
  
  GHAssertEqualObjects(shortcutString, @"Command [", @"Fail Back Button: %@.", shortcutString);
  GHAssertNotEqualObjects(shortcutString, @"Command HH", @"Fail Back Button: %@.", shortcutString);
}

- (void) testConnectButtonInMenu {
  uiItem.descriptionAttribute = @"";
  uiItem.titleAttribute = @"connect";
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  GHAssertNotEqualStrings(uiItem.titleAttribute, @"", @"Title Attribute darf nicht leer sein");
  GHAssertEqualStrings(@"connect to server", uiItem.titleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.titleAttribute);
  GHAssertEqualStrings(@"go", uiItem.parentTitleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.parentTitleAttribute);
  
  NSString *shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  GHAssertNotNULL(shortcutString, NULL);
  GHAssertNotEqualStrings(shortcutString, @"", @"Shortcuts is empty");
  
  GHAssertEqualObjects(shortcutString, @"Command K", @"Fail Back Button: %@.", shortcutString);
  GHAssertNotEqualObjects(shortcutString, @"", @"Fail Back Button: %@.", shortcutString);
}

- (void) testConnectInButtonToolbar {
  uiItem.descriptionAttribute = @"connect";
  uiItem.titleAttribute = @"";
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  GHAssertNotEqualStrings(uiItem.titleAttribute, @"", @"Title Attribute is empty, nothing found in DB");
  GHAssertEqualStrings(@"connect to server", uiItem.titleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.titleAttribute);
  GHAssertEqualStrings(@"go", uiItem.parentTitleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.parentTitleAttribute);
  
  NSString *shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  GHAssertNotNULL(shortcutString, NULL);
  GHAssertNotEqualStrings(shortcutString, @"", @"Shortcuts is empty");
  
  GHAssertEqualObjects(shortcutString, @"Command K", @"Fail Connect Button: %@.", shortcutString);
}

- (void) testSearchField {
  uiItem.descriptionAttribute = @"search";
  uiItem.titleAttribute = @"";
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  GHAssertNotEqualStrings(uiItem.titleAttribute, @"", @"Title Attribute is empty, nothing found in DB");
  GHAssertEqualStrings(@"find", uiItem.titleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.titleAttribute);
  GHAssertEqualStrings(@"file", uiItem.parentTitleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.parentTitleAttribute);
  
  NSString *shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  GHAssertNotNULL(shortcutString, NULL);
  GHAssertNotEqualStrings(shortcutString, @"", @"Shortcuts is empty");
  
  GHAssertEqualObjects(shortcutString, @"Command F", @"Fail Search Button: %@.", shortcutString);
  
  uiItem.descriptionAttribute = @"";
  uiItem.titleAttribute = @"search";
  
  shortcutString = NULL;
  uiItem.shortcutString = NULL;
  
  uiItem = [ServiceProcessPerformedAction getFixedGUIElement :uiItem :db];
  GHAssertNotEqualStrings(uiItem.titleAttribute, @"", @"Title Attribute is empty, nothing found in DB");
  GHAssertEqualStrings(@"find", uiItem.titleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.titleAttribute);
  GHAssertEqualStrings(@"file", uiItem.parentTitleAttribute, @"Wrong title Attribute after fix: %@.", uiItem.parentTitleAttribute);
  
  shortcutString = [ServiceProcessPerformedAction getShortcutStringFromMenuBarItem:uiItem :db];
  GHAssertNotNULL(shortcutString, NULL);
  GHAssertNotEqualStrings(shortcutString, @"", @"Shortcuts is empty");
  
  GHAssertEqualObjects(shortcutString, @"Command F", @"Fail Search Button: %@.", shortcutString);
}

@end