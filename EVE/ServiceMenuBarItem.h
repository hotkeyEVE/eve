//
//  ServiceMenuBarItem.h
//  EVE
//
//  Created by Tobias Sommer on 8/16/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIElementItem.h"

@interface ServiceMenuBarItem : NSObject

+ (void) updateMenuBarShortcutTable :(UIElementItem*) aMenuBarItem :(NSString*) appName;
+ (int) countShortcutsForActiveApp;

@end
