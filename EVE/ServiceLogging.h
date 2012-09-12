//
//  ServiceLogging.h
//  EVE
//
//  Created by Tobias Sommer on 9/10/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "FmdbMigration.h"

@interface ServiceLogging : FmdbMigration

+ (sqlite_int64) insertIndexingEntry :(NSString*) appName;
+ (void) updateIndexingEntry :(sqlite_int64) rowId;
+ (BOOL) isIndexingActive :(NSString*) appName;
+ (int) countAppIndexing :(NSString*) appName;
@end
