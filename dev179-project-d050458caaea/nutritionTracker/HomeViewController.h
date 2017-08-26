//
//  HomeViewController.h
//  TesseractSample
//
//  Created by Chelsea on 7/29/17.
//  Copyright © 2017 Loïs Di Qual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PieProgressView.h"

@interface HomeViewController : UIViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController*fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext*managedObjectContext;
@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

@property PieProgressView *caloriesProgress;
@property PieProgressView *fatProgress;
@property PieProgressView *carboProgress;
@property PieProgressView *proteinProgress;

@property NSInteger caloriesGoal;
@property NSInteger fatGoal;
@property NSInteger carbohydratesGoal;
@property NSInteger proteinGoal;

@property NSInteger caloriesSum;
@property NSInteger fatSum;
@property NSInteger carbohydratesSum;
@property NSInteger proteinSum;

- (void)insertNewObject:(NSInteger)calories fat:(NSInteger)f carbohydrates:(NSInteger)carbo protein:(NSInteger)p caloriesGoal:(NSInteger)caloriesGoal fatGoal:(NSInteger)fatGoal carbohydratesGoal:(NSInteger)carboGoal proteinGoal:(NSInteger)proteinGoal;
- (void)updatePieProgressBars:(NSInteger)calories fat:(NSInteger)f carbohydrates:(NSInteger)carbo protein:(NSInteger)p;

@end
