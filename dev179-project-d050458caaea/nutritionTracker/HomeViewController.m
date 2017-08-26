//
//  HomeViewController.m
//  TesseractSample
//
//  Created by Chelsea on 7/29/17.
//  Copyright © 2017 Loïs Di Qual. All rights reserved.
//

#import "HomeViewController.h"
#import "Food.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    /*_caloriesGoal = 0;
    _fatGoal = 0;
    _carbohydratesGoal = 0;
    _proteinGoal = 0;
    _caloriesSum = 0;
    _fatSum = 0;
    _carbohydratesSum = 0;
    _proteinSum = 0;*/
    [self loadPies];
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"HomeView Did Load : Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [self initData];
    [self loadPies];
}

- (void) loadPies {
    CGFloat originX = self.view.frame.origin.x;
    CGFloat originY = self.view.frame.origin.y;
    CGFloat halfWidth = self.view.frame.size.width / 2;
    CGFloat offset = 100;
    
    CGRect caloriesFrame = CGRectMake(originX, originY + offset, halfWidth, halfWidth);
    _caloriesProgress = [[PieProgressView alloc] initWithFrame:caloriesFrame];
    _caloriesProgress.percent = ((float)_caloriesSum / _caloriesGoal) * 100.0;
    if (isnan(_caloriesProgress.percent) || isinf(_caloriesProgress.percent)){
        _caloriesProgress.percent = 0.0;
    }
    _caloriesProgress.nutritionType = @"Total Calories";
    [self.view addSubview:_caloriesProgress];
    
    CGRect fatFrame = CGRectMake(halfWidth, originY + offset, halfWidth, halfWidth);
    _fatProgress = [[PieProgressView alloc] initWithFrame:fatFrame];
    _fatProgress.percent = ((float)_fatSum / _fatGoal) * 100.0;
    if (isnan(_fatProgress.percent) || isinf(_fatProgress.percent)){
        _fatProgress.percent = 0.0;
    }
    _fatProgress.nutritionType = @"Total Fat";
    [self.view addSubview:_fatProgress];
    
    CGRect carboFrame = CGRectMake(originX, halfWidth + offset, halfWidth, halfWidth);
    _carboProgress = [[PieProgressView alloc] initWithFrame:carboFrame];
    _carboProgress.percent = ((float)_carbohydratesSum / _carbohydratesGoal) * 100.0;
    if (isnan(_carboProgress.percent) || isinf(_carboProgress.percent)){
        _carboProgress.percent = 0.0;
    }
    _carboProgress.nutritionType = @"Total Carbohydrates";
    [self.view addSubview:_carboProgress];
    
    CGRect proteinFrame = CGRectMake(halfWidth, halfWidth + offset, halfWidth, halfWidth);
    _proteinProgress = [[PieProgressView alloc] initWithFrame:proteinFrame];
    _proteinProgress.percent = ((float)_proteinSum / _proteinGoal) * 100.0;
    if (isnan(_proteinProgress.percent) || isinf(_proteinProgress.percent)){
        _proteinProgress.percent = 0.0;
    }
    _proteinProgress.nutritionType = @"Total Protein";
    [self.view addSubview:_proteinProgress];
}

