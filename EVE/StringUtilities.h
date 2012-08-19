//
//  StringUtilities.h
//  EVE
//
//  Created by Tobias Sommer on 8/6/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIElementItem.h"

@interface StringUtilities : NSObject

+ (NSString*) cleanTitleString :(NSString*) string;

+ (NSString*) composeShortcut: (AXUIElementRef) elementRef;
+ (NSString*) getActiveApplicationVersionString;
+ (NSString*) checkDuplicateTitleEntry :(NSArray*) allMenuBarShortcutItems :(UIElementItem*) aMenuBarItem;

@end