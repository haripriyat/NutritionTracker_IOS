//
//  ReminderTableViewController.m
//  nutritionTracker
//
//  Created by Htiruvee on 7/29/17.
//  Copyright © 2017 CarnegieMellonUniversity. All rights reserved.
//

#import "ReminderTableViewController.h"

@interface ReminderTableViewController ()

@end

@implementation ReminderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Configure Google Sign-in.
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    //[GIDSignIn sharedInstance].scopes = [NSArray arrayWithObjects:kGTLRAuthScopeCalendar, nil];
    NSString *driveScope = @"https://www.googleapis.com/auth/calendar";
    NSArray *currentScopes = [GIDSignIn sharedInstance].scopes;
    [GIDSignIn sharedInstance].scopes = [currentScopes arrayByAddingObject:driveScope];
    
    // Uncomment to automatically sign in the user.
    [[GIDSignIn sharedInstance] signInSilently];
    
    // Add the sign-in button.
    self.signInButton = [[GIDSignInButton alloc] init];
    [self.view addSubview:self.signInButton];
    
    // Initialize the service object.
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.service = [[GTLRCalendarService alloc] init];
}

- (void) viewDidAppear:(BOOL)animated{
    [self fetchEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.eventList.items.count;
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        appDelegate.service.authorizer = nil;
    } else {
        self.signInButton.hidden = true;
        self.output.hidden = false;
        appDelegate.service.authorizer = user.authentication.fetcherAuthorizer;
        [self fetchEvents];
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
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

// Construct a query and get a list of upcoming events from the user calendar. Display the
// start dates and event summaries in the UITextView.
- (void)fetchEvents {
    GTLRCalendarQuery_EventsList *query =
    [GTLRCalendarQuery_EventsList queryWithCalendarId:@"primary"];
    //query.maxResults = 10;
    query.timeMin = [GTLRDateTime dateTimeWithDate:[NSDate date]];
    query.singleEvents = YES;
    query.orderBy = kGTLRCalendarOrderByStartTime;
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    //appDelegate.service = [[GTLRCalendarService alloc] init];
    
    [appDelegate.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}

- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket
             finishedWithObject:(GTLRCalendar_Events *)events
                          error:(NSError *)error {
    if (error == nil) {
        //NSMutableString *output = [[NSMutableString alloc] init];
        if (events.items.count > 0) {
            self.eventList = events;
            [self.tableView reloadData];
        } else {
            //[output appendString:@"No upcoming events found."];
        }
        //self.output.text = output;
    } else {
        [self showAlert:@"Error" message:error.localizedDescription];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    
    // Configure the cell...
    GTLRCalendar_Event *event = [self.eventList.items objectAtIndex:indexPath.row];
    cell.textLabel.text = event.summary;
    GTLRDateTime *start = event.start.dateTime ?: event.start.date;
    GTLRDateTime *end = event.end.dateTime ?: event.end.date;
    NSString *startDate = [NSDateFormatter localizedStringFromDate:[start date]
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    NSString *endDate = [NSDateFormatter localizedStringFromDate:[end date]
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterShortStyle];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"detail"]) {
        self.deleteViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        GTLRCalendar_Event *event = [self.eventList.items objectAtIndex:indexPath.row];
        GTLRDateTime *start = event.start.dateTime ?: event.start.date;
        GTLRDateTime *end = event.end.dateTime ?: event.end.date;
        NSString *startDate = [NSDateFormatter localizedStringFromDate:[start date]
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterNoStyle];
        NSString *endDate = [NSDateFormatter localizedStringFromDate:[end date]
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterNoStyle];
        NSString *startTime = [NSDateFormatter localizedStringFromDate:[end date]
                                                           dateStyle:NSDateFormatterNoStyle
                                                           timeStyle:NSDateFormatterShortStyle];
        
        NSString *endTime = [NSDateFormatter localizedStringFromDate:[end date]
                                                             dateStyle:NSDateFormatterNoStyle
                                                             timeStyle:NSDateFormatterShortStyle];
        
        self.deleteViewController.event = event.summary;
        self.deleteViewController.date= [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
        self.deleteViewController.start = startTime;
        self.deleteViewController.end = endTime;
        self.deleteViewController.description = event.descriptionProperty;
        self.deleteViewController.eventId = event.JSON[@"id"];
    }
}

@end
