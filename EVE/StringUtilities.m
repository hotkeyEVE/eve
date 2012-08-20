//
//  StringUtilities.m
//  EVE
//
//  Created by Tobias Sommer on 8/6/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//
//This file is part of EVE.
//
//EVE is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.
//
//EVE is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License
//along with EVE.  If not, see <http://www.gnu.org/licenses/>. */

#import "StringUtilities.h"
#import <Carbon/Carbon.h>
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation StringUtilities


+ (id) cleanTitleString :(id) string {
    
    
    // Check if this is a number
    if([string isKindOfClass:NSNumber.class])
    {
        return [string stringValue];
    }
  
  // Check if this is a number
  if([string isKindOfClass:NSString.class])  {
    NSString *cleanedTitle = string;
    
    if([cleanedTitle rangeOfString:@" “"].length > 0) {
      cleanedTitle = [cleanedTitle substringToIndex:[cleanedTitle rangeOfString:@" “"].location];
    } else if([cleanedTitle rangeOfString:@" „"].length > 0) {
      cleanedTitle = [cleanedTitle substringToIndex:[cleanedTitle rangeOfString:@" „"].location];
    }
    
    NSCharacterSet *engCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"…&”“"];
    cleanedTitle = [[cleanedTitle componentsSeparatedByCharactersInSet: engCharacterSet] componentsJoinedByString: @""];
    
    return [cleanedTitle lowercaseString];
  }
  else {
    return string;
  }
}

+ (NSString*) composeShortcut: (AXUIElementRef) elementRef {
    enum {
        kMenuNoModifiers              = 0,    /* Mask for no modifiers*/
        kMenuShiftModifier            = (1 << 0), /* Mask for shift key modifier*/
        kMenuOptionModifier           = (1 << 1), /* Mask for option key modifier*/
        kMenuControlModifier          = (1 << 2), /* Mask for control key modifier*/
        kMenuNoCommandModifier        = (1 << 3) /* Mask for no command key modifier*/
    };
    
    NSString *theShortcut = [NSString stringWithFormat:@""];
    CFStringRef cmdCharRef;
    CFNumberRef cmdVirtualKeyRef;
    CFNumberRef cmdModifiersRef;
    
    
    AXUIElementCopyAttributeValue((AXUIElementRef) elementRef, (CFStringRef) kAXMenuItemCmdVirtualKeyAttribute, (CFTypeRef*) &cmdVirtualKeyRef);
    AXUIElementCopyAttributeValue((AXUIElementRef) elementRef, (CFStringRef) kAXMenuItemCmdModifiersAttribute, (CFTypeRef*) &cmdModifiersRef);
    AXUIElementCopyAttributeValue((AXUIElementRef) elementRef, (CFStringRef) kAXMenuItemCmdCharAttribute,  (CFTypeRef*) &cmdCharRef);
    
    NSString *cmdChar =       (__bridge_transfer NSString*) cmdCharRef;
    NSNumber *cmdVirtualKey = (__bridge_transfer NSNumber*) cmdVirtualKeyRef;
    NSNumber *cmdModifiers =  (__bridge_transfer NSNumber*) cmdModifiersRef;
    
    
    if ( ([cmdModifiers intValue] & kMenuNoCommandModifier) == 0 )
    {
    //    DDLogInfo(@"Command Modifier");
        theShortcut = [theShortcut stringByAppendingString:@"Command "];
    }
    
    if ( ([cmdModifiers intValue] & kMenuControlModifier) != 0 )
    {
     //   DDLogInfo(@"Control Modifier");
        theShortcut = [theShortcut stringByAppendingString:@"Control "];
    }
    
    if ( ([cmdModifiers intValue] & kMenuOptionModifier) != 0 )
    {
     //   DDLogInfo(@"Option Modifier");
        theShortcut = [theShortcut stringByAppendingString:@"Option "];
    }
    
    if ( ([cmdModifiers intValue] & kMenuShiftModifier) != 0 )
    {
     //   DDLogInfo(@"Shift Modifier");
        theShortcut = [theShortcut stringByAppendingString:@"Shift "];
    }
    
    
    // Virtual Keys
    if ( ([cmdVirtualKey intValue] == kVK_Return) )
    {
      //  DDLogInfo(@"Return");
        theShortcut = [theShortcut stringByAppendingString:@" Return "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_Tab) )
    {
    //    DDLogInfo(@"Tab");
        theShortcut = [theShortcut stringByAppendingString:@" Tab "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_Space) )
    {
   //     DDLogInfo(@"Space");
        theShortcut = [theShortcut stringByAppendingString:@" Space "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_Delete) )
    {
    //    DDLogInfo(@"kVK_Delete");
        theShortcut = [theShortcut stringByAppendingString:@" Delete "];
    }
    
    
    if ( ([cmdVirtualKey intValue] == kVK_Escape) )
    {
     //   DDLogInfo(@"kVK_Escape");
        theShortcut = [theShortcut stringByAppendingString:@" Escape "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_Command) )
    {
//  DDLogInfo(@"kVK_Command");
        theShortcut = [theShortcut stringByAppendingString:@" Command "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_Option)  )
    {
    //    DDLogInfo(@"kVK_Option");
        theShortcut = [theShortcut stringByAppendingString:@" Option "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_Control) )
    {
//  DDLogInfo(@"kVK_Control");
        theShortcut = [theShortcut stringByAppendingString:@" Control "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_Shift) )
    {
//        DDLogInfo(@"kVK_Shift");
        theShortcut = [theShortcut stringByAppendingString:@" Shift "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_CapsLock) )
    {
//        DDLogInfo(@"kVK_CapsLock");
        theShortcut = [theShortcut stringByAppendingString:@" CapsLock "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_RightShift) )
    {
//        DDLogInfo(@"kVK_RightShift");
        theShortcut = [theShortcut stringByAppendingString:@" Right Shift "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_RightOption) )
    {
//        DDLogInfo(@"kVK_RightOption");
        theShortcut = [theShortcut stringByAppendingString:@" Right Option "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_RightControl) )
    {
//        DDLogInfo(@"kVK_RightControl");
        theShortcut = [theShortcut stringByAppendingString:@" Right Control "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_Function) )
    {
//        DDLogInfo(@"kVK_Function");
        theShortcut = [theShortcut stringByAppendingString:@" Function "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_VolumeUp) )
    {
//        DDLogInfo(@"kVK_VolumeUp");
        theShortcut = [theShortcut stringByAppendingString:@" Volume Up "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_VolumeDown) )
    {
//        DDLogInfo(@"kVK_VolumeDown");
        theShortcut = [theShortcut stringByAppendingString:@" Volume Down "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_Mute) )
    {
//        DDLogInfo(@"kVK_Mute");
        theShortcut = [theShortcut stringByAppendingString:@" Mute "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_Help) )
    {
//        DDLogInfo(@"kVK_Help");
        theShortcut = [theShortcut stringByAppendingString:@" Help "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_Home) )
    {
//        DDLogInfo(@"kVK_Home");
        theShortcut = [theShortcut stringByAppendingString:@" Home "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_PageUp) )
    {
//        DDLogInfo(@"kVK_PageUp");
        theShortcut = [theShortcut stringByAppendingString:@" Page Up "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_ForwardDelete))
    {
//        DDLogInfo(@"kVK_ForwardDelete");
        theShortcut = [theShortcut stringByAppendingString:@" Forward Delete "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_End) )
    {
//        DDLogInfo(@"kVK_End");
        theShortcut = [theShortcut stringByAppendingString:@" End "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_PageDown) )
    {
//        DDLogInfo(@"kVK_PageDown");
        theShortcut = [theShortcut stringByAppendingString:@" Page Down "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_LeftArrow) )
    {
//        DDLogInfo(@"kVK_LeftArrow");
        theShortcut = [theShortcut stringByAppendingString:@" Left Arrow "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_RightArrow) )
    {
//        DDLogInfo(@"kVK_RightArrow");
        theShortcut = [theShortcut stringByAppendingString:@" Right Arrow "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_DownArrow) )
    {
//        DDLogInfo(@"kVK_DownArrow");
        theShortcut = [theShortcut stringByAppendingString:@" Down Arrow "];
    }
    
    if ( ([cmdVirtualKey intValue] == kVK_UpArrow) )
    {
//        DDLogInfo(@"kVK_UpArrow");
        theShortcut = [theShortcut stringByAppendingString:@" Up Arrow "];
    }
    
    if (cmdChar != NULL) {
//        DDLogInfo(@"CMDChar: %@", cmdChar);
        theShortcut = [theShortcut stringByAppendingString:cmdChar];
    }
    
    return theShortcut;
}

