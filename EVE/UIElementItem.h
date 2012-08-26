//
//  MenuBarItem.h
//  EVE
//
//  Created by Tobias Sommer on 8/16/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIElementItem : NSObject {
  NSString *appName;
  NSString *appVersion;
  NSString *memoryReference;
  NSString *roleAttribute;
  NSString *subroleAttribute;
  NSString *roleDescriptionAttribute;
  NSString *titleAttribute;
  NSString *descriptionAttribute;
  NSString *helpAttribute;
  NSString *parentAttribute;
  NSString *childrenAttribute;
  NSString *visibleChildrenAttribute;
  NSString *windowAttribute;
  NSString *topLevelUIElementAttribute;
  NSString *titleUIElementAttribute;
  NSString *servesAsTitleForUIElementsAttribute;
  NSString *linkedUIElementsAttribute;
}

@property(readwrite, retain) NSString *appName;
@property(readwrite, retain) NSString *appVersion;
@property(readwrite, retain) NSString *roleAttribute;
@property(readwrite, retain) NSString *subroleAttribute;
@property(readwrite, retain) NSString *roleDescriptionAttribute;
@property(readwrite, retain) NSString *titleAttribute;
@property(readwrite, retain) NSString *descriptionAttribute;
@property(readwrite, retain) NSString *valueAttribute;
@property(readwrite, retain) NSString *helpAttribute;
@property(readwrite, retain) NSString *parentTitleAttribute;
@property(readwrite, retain) NSString *parentRoleAttribute;
@property(readwrite, retain) NSString *parentDescriptionAttribute;
@property(readwrite, retain) NSString *childrenAttribute;
@property(readwrite, retain) NSString *hasShortcut;
@property(readwrite, retain) NSString *shortcutString;
@property(readwrite, retain) NSString *language;
@property(readwrite, retain) NSString *user;
@property(readwrite, retain) NSString *date;

+ (UIElementItem*) initWithElementRef:(AXUIElementRef) menuItemRef;
+ (UIElementItem*) initBlankElement;
+ (void) printObject :(UIElementItem*) item;
@end
