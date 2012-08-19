//
//  MenuBarItem.m
//  EVE
//
//  Created by Tobias Sommer on 8/16/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "UIElementItem.h"
#import "UIElementUtilities.h"
#import "StringUtilities.h"
#import "DateUtilities.h"
#import "DDLog.h"
#import "ApplicationSettings.h"


static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation UIElementItem

@synthesize appName;
@synthesize appVersion;
@synthesize memoryReference;
@synthesize roleAttribute;
@synthesize subroleAttribute;
@synthesize roleDescriptionAttribute;
@synthesize titleAttribute;
@synthesize descriptionAttribute;
@synthesize valueAttribute;
@synthesize helpAttribute;
@synthesize parentTitleAttribute;
@synthesize parentRoleAttribute;
@synthesize parentDescriptionAttribute;
@synthesize childrenAttribute;
@synthesize hasShortcut;
@synthesize shortcutString;
@synthesize language;
@synthesize user;
@synthesize date;


+ (UIElementItem*) initWithElementRef:(AXUIElementRef) menuItemRef {
   UIElementItem *aMenuBarItem = [[UIElementItem alloc] init];
  
  aMenuBarItem.appName = [UIElementUtilities readApplicationName];
  aMenuBarItem.appVersion = [StringUtilities getActiveApplicationVersionString];
  
  aMenuBarItem.memoryReference = (__bridge NSString *)(menuItemRef);
  
  // kAXRoleAttribute
  NSString *attribute = [UIElementUtilities readkAXAttributeString:menuItemRef :kAXRoleAttribute];
  if (attribute != NULL)
    aMenuBarItem.roleAttribute = [[StringUtilities cleanTitleString:attribute] lowercaseString];
  else
    aMenuBarItem.roleAttribute = @"";
  
  // kAXSubroleAttribute
  attribute = [UIElementUtilities readkAXAttributeString:menuItemRef :kAXSubroleAttribute];
  if (attribute != NULL)
    aMenuBarItem.subroleAttribute = [[StringUtilities cleanTitleString:attribute] lowercaseString];
  else
    aMenuBarItem.subroleAttribute = @"";
  
  // kAXRoleDescriptionAttribute
  attribute = [UIElementUtilities readkAXAttributeString:menuItemRef :kAXRoleDescriptionAttribute];
  if (attribute != NULL)
    aMenuBarItem.roleDescriptionAttribute = [[StringUtilities cleanTitleString:attribute] lowercaseString];
  else
    aMenuBarItem.roleDescriptionAttribute = @"";
  
  // kAXTitleAttribute
  attribute = [UIElementUtilities readkAXAttributeString:menuItemRef :kAXTitleAttribute];
  if (attribute != NULL)
    aMenuBarItem.titleAttribute = [[StringUtilities cleanTitleString:attribute] lowercaseString];
  else
    aMenuBarItem.titleAttribute = @"";
  
  // kAXDescriptionAttribute
  attribute = [UIElementUtilities readkAXAttributeString:menuItemRef :kAXDescriptionAttribute];
  if (attribute != NULL)
    aMenuBarItem.descriptionAttribute = [[StringUtilities cleanTitleString:attribute] lowercaseString];
  else
    aMenuBarItem.descriptionAttribute = @"";
  
//  // kAXValueAttribute
  attribute = [UIElementUtilities readkAXAttributeString:menuItemRef :kAXValueAttribute];
  if (attribute != NULL)
    aMenuBarItem.valueAttribute = [[StringUtilities cleanTitleString:attribute] lowercaseString];
  else
    aMenuBarItem.valueAttribute = @"";
  
  // kAXHelpAttribute
  attribute = [UIElementUtilities readkAXAttributeString:menuItemRef :kAXHelpAttribute];
  if (attribute != NULL)
    aMenuBarItem.helpAttribute = [[StringUtilities cleanTitleString:attribute] lowercaseString];
  else
    aMenuBarItem.helpAttribute = @"";
  
  // parentTitleAttribute and parentDescriptionAttribute
  AXUIElementRef parentRef;
  attribute = NULL;
  if(AXUIElementCopyAttributeValue( menuItemRef, (CFStringRef) kAXParentAttribute, (CFTypeRef*) &parentRef ) == kAXErrorSuccess)
  {
    while ( AXUIElementCopyAttributeValue( parentRef, (CFStringRef) kAXParentAttribute, (CFTypeRef*) &parentRef ) == kAXErrorSuccess && attribute == NULL)
    {
      attribute = [UIElementUtilities readkAXAttributeString:parentRef :kAXTitleAttribute];
      aMenuBarItem.parentTitleAttribute = [[StringUtilities cleanTitleString:attribute] lowercaseString];
      
      attribute = [UIElementUtilities readkAXAttributeString:parentRef :kAXRoleAttribute];
      aMenuBarItem.parentRoleAttribute = [[StringUtilities cleanTitleString:attribute] lowercaseString];
    }
  }
  
  // parentTitleAttribute and parentDescriptionAttribute
  parentRef = NULL;
  attribute = NULL;
  if(AXUIElementCopyAttributeValue( menuItemRef, (CFStringRef) kAXParentAttribute, (CFTypeRef*) &parentRef ) == kAXErrorSuccess)
  {
    while ( AXUIElementCopyAttributeValue( parentRef, (CFStringRef) kAXParentAttribute, (CFTypeRef*) &parentRef ) == kAXErrorSuccess && attribute == NULL)
    {
      attribute = [UIElementUtilities readkAXAttributeString:parentRef :kAXDescriptionAttribute];
      aMenuBarItem.parentDescriptionAttribute = [[StringUtilities cleanTitleString:attribute] lowercaseString];
    }
  }
  
  // kAXChildrenAttribute
  CFTypeRef ref;
  AXUIElementCopyAttributeValue( menuItemRef, (CFStringRef) kAXChildrenAttribute, (CFTypeRef*) &ref);
  if (ref != NULL)
    aMenuBarItem.childrenAttribute = (__bridge NSString *)(ref);
  else
    aMenuBarItem.childrenAttribute = @"";
  if(ref)
    CFRelease(ref);
  
  Boolean boolean = [UIElementUtilities hasHotkey:menuItemRef];
  aMenuBarItem.hasShortcut = boolean ? @"YES" : @"NO";

  if([aMenuBarItem.hasShortcut boolValue])
    aMenuBarItem.shortcutString = [StringUtilities composeShortcut:menuItemRef];
  else
    aMenuBarItem.shortcutString = @"";
  
  attribute = [[ApplicationSettings sharedApplicationSettings] language];
  if (attribute != NULL)
    aMenuBarItem.language = attribute;
  else
    aMenuBarItem.language = @"";

  attribute = [[ApplicationSettings sharedApplicationSettings] user];
  if (attribute != NULL)
    aMenuBarItem.user = attribute;
  else
    aMenuBarItem.user = @"";
  
  
  attribute = [DateUtilities getCurrentDateString];
  if (attribute != NULL)
    aMenuBarItem.date = attribute;
  else
    aMenuBarItem.date = @"";

  return aMenuBarItem;
}

+ (void) printObject :(UIElementItem*) item {
  DDLogInfo(@"appName : %@", item.appName);
  DDLogInfo(@"appVersion : %@", item.appVersion);
  DDLogInfo(@"hasShortcut : %@", item.hasShortcut);
  DDLogInfo(@"shortcutString : %@", item.shortcutString);
  DDLogInfo(@"titleAttribute : %@", item.titleAttribute);
  DDLogInfo(@"parentTitleAttribute : %@", item.parentTitleAttribute);
  DDLogInfo(@"parentRoleAttribute : %@", item.parentRoleAttribute);
  DDLogInfo(@"parentDescriptionAttribute : %@", item.parentDescriptionAttribute);
  DDLogInfo(@"roleAttribute : %@", item.roleAttribute);
  DDLogInfo(@"descriptionAttribute : %@", item.descriptionAttribute);
  DDLogInfo(@"helpAttribute : %@", item.helpAttribute);
  DDLogInfo(@"subroleAttribute : %@", item.subroleAttribute);
  DDLogInfo(@"roleDescriptionAttribute : %@", item.roleDescriptionAttribute);
  DDLogInfo(@"childrenAttribute : %@", item.childrenAttribute);
  DDLogInfo(@"language : %@", item.language);
}

@end
