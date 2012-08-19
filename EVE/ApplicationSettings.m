//
//  ApplicationSettings.m
//  EVE
//
//  Created by Tobias Sommer on 8/15/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "ApplicationSettings.h"
#import "NSFileManager+DirectoryLocations.h"
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation ApplicationSettings

@synthesize language;
@synthesize user;
@synthesize applicationSupportDictionary;
@synthesize sharedAppDelegate;
@synthesize sharedDatabase;
@synthesize sharedClickContext;

+ (id) sharedApplicationSettings {
  static ApplicationSettings *sharedApplicationSettings = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedApplicationSettings = [[self alloc] init];
  });
  return sharedApplicationSettings;
}

- (id)init {
  if (self = [super init]) {
    language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    user = NSUserName();
    applicationSupportDictionary = [[NSFileManager defaultManager] applicationSupportDirectory];
  }
  
  return self;
}


@end