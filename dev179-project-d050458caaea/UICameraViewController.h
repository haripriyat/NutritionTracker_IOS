//
//  ViewController.h
//  TesseractSample
//
//  Created by Loïs Di Qual on 08/10/12.
//  Copyright (c) 2012 Loïs Di Qual. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICameraViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
    
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) UIPickerView *picker;

@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property NSString *nutritionText;
@property NSString *calories;
@property NSString *fat;
@property NSString *carbohydrates;
@property NSString *protein;
@property NSArray *category;
//- (IBAction)findPhoto:(id)sender;
//- (IBAction)takePhoto:(id)sender;
//- (IBAction)addManual:(id)sender;
- (IBAction)findPhoto:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)addManual:(id)sender;

@end
