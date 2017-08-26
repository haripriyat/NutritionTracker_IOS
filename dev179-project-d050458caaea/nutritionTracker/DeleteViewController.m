//
//  DeleteViewController.m
//  nutritionTracker
//
//  Created by Htiruvee on 7/29/17.
//  Copyright © 2017 CarnegieMellonUniversity. All rights reserved.
//

#import "DeleteViewController.h"

@interface DeleteViewController ()

@end

@implementation DeleteViewController

@synthesize description;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.itemEvent.text = _event;
    self.itemDate.text = _date;
    self.itemStart.text = _start;
    self.itemEnd.text = _end;
    self.itemDescription.text = description;
    
    // Configure Google Sign-in.
    GIDSignIn* signIn = [GIDSignIn sharedInstance];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeCalendar, nil];
    [signIn signInSilently];
    
    // Add the sign-in button.
    self.signInButton = [[GIDSignInButton alloc] init];
    [self.view addSubview:self.signInButton];
    
    // Initialize the service object.
    self.service = [[GTLRCalendarService alloc] init];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    }
    else {
        self.signInButton.hidden = true;
        //self.output.hidden = false;
        self.service.authorizer = user.authentication.fetcherAuthorizer;
        //[self fetchEvents];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)delete:(id)sender {
    GTLRCalendarQuery_EventsDelete *query =
    [GTLRCalendarQuery_EventsDelete queryWithCalendarId:@"primary" eventId:_eventId];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [appDelegate.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}

- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket
             finishedWithObject:(GTLRCalendar_Events *)events
                          error:(NSError *)error {
    
    if(error == nil){
        [self showAlert:@"Success" message:@"Deleted"];
    }
    else{
        [self showAlert:@"Error" message:error.debugDescription];
    }
    
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
         UINavigationController *navigationController = self.navigationController;
         [navigationController popViewControllerAnimated:YES];
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
