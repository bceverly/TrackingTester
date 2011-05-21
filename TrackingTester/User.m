//
//  User.m
//  iPhoneBetaPhase
//
//  Created by Bryan Everly on 4/17/11.
//  Copyright 2011 BCE Associates, Inc. All rights reserved.
//

#import "User.h"
#import "TrackingTesterAppDelegate.h"

@implementation User

@synthesize identifier;
@synthesize firstName;
@synthesize lastName;
@synthesize emailAddress;
@synthesize password;
@synthesize currentWill;
@synthesize currentEnergy;
@synthesize currentScore;
@synthesize currentReputation;
@synthesize userHandle;
@synthesize playerFactionId;
@synthesize applicationPIN;
@synthesize phoneNumber;
@synthesize createdLongitude;
@synthesize createdLatitude;
@synthesize createdAltitude;
@synthesize referralCode;
@synthesize referredBy;
@synthesize numberOfReferrals;
@synthesize createdAt;
@synthesize updatedAt;
@synthesize longitude;
@synthesize latitude;
@synthesize altitude;

+(void) RegisterObject:(RKObjectManager*)RKObjectManager {
    // Set Up the Object Mapper
	RKObjectMapper* mapper =  RKObjectManager.mapper;
	[mapper registerClass:[self class] forElementNamed:@"user"];
    
    // Set up the routes
    RKDynamicRouter* router = (RKDynamicRouter*)RKObjectManager.router;
    [router routeClass:[self class] toResourcePath:@"/api/1/user" forMethod:RKRequestMethodPOST];
    [router routeClass:[self class] toResourcePath:@"/api/1/admin/user/(identifier)" forMethod:RKRequestMethodDELETE];
    [router routeClass:[self class] toResourcePath:@"/api/1/user/(identifier)" forMethod:RKRequestMethodPUT];
}

+ (NSDictionary*)elementToPropertyMappings {  
    return [NSDictionary dictionaryWithKeysAndObjects:  
            @"id", @"identifier",  
            @"first_name", @"firstName",  
            @"last_name", @"lastName",  
            @"email_address", @"emailAddress",  
            @"password", @"password",  
            @"current_will", @"currentWill",  
            @"current_energy", @"currentEnergy",  
            @"current_score", @"currentScore",  
            @"current_reputation", @"currentReputation",  
            @"user_handle", @"userHandle",  
            @"player_faction_id", @"playerFactionId",  
            @"application_pin", @"applicationPIN",  
            @"phone_number", @"phoneNumber",  
            @"created_longitude", @"createdLongitude",  
            @"created_latitude", @"createdLatitude",  
            @"created_altitude", @"createdAltitude",  
            @"referral_code", @"referralCode",  
            @"referred_by", @"referredBy",  
            @"number_of_referrals", @"numberOfReferrals",  
            @"created_at", @"createdAt",  
            @"updated_at", @"updatedAt",  
            @"longitude", @"longitude",  
            @"latitude", @"latitude",  
            @"altitude", @"altitude",  
            nil];  
}  

+ (NSDictionary*)elementToRelationshipMappings {
	return [NSDictionary dictionaryWithKeysAndObjects:
			nil];
}

-(void) LoadMultipleObjects {
    // GET
    TrackingTesterAppDelegate *appDelegate = (TrackingTesterAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *queryParms = [[NSDictionary alloc]initWithObjectsAndKeys:appDelegate.applicationPIN, @"application_pin", nil];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/api/1/user" queryParams:queryParms objectClass:[self class] delegate:self];
    [queryParms release];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Drone loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {  
    TrackingTesterAppDelegate *appDelegate = (TrackingTesterAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.nearbyUsers = objects;
}  

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {  
    NSLog(@"Encountered an error: %@", error);  
}

- (void)dealloc {
    [_identifier release];
    [_firstName release];
    [_lastName release];
    [_emailAddress release];
    [_password release];
    [_currentWill release];
    [_currentEnergy release];
    [_currentScore release];
    [_currentReputation release];
    [_userHandle release];
    [_playerFactionId release];
    [_applicationPIN release];
    [_phoneNumber release];
    [_createdLongitude release];
    [_createdLatitude release];
    [_createdAltitude release];
    [_referralCode release];
    [_referredBy release];
    [_numberOfReferrals release];
    [_createdAt release];
    [_updatedAt release];
    
    [super dealloc];
}

@end
