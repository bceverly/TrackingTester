//
//  TrackingTesterAppDelegate.m
//  TrackingTester
//
//  Created by Bryan Everly on 5/19/11.
//  Copyright 2011 BCE Associates, Inc. All rights reserved.
//

#import "TrackingTesterAppDelegate.h"
#import "LoginViewController.h"
#import "Session.h"
#import "UserLocation.h"

#import <RestKit/RestKit.h>

@implementation TrackingTesterAppDelegate


@synthesize window=_window;
@synthesize applicationPIN;
@synthesize currentUser;
@synthesize currentViewController;
@synthesize locMgr;
@synthesize xyAccuracyBarView;
@synthesize zAccuracyBarView;
@synthesize userFinder=_userFinder;
@synthesize nearbyUsers=_nearbyUsers;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Create the finder object
    _userFinder = [[User alloc]init];

    // Start the timer
    [self startTimer];

	// Initialize the RestKit Object Manager
	RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:@"http://beta-phase.com"];
    
    // Set up the RestKit Dynamic Router
    RKDynamicRouter* router = [RKDynamicRouter new];
    objectManager.router = router;
    
    // Register each of the remote models
    [Session RegisterObject:objectManager];
    [UserLocation RegisterObject:objectManager];

    self.locMgr = [[[CLLocationManager alloc] init] autorelease]; // Create new instance of locMgr
    self.locMgr.delegate = self; // Set the delegate as self.
    locMgr.desiredAccuracy = kCLLocationAccuracyBest;
    [locMgr startUpdatingLocation];
    [locMgr startUpdatingHeading];

    // Register our ViewController
    LoginViewController *viewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    [self.window setRootViewController:viewController];
    self.currentViewController = viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [locMgr stopUpdatingLocation];
    [locMgr stopUpdatingHeading];
    [self stopTimer];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [locMgr startUpdatingLocation];
    [locMgr startUpdatingHeading];
    [self startTimer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [locMgr startUpdatingLocation];
    [locMgr startUpdatingHeading];
    [self startTimer];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)locationManager:(CLLocationManager *)manager 
       didUpdateHeading:(CLHeading *)newHeading
{
    [currentHeading setText:[[NSString alloc]initWithFormat:@"%3.0f", newHeading.trueHeading]];
    [headingAccuracy setText:[[NSString alloc]initWithFormat:@"%f", newHeading.headingAccuracy]];
}

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation 
{
    CLLocationCoordinate2D pos = [newLocation coordinate];
    
    double altitude = [newLocation altitude];
    double longitude = pos.longitude;
    double latitude = pos.latitude;
    
    double horizontalAccuracy = [newLocation horizontalAccuracy];
    double verticalAccuracy = [newLocation verticalAccuracy];
    
    NSString *nsAltitude = [[NSString alloc]initWithFormat:@"%f", altitude];
    NSString *nsLongitude = [[NSString alloc]initWithFormat:@"%f", longitude];
    NSString *nsLatitude = [[NSString alloc]initWithFormat:@"%f", latitude];
    NSString *nsXYAccuracy = [[NSString alloc]initWithFormat:@"%f", horizontalAccuracy];
    NSString *nsZAccuracy = [[NSString alloc]initWithFormat:@"%f", verticalAccuracy];
    
    [currentAltitude setText:nsAltitude];
    [currentLongitude setText:nsLongitude];
    [currentLatitude setText:nsLatitude];
    [xyAccuracy setText:nsXYAccuracy];
    [zAccuracy setText:nsZAccuracy];
    
    // Update the xyAccuracy
    AccuracyBarView *theView = self.xyAccuracyBarView;
    theView.currentAccuracy = [[NSNumber alloc]initWithFloat:horizontalAccuracy];
    theView.bestAccuracy = [[NSNumber alloc]initWithFloat:10.0];  // Best guess
    [theView setNeedsDisplay];
    
    theView = self.zAccuracyBarView;
    theView.currentAccuracy = [[NSNumber alloc]initWithFloat:verticalAccuracy];
    theView.bestAccuracy = [[NSNumber alloc]initWithFloat:20.0]; // Best guess
    [theView setNeedsDisplay];
    
    // Pass the information on to the server
    UserLocation *ul = [[UserLocation alloc]init];
    ul.longitude = [[NSNumber alloc]initWithFloat:longitude];
    ul.latitude = [[NSNumber alloc]initWithFloat:latitude];
    ul.altitude = [[NSNumber alloc]initWithFloat:altitude];
    ul.applicationPIN = self.applicationPIN;
    [ul CreateObject];
    
    // Save in instance
    _longitude = longitude;
    _latitude = latitude;
}

