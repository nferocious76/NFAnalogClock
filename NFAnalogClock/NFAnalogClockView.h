//
//  NFAnalogClockView.h
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 11/26/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFAnalogClockView : UIView

// hour
@property (nonatomic, strong) UIColor *hourDialColor;
@property (nonatomic, strong) UIColor *hourHandColor;

@property (nonatomic) CGFloat hourDialWidth;
@property (nonatomic) CGFloat hourDialLength;


// minutes
@property (nonatomic, strong) UIColor *minDialColor;
@property (nonatomic, strong) UIColor *minHandColor;

@property (nonatomic) CGFloat minDialWidth;
@property (nonatomic) CGFloat minDialLength;


// seconds
@property (nonatomic, strong) UIColor *secDialColor;
@property (nonatomic, strong) UIColor *secHandColor;

@property (nonatomic) CGFloat secDialWidth;
@property (nonatomic) CGFloat secDialLength;


// clock's radius
@property (nonatomic) CGFloat radius;


@end
