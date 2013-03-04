//
//  Alarm.m
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-23.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import "Alarm.h"

@implementation Alarm

@synthesize name, localId, datetime, active, repeat;

-(id)initWithName:(NSString *)n localId:(NSNumber *)lI datetime:(NSDate *)d active:(NSNumber *)a repeat:(NSMutableArray *)r {
	self.name = n;
	self.localId = lI;
	self.datetime = d;
	self.active = a;
	self.repeat = r;
	return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Name: %@, LocalId: %@, Datetime: %@, Active: %@, Repeat: %@", self.name, self.localId, self.datetime, self.active, self.repeat];
}
/*
- (void)setActive:(NSNumber *)a {
    //self.active = a;
}
*/
@end
