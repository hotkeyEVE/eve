//
//  ServiceProcessPerformedAction.h
//  EVE
//
//  Created by Tobias Sommer on 8/17/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIElementItem.h"
#import "FMDatabase.h"

@interface ServiceProcessPerformedAction : NSObject

+ (NSString*) getShortcutStringFromMenuBarItem :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db;
+ (NSString*) getShortcutStringFromGUIElement :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db;

+ (BOOL) checkIfShortcutAlreadySend :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db;
+ (BOOL) checkIfShortcutIsDisabled  :(UIElementItem*) theClickedUIElementItem :(FMDatabase*) db;

+ (void) insertDisplayedShortcutEntryToDatabase :(UIElementItem*) theClickedUIElementItem :db;
+ (void) insertShortcutToLearnedTable;
+ (void) insertApplicationToDisabledApplicationTable;

@end
