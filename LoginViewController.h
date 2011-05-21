//
//  LoginViewController.h
//  TrackingTester
//
//  Created by Bryan Everly on 5/19/11.
//  Copyright 2011 BCE Associates, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController {
    
    IBOutlet UITextField *EmailAddress;
    IBOutlet UITextField *Password;
    IBOutlet UILabel *StatusMessage;
}
- (IBAction)LoginClicked:(id)sender;

-(void)SuccessfulLogin;
-(void)UnsuccessfulLogin;

@end
