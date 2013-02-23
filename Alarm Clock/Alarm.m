//
//  Alarm.m
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-23.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import "Alarm.h"

@implementation Alarm

@synthesize name, localId, datetime, active;

-(id)initWithName:(NSString *)n localId:(NSNumber *)lI datetime:(NSDate *)d active:(NSNumber *)a {
	self.name = n;
	self.localId = lI;
	self.datetime = d;
	self.active = a;
	return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Name: %@, LocalId: %@, Datetime: %@, Active: %@", self.name, self.localId, self.datetime, self.active];
}

@end
