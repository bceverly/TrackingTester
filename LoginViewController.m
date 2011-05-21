//
//  LoginViewController.m
//  TrackingTester
//
//  Created by Bryan Everly on 5/19/11.
//  Copyright 2011 BCE Associates, Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "Session.h"

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [EmailAddress release];
    [Password release];
    [StatusMessage release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [EmailAddress release];
    EmailAddress = nil;
    [Password release];
    Password = nil;
    [StatusMessage release];
    StatusMessage = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)LoginClicked:(id)sender {
    [EmailAddress resignFirstResponder];
    [Password resignFirstResponder];
    
    Session* theSession = [[Session alloc]init];
    theSession.emailAddress = EmailAddress.text;
    theSession.password = Password.text;
    [theSession CreateObject];
    [theSession release];
}

-(void)SuccessfulLogin {
    UIView *view = [self view];
    [view removeFromSuperview];
}

-(void)UnsuccessfulLogin {
    NSString *message = [[NSString alloc]initWithFormat:@"Invalid email or password.  Login unsuccessful."];
    [StatusMessage setText:message];
    [message release];
}

@end
