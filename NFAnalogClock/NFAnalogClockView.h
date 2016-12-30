//
//  NFAnalogClockView.h
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 11/26/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFTime.h"

@class NFAnalogClockView;

@protocol NFAnalogClockViewDataSource <NSObject>

@required
- (NSString *)dateFormatForClockView:(NFAnalogClockView *)clockView;

@end

@protocol NFAnalogClockViewDelegate <NSObject>

/**
 * Time format: 'HH:mm:ss'
 */
- (void)clockView:(NFAnalogClockView *)clockView didUpdateTime:(NFTime *)time;

@end

@interface NFAnalogClockView : UIControl

#pragma mark - Clock Design

// hour
@property (nonatomic, strong) UIColor *hourDialColor;
@property (nonatomic, strong) UIColor *hourHandColor;

@property (nonatomic) CGFloat hourDialWidth;
@property (nonatomic) CGFloat hourDialLength;
@property (nonatomic) CGFloat hourHandWidth;

// minutes
@property (nonatomic, strong) UIColor *minDialColor;
@property (nonatomic, strong) UIColor *minHandColor;

@property (nonatomic) CGFloat minDialWidth;
@property (nonatomic) CGFloat minDialLength;
@property (nonatomic) CGFloat minHandWidth;

// seconds
@property (nonatomic, strong) UIColor *secDialColor;
@property (nonatomic, strong) UIColor *secHandColor;

@property (nonatomic) CGFloat secDialWidth;
@property (nonatomic) CGFloat secDialLength;
@property (nonatomic) CGFloat secHandWidth;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSTimer *timeScheduler;

@property (nonatomic, strong) NSDate *clockDate;

#pragma mark - Clock Face

// clock's radius

@property (nonatomic) BOOL enableMinDial;
@property (nonatomic) BOOL enableSecDial;
@property (nonatomic) BOOL enableClockLabel;
@property (nonatomic) BOOL enableDateTimeLabel;

@property (nonatomic, strong) UIFont *hourLabelFont;
@property (nonatomic, strong) UIColor *hourLabelColor;

@property (nonatomic, strong) UIFont *dateTimeLabelFont;
@property (nonatomic, strong) UIColor *dateTimeLabelColor;

@property (nonatomic, strong) UIColor *clockFaceColor;

@property (nonatomic) CGFloat currentHour;
@property (nonatomic) CGFloat currentMinute;
@property (nonatomic) CGFloat currentSecond;

@property (nonatomic, strong) NSString *dateTimeLabel;

@property (nonatomic, weak) id <NFAnalogClockViewDelegate>delegate;
@property (nonatomic, weak) id <NFAnalogClockViewDataSource>dataSource;


#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id <NFAnalogClockViewDelegate>)delegate
                   dataSource:(id <NFAnalogClockViewDataSource>)dataSource;

#pragma mark - Controls

- (void)setCurrentClockTimeWithHour:(CGFloat)hour minute:(CGFloat)minute second:(CGFloat)second;
- (void)refreshClockView;

@end
