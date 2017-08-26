//
//  AddReminderViewController.h
//  nutritionTracker
//
//  Created by Htiruvee on 7/29/17.
//  Copyright © 2017 CarnegieMellonUniversity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GTLRCalendar.h>
#import "AppDelegate.h"

@interface AddReminderViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate>
@property (weak, nonatomic) IBOutlet UITextField *eventName;
@property (weak, nonatomic) IBOutlet UITextView *description;
- (IBAction)date:(id)sender;
- (IBAction)start:(id)sender;
- (IBAction)end:(id)sender;
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UIDatePicker *start;
@property (weak, nonatomic) IBOutlet UIDatePicker *end;
@property (weak, nonatomic) IBOutlet NSString *startDate;
@property (weak, nonatomic) IBOutlet NSString *endDate;


@end
