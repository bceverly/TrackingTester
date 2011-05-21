//
//  TrackingTesterAppDelegate.h
//  TrackingTester
//
//  Created by Bryan Everly on 5/19/11.
//  Copyright 2011 BCE Associates, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AccuracyBarView.h"
#import "User.h"

@interface TrackingTesterAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
    NSString *applicationPIN;
    NSString *currentUser;
    UIViewController *currentViewController;
    CLLocationManager *locMgr;
    NSTimer *aTimer;
    IBOutlet UILabel *currentLatitude;
    IBOutlet UILabel *currentLongitude;
    IBOutlet UILabel *currentAltitude;
    IBOutlet UILabel *xyAccuracy;
    IBOutlet UILabel *zAccuracy;
    IBOutlet AccuracyBarView *xyAccuracyBarView;
    IBOutlet AccuracyBarView *zAccuracyBarView;
    IBOutlet UILabel *Distance;
    IBOutlet UILabel *Angle;
    User *_userFinder;
    NSArray *_nearbyUsers;
    double _longitude;
    double _latitude;
    IBOutlet UILabel *currentHeading;
    IBOutlet UILabel *headingAccuracy;
    IBOutlet UILabel *CurrentTargetName;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NSString *applicationPIN;
@property (nonatomic, retain) NSString *currentUser;
@property (nonatomic, retain) UIViewController *currentViewController;
@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic, retain) IBOutlet AccuracyBarView *xyAccuracyBarView;
@property (nonatomic, retain) IBOutlet AccuracyBarView *zAccuracyBarView;
@property (nonatomic, retain) User *userFinder;
@property (nonatomic, retain) NSArray *nearbyUsers;

-(void) startTimer;
-(void) stopTimer;

@end
