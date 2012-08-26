//
//  Database.h
//  EVE
//
//  Created by Tobias Sommer on 8/23/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface Database : NSObject {

}

  + (FMDatabase*) initDatabaseFromSupportDirectory;
  + (void) executeMigrations :(NSString*) dbPath;

@end
