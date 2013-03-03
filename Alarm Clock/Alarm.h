//
//  Alarm.h
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-23.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject {
    NSString *name;
    NSNumber *localId;
    NSDate *datetime;
    NSNumber *active;
    NSMutableArray *repeat;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *localId;
@property (nonatomic, retain) NSDate *datetime;
@property (nonatomic, retain) NSNumber *active;
@property (nonatomic, retain) NSMutableArray *repeat;

- (id)initWithName:(NSString *)n localId:(NSNumber *)lI datetime:(NSDate *)d active:(NSNumber *)a repeat:(NSMutableArray *)r;
- (NSString *)description;
//- (void)setActive:(NSNumber *)a;

@end
