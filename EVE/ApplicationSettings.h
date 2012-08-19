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

@interface ApplicationSettings : NSObject {
  NSString    *language;
  NSString    *user;
  NSString    *applicationSupportDictionary;
  AppDelegate *sharedAppDelegate;
  FMDatabase  *sharedDatabase;
  NSDictionary *sharedClickContext;
}

@property(readonly,  getter = language, retain) NSString *language;
@property(readonly,  getter = user, retain) NSString *user;
@property(readonly,  getter = applicationSupportDictionary, retain) NSString * applicationSupportDictionary;
@property(readwrite, setter = setSharedAppDelegate:, getter = sharedAppDelegate, retain) AppDelegate *sharedAppDelegate;
@property(readwrite, getter = getSharedDatabase, retain) FMDatabase *sharedDatabase;
@property(readwrite, setter = setSharedClickContext:, getter = getSharedClickContext, retain) NSDictionary *sharedClickContext;

+ (id) sharedApplicationSettings;

@end
