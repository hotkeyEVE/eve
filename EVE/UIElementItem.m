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
#import "UIElementUtilities_org.h"


static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation UIElementItem

//@synthesize appName;
//@synthesize appVersion;
//@synthesize isGUIElement;
//@synthesize isInMenuBar;
//@synthesize hasShortcut;
//@synthesize shortcutString;
//@synthesize roleAttribute;
//@synthesize subroleAttribute;
//@synthesize roleDescriptionAttribute;
//@synthesize titleAttribute;
//@synthesize descriptionAttribute;
//@synthesize valueAttribute;
//@synthesize helpAttribute;
//@synthesize parentTitleAttribute;
//@synthesize parentRoleAttribute;
//@synthesize parentDescriptionAttribute;
//@synthesize language;
//@synthesize user;
//@synthesize date;

+ (UIElementItem*) initWithElementRef:(AXUIElementRef) elementRef {
  UIElementItem *aUIElementItem = [[UIElementItem alloc] init];
  
  NSString *lineageOfUIElement = [UIElementUtilities_org lineageDescriptionOfUIElement:elementRef];
  
  aUIElementItem.appName =       [StringUtilities getActiveApplicationName];
  aUIElementItem.appVersion =    [StringUtilities getActiveApplicationVersionString];
  aUIElementItem.isGUIElement =  [UIElementUtilities isGUIElement :elementRef :lineageOfUIElement];
  aUIElementItem.isInMenuBar =   [UIElementUtilities isInMenuBar :elementRef :lineageOfUIElement];
  aUIElementItem.isMenuBarItem = [UIElementUtilities isMenuBarItem :elementRef :lineageOfUIElement];
  aUIElementItem.hasShortcut =   [UIElementUtilities hasHotkey:elementRef];

  // kAXRoleAttribute
  NSString *attribute = [UIElementUtilities readkAXAttributeString:elementRef :kAXRoleAttribute];
  aUIElementItem.roleAttribute = attribute ? [StringUtilities cleanTitleString:attribute] : @"";

  // kAXSubroleAttribute
  attribute = [UIElementUtilities readkAXAttributeString:elementRef :kAXSubroleAttribute];
  aUIElementItem.subroleAttribute = attribute ? [StringUtilities cleanTitleString:attribute] : @"";
  
  // kAXRoleDescriptionAttribute
  attribute = [UIElementUtilities readkAXAttributeString:elementRef :kAXRoleDescriptionAttribute];
  aUIElementItem.roleDescriptionAttribute = attribute ? [StringUtilities cleanTitleString:attribute] : @"";
  
  // kAXTitleAttribute
  attribute = [UIElementUtilities readkAXAttributeString:elementRef :kAXTitleAttribute];
  aUIElementItem.titleAttribute = attribute ? [StringUtilities cleanTitleString:attribute] : @"";
  
  // kAXDescriptionAttribute
  attribute = [UIElementUtilities readkAXAttributeString:elementRef :kAXDescriptionAttribute];
  aUIElementItem.descriptionAttribute = attribute ? [StringUtilities cleanTitleString:attribute] : @"";
  
  // kAXValueAttribute
  attribute = [UIElementUtilities readkAXAttributeString:elementRef :kAXValueAttribute];
  aUIElementItem.valueAttribute = attribute ? [StringUtilities cleanTitleString:attribute] : @"";
  
  // kAXHelpAttribute
  attribute = [UIElementUtilities readkAXAttributeString:elementRef :kAXHelpAttribute];
  aUIElementItem.helpAttribute = attribute ? [StringUtilities cleanTitleString:attribute] : @"";

  // parentTitleAttribute and parentDescriptionAttribute
  // Go two steps ahead to read the parent
  AXUIElementRef parentRef = [UIElementUtilities getSecondParent:elementRef];
      if (parentRef) {
        attribute = [UIElementUtilities readkAXAttributeString:parentRef :kAXTitleAttribute];
        aUIElementItem.parentTitleAttribute = attribute ? [StringUtilities cleanTitleString:attribute] : @"";

        attribute = [UIElementUtilities readkAXAttributeString:parentRef :kAXDescriptionAttribute];
        aUIElementItem.parentDescriptionAttribute = attribute ? [StringUtilities cleanTitleString:attribute] : @"";
        
        attribute = [UIElementUtilities readkAXAttributeString:parentRef :kAXRoleAttribute];
        aUIElementItem.parentRoleAttribute = attribute ? [StringUtilities cleanTitleString:attribute] : @"";
      }


  // language
  attribute = [[ApplicationSettings sharedApplicationSettings] userLanguage];
  aUIElementItem.language = attribute ? attribute : @"";

  // User
  attribute = [[ApplicationSettings sharedApplicationSettings] user];
  aUIElementItem.user = attribute ? attribute : @"";
  
  // Date
  attribute = [DateUtilities getCurrentDateString];
  aUIElementItem.date = attribute ? attribute : @"";
  
  return aUIElementItem;
}

+ (void) printObject :(UIElementItem*) item {
  DDLogInfo(@"----------------------------------------------------------------");
  DDLogInfo(@"appName : %@", item.appName);
  DDLogInfo(@"appVersion : %@", item.appVersion);
  DDLogInfo(@"hasShortcut : %i", item.hasShortcut);
  DDLogInfo(@"shortcutString : %@", item.shortcutString);
  DDLogInfo(@"titleAttribute : %@", item.titleAttribute);
  DDLogInfo(@"parentTitleAttribute : %@", item.parentTitleAttribute);
  DDLogInfo(@"parentDescriptionAttribute : %@", item.parentDescriptionAttribute);
  DDLogInfo(@"parentRoleAttribute : %@", item.parentRoleAttribute);
  DDLogInfo(@"roleAttribute : %@", item.roleAttribute);
  DDLogInfo(@"descriptionAttribute : %@", item.descriptionAttribute);
  DDLogInfo(@"helpAttribute : %@", item.helpAttribute);
  DDLogInfo(@"subroleAttribute : %@", item.subroleAttribute);
  DDLogInfo(@"roleDescriptionAttribute : %@", item.roleDescriptionAttribute);
  DDLogInfo(@"language : %@", item.language);
  DDLogInfo(@"GUIElement : %i", item.isGUIElement);
  DDLogInfo(@"MenuBarElement : %i", item.isMenuBarItem);
  DDLogInfo(@"----------------------------------------------------------------");
}

@end
