//
//  NFTime.m
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 12/30/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import "NFTime.h"

@interface NFTime()

@property (nonatomic, weak, readonly) NSDateFormatter *dateFormatter;

@end

@implementation NFTime

- (instancetype)init {
    
    NSString *reason = [NSString stringWithFormat:@"-init is not a valid initializer for the class %@", NSStringFromClass([NFTime class])];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
    return nil;
}

- (instancetype)initWithHour:(CGFloat)hour minute:(CGFloat)minute second:(CGFloat)second period:(NSString *)period formatter:(NSDateFormatter *)formatter {
    
    if (self = [super init]) {
        _hour = hour;
        _minute = minute;
        _second = second;
        _period = period;
        
        _dateFormatter = formatter;
    }
    
    return self;
}

- (NSString *)timeToString {
    
    CGFloat hour = self.hour == 0 ? 12 : self.hour;
    NSString *hourString = hour > 9 ? @"%.0f:" : @"0%.0f:";
    NSString *minuteString = self.minute > 9 ? @"%.0f:" : @"0%.0f:";
    NSString *secondString = self.second > 9 ? @"%.0f" : @"0%.0f";
    NSString *clockPeriod = [NSString stringWithFormat:@" %@", [self currentClockPeriod]];
    NSString *timeStringFormat = [[[hourString stringByAppendingString:minuteString] stringByAppendingString:secondString] stringByAppendingString:clockPeriod];
    
    NSString *timeString = [NSString stringWithFormat:timeStringFormat, hour, self.minute, self.second];

    return timeString;
}

- (NSString *)currentClockPeriod {
    
    NSDate *dateNow = [NSDate date];
    self.dateFormatter.dateFormat = @"a";
    NSString *clockPeriod = [self.dateFormatter stringFromDate:dateNow];
    
    return clockPeriod;
}

- (NSDate *)currentDate {
    NSDate *dateNow = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitTimeZone) fromDate:dateNow]; //  | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
    
    CGFloat h = [self.period isEqualToString:@"PM"] ? self.hour + 12 : self.hour;
    [components setHour:h];
    [components setMinute:self.minute];
    [components setSecond:self.second];
    
    NSDate *clockDate = [calendar dateFromComponents:components];
    
    return clockDate;
}

@end
