//
//  PieProgressView.m
//  TesseractSample
//
//  Created by Chelsea on 7/29/17.
//  Copyright © 2017 Loïs Di Qual. All rights reserved.
//

#import "PieProgressView.h"

@implementation PieProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        // Determine our start and stop angles for the arc (in radians)
        _startAngle = M_PI * 1.5;
        _endAngle = _startAngle + (M_PI * 2);
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Display our percentage as a string
    NSString* textContent = [NSString stringWithFormat:@"%.1f%%", self.percent];
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    // Create our arc, with the correct angles
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:40
                      startAngle:_startAngle
                        endAngle:(_endAngle - _startAngle) * fmod(_percent / 100.0, 1.0) + _startAngle
                       clockwise:YES];
    
    // Set the display for the path, and stroke it
    bezierPath.lineWidth = 15;
    if (_percent < 35.0) {
        _color = [UIColor redColor];
    } else if (_percent < 80.0) {
        _color = [UIColor yellowColor];
    } else if (_percent < 100.0){
        _color = [UIColor greenColor];
    } else {
        _color = [UIColor colorWithRed: 0.4784 green: 0 blue: 0.1255 alpha: 1.0];
    }
    [_color setStroke];
    [bezierPath stroke];
    
    // Text Drawing
    CGRect textRect = CGRectMake((rect.size.width / 2.0) - 50/2.0, (rect.size.height / 2.0) - 10/2.0, 50, 10);
    [[UIColor blackColor] setFill];
    [textContent drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 10] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
    
    CGRect text2 = CGRectMake((rect.size.width / 2.0) - 50, 10, 100, 10);
    [[UIColor blackColor] setFill];
    [_nutritionType drawInRect: text2 withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 10] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
}


@end
