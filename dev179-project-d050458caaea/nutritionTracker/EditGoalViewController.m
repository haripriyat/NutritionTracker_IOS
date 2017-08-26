//
//  EditGoalViewController.m
//  TesseractSample
//
//  Created by Chelsea on 7/31/17.
//  Copyright © 2017 Loïs Di Qual. All rights reserved.
//

#import "EditGoalViewController.h"
#import "HomeViewController.h"

@interface EditGoalViewController ()

@end

@implementation EditGoalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"%i, %i, %i, %i", home.calories)
    
    HomeViewController *home = (HomeViewController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    NSLog(@"%i, %i, %i, %i", home.caloriesGoal, home.fatGoal, home.carbohydratesGoal, home.proteinGoal);
    
    if (home.caloriesGoal == 0) {
        _caloriesTextField.text = @"add";
        //_caloriesTextField.textColor = [UIColor redColor];
        //NSLog(@"%@", @"yes");
    } else {
        _caloriesTextField.text = [NSString stringWithFormat:@"%i", home.caloriesGoal];
    }
    _caloriesTextField.textColor = [UIColor grayColor];
    _caloriesTextField.enabled = NO;
    
    if (home.fatGoal == 0) {
        _fatTextField.text = @"add";
    } else {
        _fatTextField.text = [NSString stringWithFormat:@"%i", home.fatGoal];
    }
    _fatTextField.textColor = [UIColor grayColor];
    _fatTextField.enabled = NO;
    
    if (home.carbohydratesGoal == 0) {
        _carbohydratesTextField.text = @"add";
    } else {
        _carbohydratesTextField.text = [NSString stringWithFormat:@"%i", home.carbohydratesGoal];
    }
    _carbohydratesTextField.textColor = [UIColor grayColor];
    _carbohydratesTextField.enabled = NO;
    
    if (home.proteinGoal == 0) {
        _proteinTextField.text = @"add";
    } else {
        _proteinTextField.text = [NSString stringWithFormat:@"%i", home.proteinGoal];
    }
    _proteinTextField.textColor = [UIColor grayColor];
    _proteinTextField.enabled = NO;
    
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

- (void) editing {
    if ([_caloriesTextField.text isEqualToString:@"add"]) {
        _caloriesTextField.text = NULL;
    }
    if ([_fatTextField.text isEqualToString:@"add"]) {
        _fatTextField.text = NULL;
    }
    if ([_carbohydratesTextField.text isEqualToString:@"add"]) {
        _carbohydratesTextField.text = NULL;
    }
    if ([_proteinTextField.text isEqualToString:@"add"]) {
        _proteinTextField.text = NULL;
    }
    _caloriesTextField.enabled = YES;
    _caloriesTextField.textColor = [UIColor blueColor];
    _fatTextField.enabled = YES;
    _fatTextField.textColor = [UIColor blueColor];
    _carbohydratesTextField.enabled = YES;
    _carbohydratesTextField.textColor = [UIColor blueColor];
    _proteinTextField.enabled = YES;
    _proteinTextField.textColor = [UIColor blueColor];
    
}

- (IBAction)edit:(id)sender {
    NSLog(@"%@", _button.title);
    if ([_button.title isEqualToString:@"Edit"]) {
        [self editing];
        _button.title = @"Done";
    }
    
    else {
        [self done];
        _button.title = @"Edit";
    }
}

- (void) done {
    _caloriesTextField.enabled = NO;
    _caloriesTextField.textColor = [UIColor grayColor];
    _fatTextField.enabled = NO;
    _fatTextField.textColor = [UIColor grayColor];
    _carbohydratesTextField.enabled = NO;
    _carbohydratesTextField.textColor = [UIColor grayColor];
    _proteinTextField.enabled = NO;
    _proteinTextField.textColor = [UIColor grayColor];
    
    NSInteger calories = [_caloriesTextField.text integerValue];
    NSInteger fat = [_fatTextField.text integerValue];
    NSInteger carbo = [_carbohydratesTextField.text integerValue];
    NSInteger protein = [_proteinTextField.text integerValue];
    
    HomeViewController *home = (HomeViewController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    if (calories == home.caloriesGoal && fat == home.fatGoal && carbo == home.carbohydratesGoal && protein == home.proteinGoal) {
        return;
    }
    
    [home insertNewObject:0 fat:0 carbohydrates:0 protein:0 caloriesGoal:calories fatGoal:fat carbohydratesGoal:carbo proteinGoal:protein];
    //[home viewDidAppear:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}
@end
