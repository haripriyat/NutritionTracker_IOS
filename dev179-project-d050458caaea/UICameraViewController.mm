//
//  ViewController.m
//  TesseractSample
//
//  Created by Loïs Di Qual on 08/10/12.
//  Copyright (c) 2012 Loïs Di Qual. All rights reserved.
//

#import "UICameraViewController.h"
#import "Tesseract.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

@interface UICameraViewController ()

@end

@implementation UICameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _category = @[@"Calories(C)", @"Fat(g)", @"Carbohydrates(g)", @"Protein(g)"];
    
    _picker = [[UIPickerView alloc] init];
    _picker.delegate = self;
    _picker.dataSource = self;
    _categoryTextField.inputView = _picker;
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                      style:UIBarButtonItemStyleBordered target:self action:@selector(onCancel:)];
    [barButtonCancel setTintColor:[UIColor blueColor]];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleBordered target:self action:@selector(onDone:)];
    [barButtonDone setTintColor:[UIColor blueColor]];
    
    toolBar.items = @[barButtonCancel, flex, barButtonDone];
    _categoryTextField.inputAccessoryView = toolBar;

}

- (void) viewWillAppear:(BOOL)animated {
    _categoryTextField.enabled = YES;
    _amountTextField.enabled = YES;
}

-(void) onCancel:(id)sender {
    _categoryTextField.text = NULL;
    [_categoryTextField resignFirstResponder];
}

-(void)onDone:(id)sender
{
    [_categoryTextField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return false;
}
    
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        
    // Dismiss the image picker.
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //[self.imageView setImage:image];
    //_imageView.contentMode = UIViewContentModeScaleAspectFit;
        
    if (self.imagePickerController.sourceType==UIImagePickerControllerSourceTypeCamera) {
            
        //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:), nil);
    }
        
    self.imagePickerController = nil;
    
    Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    [tesseract setImage:image];
    [tesseract recognize];
    _nutritionText = [tesseract recognizedText];
    
    NSLog(@"%@", [tesseract recognizedText]);
    
    [self parse];
        
}

- (void) parse {
    NSArray *words = [_nutritionText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *value = NULL;
    NSUInteger i;
    BOOL caloriesDetected = false;
    BOOL fatDetected = false;
    BOOL carboDetected = false;
    BOOL proteinDetected = false;
    
    for (i = 0; i < [words count]; i++)
    {
        NSString *word = [words objectAtIndex:i];
        
        if ([word isEqualToString:@"Calories"] || [word isEqualToString:@"Carbohydrate"] || [word isEqualToString:@"Protein"]) {
            value = word;
        }
        
        else if ([word isEqualToString:@"Fat"]) {
            if ([[words objectAtIndex:i-1] isEqualToString:@"Total"]) {
                value = word;
            }
        }
        
        else if (value != NULL) {
            if ([value isEqualToString:@"Calories"] && [word intValue] != 0) {
                if (!caloriesDetected){
                    _calories = word;
                    caloriesDetected = YES;
                }
            }
            else if ([word characterAtIndex:([word length] - 1)] == 'g') {
               if ([value isEqualToString:@"Fat"]) {
                   if (!fatDetected){
                       _fat = [word substringToIndex:[word length] - 1];
                       fatDetected = YES;
                   }
                }
                else if ([value isEqualToString:@"Carbohydrate"]) {
                    if (!carboDetected) {
                        _carbohydrates = [word substringToIndex:[word length] - 1];
                        carboDetected = YES;
                    }
                }
                else if ([value isEqualToString:@"Protein"]) {
                    if (!proteinDetected) {
                         _protein = [word substringToIndex:[word length] - 1];
                        proteinDetected = YES;
                    }
                }
            }
            value = NULL;
        }
    }
    
    NSLog(@"calories: %@", _calories);
    NSLog(@"fat: %@", _fat);
    NSLog(@"carbohydrates: %@", _carbohydrates);
    NSLog(@"protein: %@", _protein);
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Adding Nutrition Intake"
                                                                              message: @"Verify nutrition values"
                                                                       preferredStyle:UIAlertControllerStyleAlert];

    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"calories";
        textField.text = [NSString stringWithFormat:@"%@%@", @"Total Calories: ", _calories];
        textField.textColor = [UIColor blueColor];
        //textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        //[textField disabledBackground];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"fat";
        textField.text = [NSString stringWithFormat:@"%@%@", @"Total Fat: ", _fat];
        textField.textColor = [UIColor blueColor];
        //textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        //textField.secureTextEntry = YES;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"carbohydrates";
        textField.text = [NSString stringWithFormat:@"%@%@", @"Total Carbohydrates: ", _carbohydrates];
        textField.textColor = [UIColor blueColor];
        //textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"proteins";
        textField.text = [NSString stringWithFormat:@"%@%@", @"Total Protein: ", _protein];
        textField.textColor = [UIColor blueColor];
        //textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self add];
        //NSArray * textfields = alertController.textFields;
        //UITextField * namefield = textfields[0];
        //UITextField * passwordfiled = textfields[1];
        //NSLog(@"%@:%@",namefield.text,passwordfiled.text);
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *cancelAction) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
    
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error {
    
    // Unable to save the image
    if (error) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Saving Photo to Gallery"
                                                                       message:[error localizedDescription]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
    
    
    
- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType fromButton:(UIButton *)button
{
        
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
        
    imagePickerController.modalPresentationStyle =
    (sourceType == UIImagePickerControllerSourceTypeCamera) ? UIModalPresentationFullScreen : UIModalPresentationPopover;
        
    UIPopoverPresentationController *presentationController = imagePickerController.popoverPresentationController;
    //presentationController.barButtonItem = button;
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
    _imagePickerController = imagePickerController;
        
    [self presentViewController:self.imagePickerController animated:YES completion:^{
        //.. done presenting
    }];
}
    
    
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        //.. done dismissing
    }];
    self.imagePickerController = nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _categoryTextField.text = _category[row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _category[row];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _category.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findPhoto:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary fromButton:sender];
}
    
