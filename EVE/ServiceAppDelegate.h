//
//  ServiceAppDelegate.h
//  EVE
//
//  Created by Tobias Sommer on 8/18/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIElementItem.h"

@interface ServiceAppDelegate : NSObject

+ (BOOL) checkIfAppAlreadyInDatabase;
+ (BOOL) checkIfAppIsDisabled;
+ (BOOL) checkGUISupport;

@end
