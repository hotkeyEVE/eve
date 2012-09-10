//
//  ServiceProcessPerformedAction.h
//  EVE
//
//  Created by Tobias Sommer on 8/17/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIElementItem.h"
#import "FMDB/FMDatabaseQueue.h"
#import "FMDB/FMDatabase.h"

@interface ServiceProcessPerformedAction : NSObject

+ (NSString*) getShortcutStringFromMenuBarItem :(UIElementItem*) theClickedUIElementItem :(FMDatabaseQueue*) queue;
+ (UIElementItem*) getFixedGUIElement :(UIElementItem*) theClickedUIElementItem :(FMDatabaseQueue*) db ;

+ (BOOL) checkIfShortcutAlreadySend :(UIElementItem*) theClickedUIElementItem :(FMDatabaseQueue*) queue;
+ (BOOL) checkIfShortcutIsDisabled  :(UIElementItem*) theClickedUIElementItem :(FMDatabaseQueue*) queue;

+ (void) insertDisplayedShortcutEntryToDatabase :(UIElementItem*) theClickedUIElementItem :(FMDatabaseQueue*)queue;
+ (BOOL) insertShortcutToLearnedTable :(FMDatabaseQueue*) queue;
+ (BOOL) insertApplicationToDisabledApplicationTable :(FMDatabaseQueue*) queue;

@end
