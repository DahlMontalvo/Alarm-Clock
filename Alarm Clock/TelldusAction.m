//
//  TelldusAction.m
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-24.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import "TelldusAction.h"

@implementation TelldusAction

@synthesize telldusDeviceId, telldusDeviceName, action, offset, localId, alarmId;

- (id)initWithTelldusDeviceId:(NSNumber *)tId telldusDeviceName:(NSString *)tN action:(NSString *)a offset:(NSNumber *)o localId:(NSNumber *)lId alarmId:(NSNumber *)aId {
    self.telldusDeviceId = tId;
    self.telldusDeviceName = tN;
    self.action = a;
    self.offset = o;
    self.localId = lId;
    self.alarmId = aId;
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"LocalId: %@, AlarmId: %@, TelldusId: %@, TelldusName: %@, Action: %@, Offset: %@", self.localId, self.alarmId, self.telldusDeviceId, self.telldusDeviceName, self.action, self.offset];
}

@end