+ (NSString*) getActiveApplicationVersionString {
  
  NSString *bundleIdentifier = [[[NSWorkspace sharedWorkspace] activeApplication] valueForKey:@"NSApplicationBundleIdentifier"];
  NSString  *bundlePath = [[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:bundleIdentifier];
  NSBundle *appBundle = [[NSBundle alloc] initWithPath: bundlePath];
  
  return [[appBundle infoDictionary] objectForKey :(NSString*)kCFBundleVersionKey];
}

+ (NSString *) getActiveApplicationName {
  return [[[NSWorkspace sharedWorkspace] activeApplication] valueForKey:@"NSApplicationName"];
}

+ (NSString*) checkDuplicateTitleEntry :(NSArray*) allMenuBarShortcutItems :(UIElementItem*) aMenuBarItem {
  
  // LOOP over all Object in the Array
  for (UIElementItem *aItem in [allMenuBarShortcutItems reverseObjectEnumerator]) {
    char lastChar = [aItem.titleAttribute characterAtIndex:([aItem.titleAttribute length ] - 1)];
    char dollarMarker = [aItem.titleAttribute characterAtIndex:([aItem.titleAttribute length ] - 2)];
    NSNumber *numberValue = [NSNumber numberWithChar:lastChar];
    
    // If the Last Character is a number and the character "$" before
    if (([numberValue intValue] > 47 && [numberValue intValue] < 58) && dollarMarker == '$') {
      // If the two words are equal
      if ([[aItem.titleAttribute substringToIndex:([aItem.titleAttribute length] - 2)] isEqualToString:aMenuBarItem.titleAttribute]) {
        numberValue = [NSNumber numberWithInt:([numberValue intValue] + 1)];
        aMenuBarItem.titleAttribute = [aMenuBarItem.titleAttribute stringByAppendingFormat:@"%c%c",'$',(char)[numberValue integerValue]];
        return aMenuBarItem.titleAttribute;
      }
      else {
        continue;
      }
    }
    else if ([aItem.titleAttribute isEqualToString:aMenuBarItem.titleAttribute]) {
      aMenuBarItem.titleAttribute = [aMenuBarItem.titleAttribute stringByAppendingString:@"$1"];
      return aMenuBarItem.titleAttribute;
    }
    else {
      continue;
    }
  }
  return aMenuBarItem.titleAttribute;
}
  
@end