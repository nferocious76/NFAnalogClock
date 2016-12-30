//
//  NFTime.h
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 12/30/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NFTime : NSObject

- (instancetype)initWithHour:(CGFloat)hour minute:(CGFloat)minute second:(CGFloat)second formatter:(NSDateFormatter *)formatter;

@property (nonatomic, readonly) CGFloat hour;
@property (nonatomic, readonly) CGFloat minute;
@property (nonatomic, readonly) CGFloat second;

@property (nonatomic, strong, readonly) NSString *period;

- (NSString *)timeToString;
- (NSString *)currentClockPeriod;

@end
