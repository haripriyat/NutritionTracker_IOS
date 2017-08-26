//
//  ReminderTableViewController.h
//  nutritionTracker
//
//  Created by Htiruvee on 7/29/17.
//  Copyright © 2017 CarnegieMellonUniversity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GTLRCalendar.h>
#import "DeleteViewController.h"
#import "AppDelegate.h"

@interface ReminderTableViewController : UITableViewController <GIDSignInDelegate, GIDSignInUIDelegate>

@property (nonatomic, strong) IBOutlet GIDSignInButton *signInButton;
@property (nonatomic, strong) UITextView *output;
@property (nonatomic, strong) GTLRCalendar_Events *eventList;
@property (strong, nonatomic) DeleteViewController *deleteViewController;

@end
