//
//  Food.h
//  TesseractSample
//
//  Created by Htiruvee on 7/30/17.
//  Copyright © 2017 Loïs Di Qual. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Food : NSManagedObject
@property (nonatomic) NSInteger calories;
@property (nonatomic) NSInteger fat;
@property (nonatomic) NSInteger carbohydrates;
@property (nonatomic) NSInteger protein;
@property (nonatomic) NSInteger caloriesGoal;
@property (nonatomic) NSInteger fatGoal;
@property (nonatomic) NSInteger carbohydratesGoal;
@property (nonatomic) NSInteger proteinGoal;
@property (nonatomic, retain) NSDate *time;

@end

NS_ASSUME_NONNULL_END
