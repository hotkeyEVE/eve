//
//  DateUtilities.h
//  EVE
//
//  Created by Tobias Sommer on 8/17/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtilities : NSObject

+ (NSString*) getCurrentDateString;
+ (NSTimeInterval) calculateTimeIntervalBetweenToDates :(NSString*) date1String :(NSString*) date2String;
+ (NSDateFormatter*) getDateFormatter;
@end
