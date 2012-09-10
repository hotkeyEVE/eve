//
//  Indexing_Log_12_08_23.m
//  EVE
//
//  Created by Tobias Sommer on 9/10/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "Create_Indexing_Log_12_08_23.h"

@implementation Create_Indexing_Log_12_08_23

- (void)up {
  [self createTable:@"indexing_log"  withColumns:[NSArray arrayWithObjects:
                   [FmdbMigrationColumn columnWithColumnName:@"AppName" columnType:@"string"],
                   [FmdbMigrationColumn columnWithColumnName:@"AppVersion" columnType:@"string"],
                   [FmdbMigrationColumn columnWithColumnName:@"Language" columnType:@"string"],
                   [FmdbMigrationColumn columnWithColumnName:@"User" columnType:@"string"],
                   [FmdbMigrationColumn columnWithColumnName:@"Date" columnType:@"string"],
                   [FmdbMigrationColumn columnWithColumnName:@"Finished" columnType:@"string" defaultValue:@"NO"],
                   nil]];
  
}

- (void)down {
  
}

@end
