//
//  NFAnalogClockTimeManager.m
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 11/26/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import "NFAnalogClockTimeManager.h"

@interface NFAnalogClockTimeManager()

@property (nonatomic, strong) NFAnalogClockView *clockView;

@property (nonatomic, strong) NSTimer *timeScheduler;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation NFAnalogClockTimeManager

- (instancetype)initWithAnalogClockView:(NFAnalogClockView *)clockView {
    
    if (self = [super init]) {
        self.clockView = clockView;
        self.dateFormatter = [[NSDateFormatter alloc] init];
        
        [self startTime];
    }
    
    return self;
}

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
    
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
    
    [self.clockView setCurrentClockTimeWithHour:[components hour] minute:[components minute] second:[components second]];
}

@end
