//
//  TelldusAction.h
//  Alarm Clock
//
//  Created by Jonas Dahl on 2013-02-24.
//  Copyright (c) 2013 Dahl & Montalvo Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TelldusAction : NSObject {
    NSNumber *telldusDeviceId;
    NSString *telldusDeviceName;
    NSString *action;
    NSNumber *offset;
    NSNumber *localId;
    NSNumber *alarmId;
}

@property (nonatomic, retain) NSNumber *telldusDeviceId;
@property (nonatomic, retain) NSString *telldusDeviceName;
@property (nonatomic, retain) NSString *action;
@property (nonatomic, retain) NSNumber *offset;
@property (nonatomic, retain) NSNumber *localId;
@property (nonatomic, retain) NSNumber *alarmId;

- (id)initWithTelldusDeviceId:(NSNumber *)tId telldusDeviceName:(NSString *)tN action:(NSString *)a offset:(NSNumber *)o localId:(NSNumber *)lId alarmId:(NSNumber *)aId;

@end
