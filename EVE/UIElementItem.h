//
//  MenuBarItem.h
//  EVE
//
//  Created by Tobias Sommer on 8/16/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIElementItem : NSObject {
  
}

@property NSString *appName;
@property NSString *appVersion;
@property BOOL hasShortcut;
@property NSString *shortcutString;
@property NSString *language;
@property BOOL isGUIElement;
@property BOOL isInMenuBar;
@property BOOL isMenuBarItem;
@property NSString *roleAttribute;
@property NSString *subroleAttribute;
@property NSString *roleDescriptionAttribute;
@property NSString *titleAttribute;
@property NSString *descriptionAttribute;
@property NSString *valueAttribute;
@property NSString *helpAttribute;
@property NSString *parentTitleAttribute;
@property NSString *parentRoleAttribute;
@property NSString *parentDescriptionAttribute;
@property NSString *user;
@property NSString *date;

+ (UIElementItem*) initWithElementRef:(AXUIElementRef) elementRef;
+ (void) printObject :(UIElementItem*) item;
@end
