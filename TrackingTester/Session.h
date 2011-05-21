//
//  Session.h
//  iPhoneBetaPhase
//
//  Created by Bryan Everly on 4/18/11.
//  Copyright 2011 BCE Associates, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface Session : RKObject <RKObjectLoaderDelegate> {
    NSString* _emailAddress;
    NSString* _password;
    NSString* _applicationPIN;
}

+(void) RegisterObject:(RKObjectManager*)RKObjectManager;
-(void) CreateObject;

@property (nonatomic, retain) NSString* emailAddress;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* applicationPIN;

@end
