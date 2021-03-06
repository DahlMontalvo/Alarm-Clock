//
//  Singleton.m
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Singleton.h"

static Singleton *shared = NULL;

@implementation Singleton
@synthesize sharedPrefs;

- (id)init
{
    if ( self = [super init] )
    {
        self.sharedPrefs = [[NSUserDefaults alloc] init];
    }
    return self;
}

+ (Singleton *)sharedSingleton
{
   
    {
        if ( !shared || shared == NULL )
        {
            
            // allocate the shared instance, because it hasn't been done yet
            shared = [[Singleton alloc] init];
        }
        
        return shared;
    }
}


@end
