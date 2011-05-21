//
//  User.h
//  iPhoneBetaPhase
//
//  Created by Bryan Everly on 4/17/11.
//  Copyright 2011 BCE Associates, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface User : RKObject <RKObjectLoaderDelegate> {
    NSNumber *_identifier;
    NSString *_firstName;
    NSString *_lastName;
    NSString *_emailAddress;
    NSString *_password;
    NSNumber *_currentWill;
    NSNumber *_currentEnergy;
    NSNumber *_currentScore;
    NSNumber *_currentReputation;
    NSString *_userHandle;
    NSNumber *_playerFactionId;
    NSString *_applicationPIN;
    NSString *_phoneNumber;
    NSNumber *_createdLongitude;
    NSNumber *_createdLatitude;
    NSNumber *_createdAltitude;
    NSString *_referralCode;
    NSNumber *_referredBy;
    NSNumber *_numberOfReferrals;
    NSDate *_createdAt;
    NSDate *_updatedAt;
    NSNumber *_longitude;
    NSNumber *_latitude;
    NSNumber *_altitude;
}

+(void) RegisterObject:(RKObjectManager*)RKObjectManager;
-(void) LoadMultipleObjects;

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain)NSString *firstName;
@property (nonatomic, retain)NSString *lastName;
@property (nonatomic, retain)NSString *emailAddress;
@property (nonatomic, retain)NSString *password;
@property (nonatomic, retain)NSNumber *currentWill;
@property (nonatomic, retain)NSNumber *currentEnergy;
@property (nonatomic, retain)NSNumber *currentScore;
@property (nonatomic, retain)NSNumber *currentReputation;
@property (nonatomic, retain)NSString *userHandle;
@property (nonatomic, retain)NSNumber *playerFactionId;
@property (nonatomic, retain)NSString *applicationPIN;
@property (nonatomic, retain)NSString *phoneNumber;
@property (nonatomic, retain)NSNumber *createdLongitude;
@property (nonatomic, retain)NSNumber *createdLatitude;
@property (nonatomic, retain)NSNumber *createdAltitude;
@property (nonatomic, retain)NSString *referralCode;
@property (nonatomic, retain)NSNumber *referredBy;
@property (nonatomic, retain)NSNumber *numberOfReferrals;
@property (nonatomic, retain)NSDate *createdAt;
@property (nonatomic, retain)NSDate *updatedAt;
@property (nonatomic, retain)NSNumber *longitude;
@property (nonatomic, retain)NSNumber *latitude;
@property (nonatomic, retain)NSNumber *altitude;

@end
