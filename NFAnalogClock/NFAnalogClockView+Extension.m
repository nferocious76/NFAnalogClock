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
    
    [self updateRealTimeClock];
    self.timeScheduler = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateClock) userInfo:nil repeats:YES];
}

- (void)stopTime {
    
    if (self.timeScheduler) {
        [self.timeScheduler invalidate];
        self.timeScheduler = nil;
    }
}

- (void)updateRealTimeClock {
    
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

- (NFTime *)updateClock {
    NFTime *time = [[NFTime alloc] initWithHour:self.currentHour minute:self.currentMinute second:self.currentSecond formatter:self.dateFormatter];

    if (self.enableDateTimeLabel) {
        NSDate *clockDate = [time currentDate];;
        
        if ([self.dataSource respondsToSelector:@selector(dateFormatForClockView:)]) {
            self.dateFormatter.dateFormat = [self.dataSource dateFormatForClockView:self];
        }else{
            self.dateFormatter.dateFormat = NFAnalogClockDefaultDateFormat();
        }
        
        NSString *clockDateTime = [self.dateFormatter stringFromDate:clockDate];
        [self setDateTimeLabel:clockDateTime];
    }

    return time;
}

@end
