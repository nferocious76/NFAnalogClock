//
//  NFAnalogClockView+Extension.m
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 12/1/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import "NFAnalogClockView+Extension.h"
#import "NFMathGeometry.h"

@implementation NFAnalogClockView (Extension)

- (void)startTime {
    
    if (self.timeScheduler) {
        [self.timeScheduler invalidate];
        self.timeScheduler = nil;
    }
    
    [self updateClock];
    self.timeScheduler = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateClock) userInfo:nil repeats:YES];
}

- (void)stopTime {
    
    if (self.timeScheduler) {
        [self.timeScheduler invalidate];
        self.timeScheduler = nil;
    }
}

- (void)updateClock {
    
    NSDate *dateNow = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:dateNow];
    
    [self setCurrentClockTimeWithHour:[components hour] minute:[components minute] second:[components second]];
    
    if (self.enableDateTimeLabel) {
        
        if ([self.dataSource respondsToSelector:@selector(dateFormatForClockView:)]) {
            self.dateFormatter.dateFormat = [self.dataSource dateFormatForClockView:self];
        }else{
            self.dateFormatter.dateFormat = NFAnalogClockDefaultDateFormat();
        }
        
        NSString *currentDateTime = [self.dateFormatter stringFromDate:dateNow];
        [self setDateTimeLabel:currentDateTime];
    }
}

- (NSString *)currentClockPeriod {
    
    NSDate *dateNow = [NSDate date];
    self.dateFormatter.dateFormat = @"a";
    NSString *clockPeriod = [self.dateFormatter stringFromDate:dateNow];
    
    return clockPeriod;
}

- (NSDate *)currentDateWithHour:(CGFloat)hour minute:(CGFloat)minute second:(CGFloat)second {
    
    NSDate *dateNow = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitTimeZone | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:dateNow];
    [components setHour:self.currentHour];
    [components setMinute:self.currentMinute];
    [components setSecond:self.currentSecond];

    NSDate *clockDate = [calendar dateFromComponents:components];
    
    return clockDate;
}

@end
