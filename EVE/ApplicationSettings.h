//
//  ApplicationSettings.h
//  EVE
//
//  Created by Tobias Sommer on 8/15/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "MenuBar.h"

@interface ApplicationSettings : NSObject {
  NSString     *userLanguage;
  NSString    *user;
  NSString    *applicationSupportDictionary;
  AppDelegate *sharedAppDelegate;
  FMDatabase  *sharedDatabase;
  NSDictionary *sharedClickContext;
  MenuBar      *menuBar;
}

@property(readwrite, getter = userLanguage, retain) NSString *userLanguage;
@property(readonly,  getter = user, retain) NSString *user;
@property(readonly,  getter = applicationSupportDictionary, retain) NSString * applicationSupportDictionary;
@property(readwrite, setter = setSharedAppDelegate:, getter = sharedAppDelegate, retain) AppDelegate *sharedAppDelegate;
@property(readwrite, getter = getSharedDatabase, retain) FMDatabase *sharedDatabase;
@property(readwrite, setter = setSharedClickContext:, getter = getSharedClickContext, retain) NSDictionary *
sharedClickContext;
@property(readwrite, setter = setMenuBar:, getter = getMenuBar, retain) MenuBar* menuBar;

+ (id) sharedApplicationSettings;

@end
