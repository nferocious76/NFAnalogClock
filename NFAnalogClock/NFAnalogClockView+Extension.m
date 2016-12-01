//
//  NFAnalogClockView+Extension.m
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 12/1/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import "NFAnalogClockView+Extension.h"

@implementation NFAnalogClockView (Extension)

- (void)startTime {
    
    if (self.timeScheduler) {
        [self.timeScheduler invalidate];
        self.timeScheduler = nil;
    }
    
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
    NSString *currentDateTime = [self.dateFormatter stringFromDate:dateNow];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:dateNow];
    
    [self setCurrentClockTimeWithHour:[components hour] minute:[components minute] second:[components second]];
    [self setDateTimeLabel:currentDateTime];
}

@end
