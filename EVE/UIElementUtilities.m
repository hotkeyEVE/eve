/*
 UIElementUtilities.m
 EVE
 
 Created by Tobias Sommer on 6/13/12.
 Copyright (c) 2012 Sommer. All rights reserved.
 
 This file is part of EVE.
 
 EVE is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 EVE is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with EVE.  If not, see <http://www.gnu.org/licenses/>. */

#import "UIElementUtilities.h"
#import "UIElementItem.h"
#import "DDLog.h"
#import "StringUtilities.h"

NSString *const UIElementUtilitiesNoDescription = @"No Description";

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation UIElementUtilities


#pragma mark -

// Flip coordinates

+ (CGPoint)carbonScreenPointFromCocoaScreenPoint:(NSPoint)cocoaPoint {
    NSScreen *foundScreen = nil;
    CGPoint thePoint;
    
    for (NSScreen *screen in [NSScreen screens]) {
	if (NSPointInRect(cocoaPoint, [screen frame])) {
	    foundScreen = screen;
	}
    }

    if (foundScreen) {
	CGFloat screenHeight = [foundScreen frame].size.height;
	
	thePoint = CGPointMake(cocoaPoint.x, screenHeight - cocoaPoint.y - 1);
    } else {
	thePoint = CGPointMake(0.0, 0.0);
    }

    return thePoint;
}



+ (NSString *)readApplicationName {
    return [[[NSWorkspace sharedWorkspace] activeApplication] valueForKey:@"NSApplicationName"];
}


+ (NSArray*) readAllMenuBarShortcutItems {
    NSMutableArray *allMenuBarShortcutItems = [[NSMutableArray alloc] init];
  
  AXUIElementRef appRef = AXUIElementCreateApplication( [[[[NSWorkspace sharedWorkspace] activeApplication] valueForKey:@"NSApplicationProcessIdentifier"] intValue] );
  
    // Read the menuBar of the actual Application
    CFTypeRef menuBarRef;
    AXUIElementCopyAttributeValue(appRef, kAXMenuBarAttribute, (CFTypeRef*)&menuBarRef);
    
    if (menuBarRef != nil) {
        CFArrayRef menuBarArrayRef;
        AXUIElementCopyAttributeValue(menuBarRef, kAXChildrenAttribute, (CFTypeRef*) &menuBarArrayRef);
        NSArray *menuBarItems = CFBridgingRelease(menuBarArrayRef);
        
        for (id menuBarItemRef in menuBarItems) {
        [self readAllMenuItems :(AXUIElementRef)menuBarItemRef :allMenuBarShortcutItems];
        }
    }
    
    if(menuBarRef){
    CFRelease(menuBarRef);        
    }

    return allMenuBarShortcutItems;
}
    
+ (void) readAllMenuItems:(AXUIElementRef) menuBarItemRef :(NSMutableArray*) allMenuBarShortcutItems {
    CFArrayRef childrenArrayRef = NULL;
    AXUIElementCopyAttributeValue(menuBarItemRef, kAXChildrenAttribute, (CFTypeRef*) &childrenArrayRef);
    NSArray *childrenArray = CFBridgingRelease(childrenArrayRef);
    
    if (childrenArray.count > 0) {
        for (id oneChildren in childrenArray) {
            [self readAllMenuItems:(AXUIElementRef) oneChildren :allMenuBarShortcutItems ];
        }
    }
    else {
        [self addMenuItemToArray:(AXUIElementRef) menuBarItemRef :allMenuBarShortcutItems ];
    }
}

+ (void) addMenuItemToArray:(AXUIElementRef) menuItemRef :(NSMutableArray*) allMenuBarShortcutItems  {
       UIElementItem *aMenuBarItem = [UIElementItem  initWithElementRef:menuItemRef];

  if([aMenuBarItem.hasShortcut boolValue]) {
    // Check if the there is alread a object with the same title
    aMenuBarItem.titleAttribute = [StringUtilities checkDuplicateTitleEntry :allMenuBarShortcutItems :aMenuBarItem];
    [allMenuBarShortcutItems addObject:aMenuBarItem];
  }

}

+ (Boolean) hasHotkey :(AXUIElementRef) menuItemRef {
    CFNumberRef  cmdCharRef;
    CFNumberRef  cmdVirtualKeyRef;
    
    AXUIElementCopyAttributeValue((AXUIElementRef) menuItemRef, (CFStringRef) kAXMenuItemCmdCharAttribute, (CFTypeRef*) &cmdCharRef);
    AXUIElementCopyAttributeValue((AXUIElementRef) menuItemRef, (CFStringRef) kAXMenuItemCmdVirtualKeyAttribute, (CFTypeRef*) &cmdVirtualKeyRef);

    NSNumber *cmdChar =        (__bridge_transfer NSNumber*) cmdCharRef;
    NSNumber *cmdVirtualKey =  (__bridge_transfer NSNumber*) cmdVirtualKeyRef;
    
 if( cmdChar > 0 || cmdVirtualKey > 0 ) 
 {
     return true;
    }
    else 
    {
     return false;
    }
}

