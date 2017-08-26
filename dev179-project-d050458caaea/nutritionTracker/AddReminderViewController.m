//
//  AddReminderViewController.m
//  nutritionTracker
//
//  Created by Htiruvee on 7/29/17.
//  Copyright © 2017 CarnegieMellonUniversity. All rights reserved.
//

#import "AddReminderViewController.h"

@interface AddReminderViewController ()

@end

@implementation AddReminderViewController

@synthesize description;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)save:(id)sender {
    GTLRCalendar_Event *event = [[GTLRCalendar_Event alloc] init];
    [event setSummary:self.eventName.text];
    [event setDescriptionProperty:self.description.text];
    
    NSDateFormatter *dateTimeFormat = [[NSDateFormatter alloc] init];
    [dateTimeFormat setDateFormat:@"MM-dd-yyyy hh:mm a"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    
    NSString *eventDate = [dateFormat stringFromDate:[_date date]];
    
    NSString *startDate = [timeFormat stringFromDate:[_start date]];
    
    NSString *endDate = [timeFormat stringFromDate:[_end date]];
    
    self.startDate = [NSString stringWithFormat:@"%@ %@", eventDate, startDate];
    self.endDate = [NSString stringWithFormat:@"%@ %@", eventDate, endDate];
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"MM-dd-yyyy hh:mm a"];
    
    GTLRCalendar_EventDateTime *startDateTime = [[GTLRCalendar_EventDateTime alloc] init];
    GTLRDateTime *startTime = [GTLRDateTime dateTimeWithDate:[dateformat dateFromString:self.startDate]];
    [startDateTime setDateTime:startTime];
    
    GTLRCalendar_EventDateTime *endDateTime = [[GTLRCalendar_EventDateTime alloc] init];
    GTLRDateTime *endTime = [GTLRDateTime dateTimeWithDate:[dateformat dateFromString:self.endDate]];
    [endDateTime setDateTime:endTime];
    
    [event setStart:startDateTime];
    [event setEnd:endDateTime];
    
    GTLRCalendarQuery_EventsInsert *query =
    [GTLRCalendarQuery_EventsInsert queryWithObject:event calendarId:@"primary"];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    //appDelegate.service = [[GTLRCalendarService alloc] init];
    
    [appDelegate.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];

}

- (void)datePickerValueChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
}

- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket
             finishedWithObject:(GTLRCalendar_Events *)events
                          error:(NSError *)error {
    
    if(error == nil){
        [self showAlert:@"Success" message:@"Saved"];
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
- (IBAction)date:(id)sender {
    NSString *eventDate = [NSDateFormatter localizedStringFromDate:[_date date]
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterNoStyle];
    
    NSString *startDate = [NSDateFormatter localizedStringFromDate:[_start date]
                                                         dateStyle:NSDateFormatterNoStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    
    NSString *endDate = [NSDateFormatter localizedStringFromDate:[_end date]
                                                         dateStyle:NSDateFormatterNoStyle
                                                         timeStyle:NSDateFormatterShortStyle];
 
    self.startDate = [NSString stringWithFormat:@"%@ %@", eventDate, startDate];
    self.endDate = [NSString stringWithFormat:@"%@ %@", eventDate, endDate];
}

- (IBAction)start:(id)sender {
    NSString *eventDate = [NSDateFormatter localizedStringFromDate:[_date date]
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterNoStyle];
    
    NSString *startDate = [NSDateFormatter localizedStringFromDate:[_start date]
                                                         dateStyle:NSDateFormatterNoStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    
    NSString *endDate = [NSDateFormatter localizedStringFromDate:[_end date]
                                                       dateStyle:NSDateFormatterNoStyle
                                                       timeStyle:NSDateFormatterShortStyle];
    
    self.startDate = [NSString stringWithFormat:@"%@ %@", eventDate, startDate];
    self.endDate = [NSString stringWithFormat:@"%@ %@", eventDate, endDate];
}

- (IBAction)end:(id)sender {
    NSString *eventDate = [NSDateFormatter localizedStringFromDate:[_date date]
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterNoStyle];
    
    NSString *startDate = [NSDateFormatter localizedStringFromDate:[_start date]
                                                         dateStyle:NSDateFormatterNoStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    
    NSString *endDate = [NSDateFormatter localizedStringFromDate:[_end date]
                                                       dateStyle:NSDateFormatterShortStyle
                                                       timeStyle:NSDateFormatterShortStyle];
    
    self.startDate = [NSString stringWithFormat:@"%@ %@", eventDate, startDate];
    self.endDate = [NSString stringWithFormat:@"%@ %@", eventDate, endDate];
}
@end
