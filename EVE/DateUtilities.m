//
//  DateUtilities.m
//  EVE
//
//  Created by Tobias Sommer on 8/17/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "DateUtilities.h"
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation DateUtilities

+ (NSString*) getCurrentDateString {
  // get the current date
  NSDate *date = [NSDate date];
  
  NSDateFormatter *dateFormat = [self getDateFormatter];
  
  // convert it to a string
  NSString *dateString = [dateFormat stringFromDate:date];
  
  return dateString;
}

+ (NSTimeInterval) calculateTimeIntervalBetweenToDates :(NSString*) date1String :(NSString*) date2String {
  NSDateFormatter *dateFormat = [self getDateFormatter];
  
  NSDate *date1 = [dateFormat dateFromString:date1String];
  NSDate *date2 = [dateFormat dateFromString:date2String];
  
  NSTimeInterval diff = [date2 timeIntervalSinceDate:date1];

  return diff;
}

+ (NSDateFormatter*) getDateFormatter {
  // format it
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateStyle:NSDateFormatterLongStyle];
  [dateFormat setTimeStyle:NSDateFormatterLongStyle];
  return dateFormat;
}

@end
