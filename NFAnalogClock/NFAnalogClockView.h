//
//  NFAnalogClockView.h
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 11/26/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFAnalogClockView : UIView

#pragma mark - Clock Design

// hour
@property (nonatomic, strong) UIColor *hourDialColor;
@property (nonatomic, strong) UIColor *hourHandColor;

@property (nonatomic) CGFloat hourDialWidth;
@property (nonatomic) CGFloat hourDialLength;
@property (nonatomic) CGFloat hourHandLength;
@property (nonatomic) CGFloat hourHandWidth;

// minutes
@property (nonatomic, strong) UIColor *minDialColor;
@property (nonatomic, strong) UIColor *minHandColor;

@property (nonatomic) CGFloat minDialWidth;
@property (nonatomic) CGFloat minDialLength;
@property (nonatomic) CGFloat minHandLength;
@property (nonatomic) CGFloat minHandWidth;

// seconds
@property (nonatomic, strong) UIColor *secDialColor;
@property (nonatomic, strong) UIColor *secHandColor;

@property (nonatomic) CGFloat secDialWidth;
@property (nonatomic) CGFloat secDialLength;
@property (nonatomic) CGFloat secHandLength;
@property (nonatomic) CGFloat secHandWidth;

#pragma mark - Clock Face

// clock's radius
@property (nonatomic) CGFloat radius;

@property (nonatomic) BOOL enableMinDial;
@property (nonatomic) BOOL enableSecDial;
@property (nonatomic) BOOL enableClockLabel;

@property (nonatomic, strong) UIFont *hourLabelFont;
@property (nonatomic, strong) UIColor *hourLabelColor;

@end
