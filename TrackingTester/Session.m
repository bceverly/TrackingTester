//
//  Session.m
//  iPhoneBetaPhase
//
//  Created by Bryan Everly on 4/18/11.
//  Copyright 2011 BCE Associates, Inc. All rights reserved.
//

#import "TrackingTesterAppDelegate.h"
#import "LoginViewController.h"
#import "Session.h"

@implementation Session

@synthesize emailAddress = _emailAddress;
@synthesize password = _password;
@synthesize applicationPIN = _applicationPIN;

+(void) RegisterObject:(RKObjectManager*)RKObjectManager {
    // Set Up the Object Mapper
	RKObjectMapper* mapper =  RKObjectManager.mapper;
	[mapper registerClass:[self class] forElementNamed:@"session"];
    
    // Set up the routes
    RKDynamicRouter* router = (RKDynamicRouter*)RKObjectManager.router;
    [router routeClass:[self class] toResourcePath:@"/api/1/login" forMethod:RKRequestMethodPOST];
}

-(void) CreateObject {
    // POST
    [[RKObjectManager sharedManager] postObject:self delegate:self];
}

+ (NSDictionary*)elementToPropertyMappings {  
    return [NSDictionary dictionaryWithKeysAndObjects:  
            @"email_address", @"emailAddress",  
            @"password", @"password",  
            @"application_pin", @"applicationPIN",  
            nil];  
}  

+ (NSDictionary*)elementToRelationshipMappings {
	return [NSDictionary dictionaryWithKeysAndObjects:
			nil];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"BaseModel loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {  
    NSLog(@"Session objects loaded: %@", objects);
    
    TrackingTesterAppDelegate *appDelegate = (TrackingTesterAppDelegate *)[[UIApplication sharedApplication] delegate];
    Session* theSession = [objects objectAtIndex:0];
    appDelegate.applicationPIN = theSession.applicationPIN;
    appDelegate.currentUser = theSession.emailAddress;
    NSLog(@"applicationPIN = %@", appDelegate.applicationPIN);
    
    LoginViewController *vc = (LoginViewController *)appDelegate.currentViewController;
    [vc SuccessfulLogin];
}  

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {  
    NSLog(@"Encountered an error: %@", error);  
    TrackingTesterAppDelegate *appDelegate = (TrackingTesterAppDelegate *)[[UIApplication sharedApplication] delegate];
    LoginViewController *vc = (LoginViewController *)appDelegate.currentViewController;
    [vc UnsuccessfulLogin];
}  

- (void)dealloc {
    [_emailAddress release];
    [_password release];
    [_applicationPIN release];
    
    [super dealloc];
}

@end