-(void)updateUser {
    if (_nearbyUsers != nil) {
        for(int i=0 ; i<_nearbyUsers.count ; i++) {
            User *theUser = [_nearbyUsers objectAtIndex:i];
            if (theUser != nil) {
                // See if this is the user we are tracking
                NSString *targetName = [[NSString alloc]initWithFormat:@"%@ %@", theUser.firstName, theUser.lastName];
                NSString *currentlyTracking = [CurrentTargetName text];
                if ([currentlyTracking length] == 0) {
                    // If we aren't tracking someone, take the first one that comes along
                    [CurrentTargetName setText:targetName];
                    currentlyTracking = [CurrentTargetName text];
                }
                
                if ([targetName compare:currentlyTracking] == NSOrderedSame) {
                    // This is not me
                    NSLog(@"Found another user with longitude=%@ and latitude=%@", theUser.longitude, theUser.latitude);
                    [CurrentTargetName setText:[[NSString alloc]initWithFormat:@"%@ %@", theUser.firstName, theUser.lastName]];
                    
                    // Here are the constants we use for the calculations
                    double pi = 3.1415926535;
                    double equatorialRadius_meters = 6378137.0;
                    double b_over_a_for_wgs84 = 0.99664719;
                    double first_latitude_constant = 111132.954;
                    double second_latitude_constant = 559.822;
                    double third_latitude_constant = 1.175;
                    
                    // Calculate the difference between the two points in units of arc degrees
                    double deltaX = _longitude - [theUser.longitude floatValue];
                    double deltaY = _latitude - [theUser.latitude floatValue];
                    
                    // Calculate the distance in meters of one degree of latitude using the standard
                    // formula found in Wikipedia:
                    double oneDegLatitude = (first_latitude_constant-(second_latitude_constant*cos(2*_latitude))+(third_latitude_constant*cos(4*_latitude)));
                    
                    // To determine the distance in meters of one degree of longitude at a particular
                    // latitude, it is first necessary to calculate the parametric latitude (or Beta)
                    double parametricLatitude = atan(b_over_a_for_wgs84*tan(_latitude));
                    
                    // Calculate the distance in meters of one degree of longitude at our current latitude
                    // using Beta (parametric latitude)
                    double oneDegLongitude = (pi/180)*equatorialRadius_meters*cos(parametricLatitude);
                    
                    // Now that we have our length conversions for one degree to meters, use them to
                    // convert the deltas to meters
                    double deltaX_meters = deltaX * oneDegLongitude;
                    double deltaY_meters = deltaY * oneDegLatitude;
                    
                    // Given the deltas are now in meters, use the pythagorean theorem to calculate
                    // the length of they hypotenuse between the two points:
                    double deltaD_meters = sqrt(pow(deltaX_meters, 2) + pow(deltaY_meters, 2));
                    
                    // Display the resulting distance on the screen
                    [Distance setText:[[NSString alloc]initWithFormat:@"%3.4f", deltaD_meters]];
                    
                    // Calculate the angle between the two points in radians
                    double theta = 0.0;
                    double targetLongitude = [theUser.longitude floatValue];
                    double targetLatitude = [theUser.latitude floatValue];
                    if ((targetLongitude == _longitude) && (targetLatitude == _latitude)) {
                        theta = 0.0;
                    } else if ((targetLongitude == _longitude) && (targetLatitude < _latitude)) {
                        theta = -pi / 2.0;
                    } else if ((targetLongitude == _longitude) && (targetLatitude > _latitude)) {
                        theta = pi / 2.0;
                    } else if ((targetLongitude > _longitude) && (targetLatitude != _latitude)) {
                        theta = atan(deltaY_meters / deltaX_meters);
                    } else if ((targetLongitude < _longitude) && (targetLatitude >= _latitude)) {
                        theta = atan(deltaY_meters / deltaX_meters) + pi;
                    } else if ((targetLongitude < _longitude) && (targetLatitude < _latitude)) {
                        theta = atan(deltaY_meters / deltaX_meters) - pi;
                    }
                    
                    // Convert to degrees
                    theta = theta * 180 / pi;
                    
                    // Display the angle on the screen
                    [Angle setText:[[NSString alloc]initWithFormat:@"%3.0f", theta]];
                }
            }
        }
    }

    // Ask the server for the list of users
    // Call the REST API to update the user positions
    [self.userFinder LoadMultipleObjects];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
}

- (void)timerFired:(NSTimer *)theTimer {    
    NSLog(@"timerFired at %@", [theTimer fireDate]);
    [self updateUser];
}

-(void) startTimer {
    aTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                              target:self
                                            selector:@selector(timerFired:) 
                                            userInfo:nil 
                                             repeats:YES];
    
    // Update initial position
    [self updateUser];
}

-(void) stopTimer {
    [aTimer invalidate];
    //    [aTimer release];
}

- (void)dealloc
{
    [_userFinder release];
    [_window release];
    [currentLatitude release];
    [currentLongitude release];
    [currentAltitude release];
    [xyAccuracy release];
    [zAccuracy release];
    [xyAccuracyBarView release];
    [zAccuracyBarView release];
    [Distance release];
    [Angle release];
    [currentHeading release];
    [headingAccuracy release];
    [CurrentTargetName release];
    [super dealloc];
}

@end
