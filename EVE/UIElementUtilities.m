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
#import "UIElementUtilities_org.h"
#import "ServiceMenuBarItem.h"
#import "ApplicationSettings.h"
#import "ServiceLogging.h"

NSString *const UIElementUtilitiesNoDescription = @"No Description";

static const int ddLogLevel = LOG_LEVEL_ERROR;

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

+ (void) indexingOnlyOneApp :(NSString*) bundleIdentifier {
  NSArray *runningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
  for (id aApp in runningApplications) {
    if ([[aApp bundleIdentifier] isEqualToString:bundleIdentifier]) {
      [self mainIndexingMethod :aApp];
      break;
    }
  }
  [[[ApplicationSettings sharedApplicationSettings] getMenuBar] stopAnimating];
  runningApplications = nil;
}

+ (void) indexingAllApps {
  NSArray *runningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
  for (id aApp in runningApplications) {
    [self mainIndexingMethod :aApp];
  }
    [[[ApplicationSettings sharedApplicationSettings] getMenuBar] stopAnimating];
  runningApplications = nil;
}

+ (void) mainIndexingMethod :(NSRunningApplication*) app {
  AXUIElementRef appRef = AXUIElementCreateApplication( [app processIdentifier] );
  NSString *appName = [StringUtilities getApplicationNameWithBundleIdentifier:[app bundleIdentifier]];
  
  
  // Read the menuBar of the actual Application
  CFTypeRef menuBarRef;
  AXUIElementCopyAttributeValue(appRef, kAXMenuBarAttribute, (CFTypeRef*)&menuBarRef);
  
  if (menuBarRef != nil) {
    sqlite_int64 rowId = [ServiceLogging insertIndexingEntry:appName];
    
    CFArrayRef menuBarArrayRef;
    AXUIElementCopyAttributeValue(menuBarRef, kAXChildrenAttribute, (CFTypeRef*) &menuBarArrayRef);
    NSArray *menuBarItems = CFBridgingRelease(menuBarArrayRef);
    
    if ([menuBarItems count] > 0 && appName != NULL) {
    
    NSMutableArray *valuesArray =[[NSMutableArray alloc] initWithObjects:menuBarItems, appName, nil];
    
    [self startIndexing:valuesArray];
    
    [ServiceLogging updateIndexingEntry:rowId];
    }
    
    if (menuBarRef) {
      CFRelease(menuBarRef);
    }
  }
  
  if(appRef) {
    CFRelease(appRef);
  }
}


+ (void) startIndexing :(NSArray*) valuesArray {
  NSArray *menuBarItems = [valuesArray objectAtIndex:0];
  NSString *appName = [valuesArray objectAtIndex:1];
  DDLogInfo(@"I searching in  %@ for shortcuts", appName);
  for (id menuBarItemRef in menuBarItems) {
    [self readAllMenuItems :(__bridge AXUIElementRef)menuBarItemRef :appName ];
  }
}
    
