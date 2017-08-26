//
//  DeleteViewController.h
//  nutritionTracker
//
//  Created by Htiruvee on 7/29/17.
//  Copyright © 2017 CarnegieMellonUniversity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GTLRCalendar.h>
#import "AppDelegate.h"

@interface DeleteViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UITextField *itemEvent;
@property (weak, nonatomic) IBOutlet UITextField *itemDate;
@property (weak, nonatomic) IBOutlet UITextField *itemStart;
@property (weak, nonatomic) IBOutlet UITextField *itemEnd;
@property (weak, nonatomic) IBOutlet UITextView *itemDescription;

@property (strong, nonatomic) NSString *event;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *start;
@property (strong, nonatomic) NSString *end;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *eventId;
@property (nonatomic, strong) IBOutlet GIDSignInButton *signInButton;
@property (nonatomic, strong) GTLRCalendarService *service;

- (IBAction)delete:(id)sender;
@end
