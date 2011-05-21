//
//  UserLocation.m
//  iPhoneBetaPhase
//
//  Created by Bryan Everly on 4/17/11.
//  Copyright 2011 BCE Associates, Inc. All rights reserved.
//

#import "UserLocation.h"
#import "TrackingTesterAppDelegate.h"

@implementation UserLocation

@synthesize identifier = _identifier;
@synthesize userId = _userId;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;
@synthesize altitude = _altitude;
@synthesize createdAt = _createdAt;
@synthesize updatedAt = _updatedAt;
@synthesize applicationPIN = _applicationPIN;

+(void) RegisterObject:(RKObjectManager*)RKObjectManager {
    // Set Up the Object Mapper
	RKObjectMapper* mapper =  RKObjectManager.mapper;
	[mapper registerClass:[self class] forElementNamed:@"user_location"];
    
    // Set up the routes
    RKDynamicRouter* router = (RKDynamicRouter*)RKObjectManager.router;
    [router routeClass:[self class] toResourcePath:@"/api/1/user_location/(identifier)?application_pin=(applicationPIN)" forMethod:RKRequestMethodGET];
    [router routeClass:[self class] toResourcePath:@"/api/1/user_location" forMethod:RKRequestMethodPOST];
    [router routeClass:[self class] toResourcePath:@"/api/1/user_location/(identifier)" forMethod:RKRequestMethodDELETE];
    [router routeClass:[self class] toResourcePath:@"/api/1/user_location/(identifier)" forMethod:RKRequestMethodPUT];
}

-(void) CreateObject {
    // POST
    [[RKObjectManager sharedManager] postObject:self delegate:self];
}

-(void) LoadSingleObject {
    // GET
    [[RKObjectManager sharedManager] getObject:self delegate:self];
}

+ (NSDictionary*)elementToPropertyMappings {  
    return [NSDictionary dictionaryWithKeysAndObjects:  
            @"id", @"identifier",  
            @"user_id", @"userId",  
            @"longitude", @"longitude",  
            @"latitude", @"latitude",  
            @"altitude", @"altitude",  
            @"created_at", @"createdAt",  
            @"updated_at", @"updatedAt",  
            @"application_pin", @"applicationPIN",  
            nil];  
}  

+ (NSDictionary*)elementToRelationshipMappings {
	return [NSDictionary dictionaryWithKeysAndObjects:
			nil];
}

- (void)dealloc {
    [_identifier release];
    [_userId release];
    [_longitude release];
    [_latitude release];
    [_altitude release];
    [_createdAt release];
    [_updatedAt release];
    
    [super dealloc];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"UserLocation loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {  
}  

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {  
    NSLog(@"Encountered an error: %@", error);  
}

@end
