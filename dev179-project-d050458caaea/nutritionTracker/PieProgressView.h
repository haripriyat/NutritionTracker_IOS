//
//  PieProgressView.h
//  TesseractSample
//
//  Created by Chelsea on 7/29/17.
//  Copyright © 2017 Loïs Di Qual. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieProgressView : UIView

@property CGFloat startAngle;
@property CGFloat endAngle;
@property (nonatomic) double percent;
@property NSString *nutritionType;
@property UIColor *color;

@end
