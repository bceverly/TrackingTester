//
//  UserLocation.h
//  iPhoneBetaPhase
//
//  Created by Bryan Everly on 4/17/11.
//  Copyright 2011 BCE Associates, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface UserLocation : RKObject <RKObjectLoaderDelegate> {
    NSNumber *_identifier;
    NSNumber *_userId;
    NSNumber *_longitude;
    NSNumber *_latitude;
    NSNumber *_altitude;
    NSDate *_createdAt;
    NSDate *_updatedAt;
    NSString *_applicationPIN;
}

+(void) RegisterObject:(RKObjectManager*)RKObjectManager;
-(void) CreateObject;
-(void) LoadSingleObject;

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSNumber *userId;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *altitude;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSDate *updatedAt;
@property (nonatomic, retain) NSString *applicationPIN;

@end