- (IBAction)takePhoto:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera fromButton:sender];
    }
    else NSLog(@"carmera not available");
}

- (IBAction)addManual:(id)sender {
    if ([_categoryTextField.text isEqualToString:@"Calories(C)"]) {
        if (_amountTextField.text != NULL && [_amountTextField.text length] != 0) {
            _calories = _amountTextField.text;
            NSLog(@"calories text: %@", _calories);
        }
    } else if ([_categoryTextField.text isEqualToString:@"Fat(g)"]) {
        if (_amountTextField.text != NULL && [_amountTextField.text length] != 0) {
            _fat = _amountTextField.text;
            NSLog(@"fat text: %@", _fat);
        }
    }  else if ([_categoryTextField.text isEqualToString:@"Carbohydrates(g)"]) {
        if (_amountTextField.text != NULL && [_amountTextField.text length] != 0) {
            _carbohydrates = _amountTextField.text;
            NSLog(@"carbohydrates text : %@", _carbohydrates);
        }
    } else if ([_categoryTextField.text isEqualToString:@"Protein(g)"]) {
        if (_amountTextField.text != NULL && [_amountTextField.text length] != 0) {
            _protein = _amountTextField.text;
            NSLog(@"protein text: %@", _protein);
        }
    }
    [self add];

}

- (void) add {
    NSInteger calories = 0;
    NSInteger fat = 0;
    NSInteger carbo = 0;
    NSInteger protein = 0;
    
    _categoryTextField.text = NULL;
    _amountTextField.text = NULL;
    
    // Get Master view controller
    UITabBarController *tabBarController = (UITabBarController *)[[(AppDelegate*)
                                                                   [[UIApplication sharedApplication]delegate] window] rootViewController];
    UINavigationController *navigationController = (UINavigationController *)tabBarController.viewControllers[0];
    HomeViewController *home = (HomeViewController *)navigationController.topViewController;
    
    if (_calories != NULL) {
        calories = [_calories integerValue];
    }
    if (_fat != NULL) {
        fat = [_fat integerValue];
    }
    if (_carbohydrates != NULL) {
        carbo = [_carbohydrates integerValue];
    }
    if (_protein != NULL) {
        protein = [_protein integerValue];
    }
    
    NSLog(@"in add: cal:%i fat:%i carbo:%i protein:%i", calories, fat, carbo, protein);
    
    if ((_calories != NULL && home.caloriesGoal == 0) || (_fat != NULL && home.fatGoal == 0) || (_carbohydrates != NULL && home.carbohydratesGoal == 0) || (_protein != NULL && home.proteinGoal == 0)) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Nutritional Goals"
                                                                                  message: @"Please set your goals before adding nutrional intake value"
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *cancelAction) {
            _categoryTextField.enabled = NO;
            _amountTextField.enabled = NO;
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        _calories = NULL;
        _fat = NULL;
        _carbohydrates = NULL;
        _protein = NULL;
        _nutritionText = NULL;
        return;

    }
    
    [home insertNewObject:calories fat:fat carbohydrates:carbo protein:protein caloriesGoal:home.caloriesGoal fatGoal:home.fatGoal carbohydratesGoal:home.carbohydratesGoal proteinGoal:home.proteinGoal];
    [home updatePieProgressBars:calories fat:fat carbohydrates:carbo protein:protein];
    NSLog(@"%@", @"finished calling insert from camera controller");
    
    _calories = NULL;
    _fat = NULL;
    _carbohydrates = NULL;
    _protein = NULL;
    _nutritionText = NULL;
}

@end