- (void) initData {
    NSError *error = nil;
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Food" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    fetchRequest.fetchLimit = 1;
    NSArray *goalsResult = [context executeFetchRequest:fetchRequest error:&error];
    if ([goalsResult count] == 0) {
        _caloriesGoal = 0;
        _fatGoal = 0;
        _carbohydratesGoal = 0;
        _proteinGoal = 0;

    }
    //_caloriesGoal = 0;
    //_fatGoal = 0;
    //_carbohydratesGoal = 0;
    //_proteinGoal = 0;
    else {
        _caloriesGoal = [[goalsResult[0] valueForKey:@"caloriesGoal"] integerValue];
        _fatGoal = [[goalsResult[0] valueForKey:@"fatGoal"] integerValue];
        _carbohydratesGoal = [[goalsResult[0] valueForKey:@"carbohydratesGoal"] integerValue];
        _proteinGoal = [[goalsResult[0] valueForKey:@"proteinGoal"] integerValue];
    }
    
    NSExpression *caloriesKeyPathExpression = [NSExpression expressionForKeyPath:@"calories"];
    NSExpression *caloriesExpression = [NSExpression expressionForFunction:@"sum:"
                                                            arguments:@[caloriesKeyPathExpression]];
    NSExpressionDescription *caloriesExpressionDescription = [[NSExpressionDescription alloc] init];
    [caloriesExpressionDescription setName:@"caloriesSum"];
    [caloriesExpressionDescription setExpression:caloriesExpression];
    [caloriesExpressionDescription setExpressionResultType:NSInteger32AttributeType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:caloriesExpressionDescription]];
    NSArray *caloriesResult = [context executeFetchRequest:fetchRequest error:&error];
    
    _caloriesSum = [[caloriesResult[0] valueForKey:@"caloriesSum"] integerValue];
    
    NSExpression *fatKeyPathExpression = [NSExpression expressionForKeyPath:@"fat"];
    NSExpression *fatExpression = [NSExpression expressionForFunction:@"sum:"
                                                            arguments:@[fatKeyPathExpression]];
    NSExpressionDescription *fatExpressionDescription = [[NSExpressionDescription alloc] init];
    [fatExpressionDescription setName:@"fatSum"];
    [fatExpressionDescription setExpression:fatExpression];
    [fatExpressionDescription setExpressionResultType:NSInteger32AttributeType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:fatExpressionDescription]];
    NSArray *fatResult = [context executeFetchRequest:fetchRequest error:&error];
    
    _fatSum = [[fatResult[0] valueForKey:@"fatSum"] integerValue];
    
    NSExpression *carboKeyPathExpression = [NSExpression expressionForKeyPath:@"carbohydrates"];
    NSExpression *carboExpression = [NSExpression expressionForFunction:@"sum:"
                                                            arguments:@[carboKeyPathExpression]];
    NSExpressionDescription *carboExpressionDescription = [[NSExpressionDescription alloc] init];
    [carboExpressionDescription setName:@"carboSum"];
    [carboExpressionDescription setExpression:carboExpression];
    [carboExpressionDescription setExpressionResultType:NSInteger32AttributeType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:carboExpressionDescription]];
    NSArray *carboResult = [context executeFetchRequest:fetchRequest error:&error];
    
    _carbohydratesSum = [[carboResult[0] valueForKey:@"carboSum"] integerValue];
    
    NSExpression *proteinKeyPathExpression = [NSExpression expressionForKeyPath:@"protein"];
    NSExpression *proteinExpression = [NSExpression expressionForFunction:@"sum:"
                                                            arguments:@[proteinKeyPathExpression]];
    NSExpressionDescription *proteinExpressionDescription = [[NSExpressionDescription alloc] init];
    [proteinExpressionDescription setName:@"proteinSum"];
    [proteinExpressionDescription setExpression:proteinExpression];
    [proteinExpressionDescription setExpressionResultType:NSInteger32AttributeType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:proteinExpressionDescription]];
    NSArray *proteinResult = [context executeFetchRequest:fetchRequest error:&error];
    
    _proteinSum = [[proteinResult[0] valueForKey:@"proteinSum"] integerValue];
    
    NSLog(@"init: cal: %i, fat: %i, carbo: %i, protein: %i", _caloriesSum,_fatSum, _carbohydratesSum, _proteinSum);
    
    if (_caloriesGoal == 0 && _fatGoal == 0 && _carbohydratesGoal == 0 && _proteinGoal == 0) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Nutritional Goals"
                                                                                  message: @"No goals set yet!"
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *cancelAction) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
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

- (IBAction)editGoal:(id)sender {
}

- (void)insertNewObject:(NSInteger)cal fat:(NSInteger)f carbohydrates:(NSInteger)carbo protein:(NSInteger)p caloriesGoal:(NSInteger)caloriesGoal fatGoal:(NSInteger)fatGoal carbohydratesGoal:(NSInteger)carboGoal proteinGoal:(NSInteger)proteinGoal{
    //NSLog(@"Reading from Add Call %i %i %i %i", cal, f, carbo, p);
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    [newManagedObject setValue:[NSDate date] forKey:@"time"];
    [newManagedObject setValue:[NSNumber numberWithInteger:cal] forKey:@"calories"];
    [newManagedObject setValue:[NSNumber numberWithInteger:f] forKey:@"fat"];
    [newManagedObject setValue:[NSNumber numberWithInteger:carbo] forKey:@"carbohydrates"];
    [newManagedObject setValue:[NSNumber numberWithInteger:p] forKey:@"protein"];
    [newManagedObject setValue:[NSNumber numberWithInteger:caloriesGoal] forKey:@"caloriesGoal"];
    [newManagedObject setValue:[NSNumber numberWithInteger:fatGoal] forKey:@"fatGoal"];
    [newManagedObject setValue:[NSNumber numberWithInteger:carboGoal] forKey:@"carbohydratesGoal"];
    [newManagedObject setValue:[NSNumber numberWithInteger:proteinGoal] forKey:@"proteinGoal"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Save nutrients: Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}

#pragma mark - Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Food" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void) updatePieProgressBars:(NSInteger)newCalories fat:(NSInteger)newFat carbohydrates:(NSInteger)newCarbo protein:(NSInteger)newProtein  {
    
    NSLog(@"In update (old): calPercent: %.1f, fatPercent:%.1f, carboPercent:%.1f, proteinPercent:%.1f", _caloriesProgress.percent, _fatProgress.percent, _carboProgress.percent, _proteinProgress.percent);
    
    _caloriesSum = _caloriesSum + newCalories;
    _fatSum = _fatSum + newFat;
    _carbohydratesSum = _carbohydratesSum + newCarbo;
    _proteinSum = _proteinSum + newProtein;
    
    _caloriesProgress.percent = (float)_caloriesSum / (float)_caloriesGoal;
    _fatProgress.percent = (float)_fatSum / (float)_fatGoal;
    _carboProgress.percent = (float)_carbohydratesSum / (float)_carbohydratesGoal;
    _proteinProgress.percent = (float)_proteinSum / (float)_proteinGoal;
    
    NSLog(@"In update (new): calPercent: %.1f, fatPercent:%.1f, carboPercent:%.1f, proteinPercent:%.1f", _caloriesProgress.percent, _fatProgress.percent, _carboProgress.percent, _proteinProgress.percent);

}

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller{
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type  newIndexPath:(NSIndexPath *)newIndexPath{
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller{
}


@end