+ (Boolean) isWebArea:(AXUIElementRef) element {
    AXUIElementRef parentRef = element;
    
    while ( AXUIElementCopyAttributeValue( parentRef, (CFStringRef) kAXParentAttribute, (CFTypeRef*) &parentRef ) == kAXErrorSuccess)
    {
        NSString *parentRole = [UIElementUtilities readkAXAttributeString:parentRef :kAXRoleAttribute];
        if ([parentRole isEqualToString:@"AXWebArea"]) {
            DDLogInfo(@"There is WebArea in the UIElement. The filter catch this action!");
            return true;
        }
    }
    
    return false;
}

+ (NSString*) titleOfActionUniversal:(AXUIElementRef)element {   
    NSString* actionTitle;
    

        actionTitle = [self readkAXAttributeString:element :kAXTitleAttribute];
        
        if (actionTitle == NULL || actionTitle.length == 0) 
        {
            actionTitle = [self readkAXAttributeString:element :kAXDescriptionAttribute];
        } 
        if (actionTitle == NULL || actionTitle.length == 0) 
        {
            actionTitle = [self readkAXAttributeString:element :kAXHelpAttribute];
        } 
        if (actionTitle == NULL || actionTitle.length == 0) 
        {
            actionTitle = [self readkAXAttributeString:element :kAXRoleDescriptionAttribute];
        }
        
        actionTitle = [actionTitle lowercaseString];
        if(([actionTitle rangeOfString:@" “"].length > 0)) {
            actionTitle = [actionTitle substringToIndex:[actionTitle rangeOfString:@" “"].location];
        }
        else if (([actionTitle rangeOfString:@" „"].length > 0)) {
            actionTitle = [actionTitle substringToIndex:[actionTitle rangeOfString:@" „"].location];
        }
    
    return actionTitle;
}

+ (NSString*) readkAXAttributeString:(AXUIElementRef)element :(CFStringRef) kAXAttribute {
    CFStringRef stringRef;
    
    AXUIElementCopyAttributeValue( element, (CFStringRef) kAXAttribute, (CFTypeRef*) &stringRef );
    
    return (__bridge_transfer NSString*) stringRef;
}

+ (Boolean) elememtInFilter :(AXUIElementRef) element {
    NSString* role = [self readkAXAttributeString:element :kAXRoleAttribute];
    AXUIElementRef parentRef;
    
    NSString *parent = [[NSString alloc] init];
    if(AXUIElementCopyAttributeValue( element, (CFStringRef) kAXParentAttribute, (CFTypeRef*) &parentRef ) == kAXErrorSuccess){
        parent = [UIElementUtilities readkAXAttributeString:parentRef :kAXRoleAttribute];
    }
    
    if ( ([role isEqualToString:(NSString*)kAXButtonRole]
          || ([role isEqualToString:(NSString*)kAXRadioButtonRole]
              && ![parent isEqualToString:(NSString*)kAXTabGroupRole])
          || [role isEqualToString:(NSString*)kAXTextFieldRole]
//          || [role isEqualToString:(NSString*)kAXPopUpButtonRole]
          || [role isEqualToString:(NSString*)kAXCheckBoxRole]
//          || [role isEqualToString:(NSString*)kAXMenuButtonRole]
          || [role isEqualToString:(NSString*)kAXMenuItemRole]
          || [role isEqualToString:(NSString*)kAXStaticTextRole])
        && ![UIElementUtilities isWebArea:element])
    {
        return true;
    }
    
    DDLogInfo(@"UIElement not in the Filter: %@ Parent:%@", role, parent);
    return false;
}

+ (Boolean) isGUIElement: (AXUIElementRef) element {
  AXUIElementRef parentRef = element;
  
  while ( AXUIElementCopyAttributeValue( parentRef, (CFStringRef) kAXParentAttribute, (CFTypeRef*) &parentRef ) == kAXErrorSuccess)
  {
    NSString *parentRole = [UIElementUtilities readkAXAttributeString:parentRef :kAXRoleAttribute];
    if ([parentRole isEqualToString:(NSString*) kAXWindowAttribute]) {
      DDLogInfo(@"GUI Element!");
      return true;
    }
  }
  
  return false;
}

@end