+ (void) readAllMenuItems :(AXUIElementRef) menuBarItemRef :(NSString*) appName {
    CFArrayRef childrenArrayRef;
    AXUIElementCopyAttributeValue(menuBarItemRef, kAXChildrenAttribute, (CFTypeRef*) &childrenArrayRef);
    NSArray *childrenArray = CFBridgingRelease(childrenArrayRef);

    if (childrenArray.count > 0) {
        for (id oneChildren in childrenArray) {
          [self readAllMenuItems :(__bridge AXUIElementRef)(oneChildren) :appName ];
        }
    }
    else {
      __strong UIElementItem *aMenuBarItem = [UIElementItem  initWithElementRef:menuBarItemRef];
      if(aMenuBarItem.hasShortcut) {
        if ([aMenuBarItem.titleAttribute length] > 0) {
          aMenuBarItem.shortcutString = [StringUtilities composeShortcut:menuBarItemRef];
          [ServiceMenuBarItem updateMenuBarShortcutTable:aMenuBarItem :appName];
        }
      }
      aMenuBarItem = nil;
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
    return true;
 else
    return false;
}

+ (NSString*) readkAXAttributeString:(AXUIElementRef)element :(CFStringRef) kAXAttribute {
  CFStringRef stringRef;
  
  if (AXUIElementCopyAttributeValue( element, (CFStringRef) kAXAttribute, (CFTypeRef*) &stringRef ) == kAXErrorSuccess) {
    NSString *returnValue = (__bridge NSString *) stringRef;
    CFRelease(stringRef);
    return returnValue;
  } else {
    return nil;
  }
}

// TODO
+ (Boolean) elememtInFilter :(AXUIElementRef) element {
    NSString *lineageOfUIElement = [UIElementUtilities_org lineageDescriptionOfUIElement:element];
    
  if ( ([self isGUIElement :element :lineageOfUIElement]
      || [self isInMenuBar :element :lineageOfUIElement]
      || [self isMenuItem:element :lineageOfUIElement])
      && ![self isWebArea:element :lineageOfUIElement]
      && ![self isMenuBarItem:element :lineageOfUIElement]) {
      return true;
  }  else {
      return false;
  }
}

+ (Boolean) isGUIElement: (AXUIElementRef)element :(NSString*)lineageOfUIElement {
  NSString* role = [self readkAXAttributeString:element :kAXRoleAttribute];
  
  AXUIElementRef parentRef = [self getSecondParent:element];
  NSString *parentRole = [self readkAXAttributeString:parentRef :kAXRoleAttribute];
  
  // If is a e.g Button
  if( (   [role isEqualToString:(NSString*)kAXButtonRole]
      || [role isEqualToString:(NSString*)kAXRadioButtonRole]
      || [role isEqualToString:(NSString*)kAXTextFieldRole]
      || [role isEqualToString:(NSString*)kAXPopUpButtonRole]
       || ([parentRole isEqualToString:(NSString*)kAXPopUpButtonRole] && ([role isEqualToString:(NSString*) kAXMenuBarItemRole] || [role isEqualToString:(NSString*) kAXMenuItemRole])) // Popup Menus
       || ([parentRole isEqualToString:(NSString*)kAXMenuButtonRole] && ([role isEqualToString:(NSString*) kAXMenuBarItemRole] || [role isEqualToString:(NSString*) kAXMenuItemRole])) // Popup Menus
       || ([parentRole isEqualToString:(NSString*)kAXListRole] && ([role isEqualToString:(NSString*) kAXMenuBarItemRole] || [role isEqualToString:(NSString*) kAXMenuItemRole])) // Popup Menus
       || [role isEqualToString:(NSString*)kAXCheckBoxRole]
      || [role isEqualToString:(NSString*)kAXStaticTextRole])
      && (!([lineageOfUIElement rangeOfString:(NSString*) kAXWindowRole options:NSCaseInsensitiveSearch].location == NSNotFound)))
      return true;
   else
      return false;
}

+ (Boolean) isInMenuBar:(AXUIElementRef) element :(NSString*) lineageOfUIElement {
  if ([lineageOfUIElement rangeOfString:(NSString*) kAXMenuBarRole options:NSCaseInsensitiveSearch].location == NSNotFound)
    return false;
   else
    return true;
}

+ (Boolean) isMenuBarItem:(AXUIElementRef) element :(NSString*) lineageOfUIElement {
  if ([[self readkAXAttributeString:element :kAXRoleAttribute] isEqualToString:(NSString*)kAXMenuBarItemRole])
    return true;
  else
    return false;
}

+ (Boolean) isWebArea :(AXUIElementRef)element :(NSString*)lineageOfUIElement {
  
  if ([lineageOfUIElement rangeOfString:@"AXWebArea" options:NSCaseInsensitiveSearch].location == NSNotFound)
    return false;
  else
    return true;
}

+ (Boolean) isMenuItem :(AXUIElementRef)element :(NSString*)lineageOfUIElement {
  
  if ([lineageOfUIElement rangeOfString:(NSString*)kAXMenuItemRole options:NSCaseInsensitiveSearch].location == NSNotFound)
    return false;
  else
    return true;
}

+ (AXUIElementRef) getSecondParent :(AXUIElementRef) elementRef {
  AXUIElementRef parentRef = elementRef;
  if (parentRef) {
      parentRef = [UIElementUtilities_org parentOfUIElement:parentRef];
    if (parentRef) {
      parentRef = [UIElementUtilities_org parentOfUIElement:parentRef];
    }
  }
    return parentRef;
  }

@end
