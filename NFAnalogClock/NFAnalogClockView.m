//
//  NFAnalogClockView.m
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 11/26/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import "NFAnalogClockView.h"
#import "MathGeometry.h"

@implementation NFAnalogClockView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self loadDefaultData];
}

- (void)loadDefaultData {
    
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];

    // default radius
    self.radius = self.frame.size.height > self.frame.size.width ? self.frame.size.width / 2 : self.frame.size.height / 2;

    // hour
    self.hourDialColor = [UIColor lightGrayColor];
    self.hourHandColor = [UIColor grayColor];
    
    self.hourDialWidth = 2;
    self.hourDialLength = 10;
    self.hourHandLength = self.radius * 0.7;
    self.hourHandWidth = 3;
    
    // minutes
    self.minDialColor = [[UIColor greenColor] colorWithAlphaComponent:0.8];
    self.minHandColor = [UIColor greenColor];
    
    self.minDialWidth = 1.5;
    self.minDialLength = 5;
    self.minHandLength = self.radius * 0.9;
    self.minHandWidth = 2;

    // seconds
    self.secDialColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
    self.secHandColor = [UIColor blueColor];
    
    self.secDialWidth = 1;
    self.secDialLength = 2.5;
    self.secHandLength = self.radius * 0.9;
    self.secHandWidth = 1;

    self.enableMinDial = YES;
    self.enableSecDial = YES;
    self.enableClockLabel = YES;
    
    self.hourLabelFont = [UIFont systemFontOfSize:12];
    self.hourLabelColor = [UIColor blackColor];
}

#pragma mark - Drawing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAlpha(context, self.alpha);
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    
    // canvas center
    CGPoint canvasCenterPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    // draw hour dial pins
    [self drawHourDialAtCenterPoint:canvasCenterPoint];
    
    if (self.enableMinDial) {
        [self drawMinuteDialAtCenterPoint:canvasCenterPoint];
    }
    
    if (self.enableSecDial) {
        [self drawSecondDialAtCenterPoint:canvasCenterPoint];
    }
    
    if (self.enableClockLabel) {
        [self drawHourLabelAtCenterPoint:canvasCenterPoint];
    }
    
    // clock's hand
    [self drawClockHourHand:3];
    [self drawClockMinHand:19];
    [self drawClockSecHand:46];
}

#pragma mark - Setters

- (void)setEnableMinDial:(BOOL)enableMinDial {
    _enableMinDial = enableMinDial;
    
    [self setNeedsDisplay];
}

- (void)setEnableSecDial:(BOOL)enableSecDial {
    _enableSecDial = enableSecDial;
    
    [self setNeedsDisplay];
}

#pragma mark - Utils

/** Clock Dials */

- (void)drawHourDialAtCenterPoint:(CGPoint)center {
    
    CGFloat angleCorrection = ToRadians(30 * 3); // angle correction start at angle 270°, default at 0°
    for (int i = 0; i < 12; i++) {
        
        CGFloat angle = ToRadians(30 * i) - angleCorrection;
        CGPoint startPoint = PolarToDecart(center, self.radius - self.hourDialLength, angle);
        CGPoint endPoint = PolarToDecart(center, self.radius, angle);
        
        [self.hourDialColor setFill];
        [self.hourDialColor setStroke];
        
        [self drawPinAtStartPoint:startPoint endPoint:endPoint width:self.hourDialWidth capStype:kCGLineCapSquare];
    }
}

- (void)drawMinuteDialAtCenterPoint:(CGPoint)center {
    
    CGFloat angleCorrection = ToRadians(30 * 3); // angle correction start at angle 270°, default at 0°
    for (int i = 0; i < 60; i++) {
        if (i % 5 == 0) { continue; }
        
        CGFloat angle = ToRadians(6 * i) - angleCorrection;
        CGPoint startPoint = PolarToDecart(center, self.radius - self.minDialLength, angle);
        CGPoint endPoint = PolarToDecart(center, self.radius, angle);
        
        [self.minDialColor setFill];
        [self.minDialColor setStroke];
        
        [self drawPinAtStartPoint:startPoint endPoint:endPoint width:self.minDialWidth capStype:kCGLineCapButt];
    }
}

- (void)drawSecondDialAtCenterPoint:(CGPoint)center {
    
    CGFloat angleCorrection = ToRadians(30 * 3); // angle correction start at angle 270°, default at 0°
    for (int i = 0; i < 360; i++) {
        if (i % 6 == 0) { continue; }

        CGFloat angle = ToRadians(1 * i) - angleCorrection;
        CGPoint startPoint = PolarToDecart(center, self.radius - self.secDialLength, angle);
        CGPoint endPoint = PolarToDecart(center, self.radius, angle);
        
        [self.secDialColor setFill];
        [self.secDialColor setStroke];
        
        [self drawPinAtStartPoint:startPoint endPoint:endPoint width:self.secDialWidth capStype:kCGLineCapRound];
    }
}

- (void)drawPinAtStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint width:(CGFloat)width capStype:(CGLineCap)capStype {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:width];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    
    [path setLineCapStyle:capStype];
    [path fill];
    [path stroke];
}

/** Clock Label */

- (void)drawHourLabelAtCenterPoint:(CGPoint)center {
    
    CGFloat angleCorrection = ToRadians(30 * 3); // angle correction start at angle 270°, default at 0°
    for (int i = 1; i <= 12; i++) {
        
        CGFloat angle = ToRadians(30 * i) - angleCorrection;
        CGFloat radiusPoint = self.radius - self.hourDialLength - 10;
        CGPoint startPoint = PolarToDecart(center, radiusPoint, angle);
        
        NSString *hourLabel = [NSString stringWithFormat:@"%d", i];
        NSDictionary *fontAttribute = @{NSFontAttributeName: self.hourLabelFont, NSForegroundColorAttributeName: self.hourLabelColor};
        CGSize hourLabelSize = [hourLabel sizeWithAttributes:fontAttribute];
        
        CGFloat originX = startPoint.x - (hourLabelSize.width / 2);
        CGFloat originY = startPoint.y - (hourLabelSize.height / 2);
        CGRect hourLabelRect = CGRectMake(originX, originY, hourLabelSize.width, hourLabelSize.height);
        
        [hourLabel drawInRect:hourLabelRect withAttributes:fontAttribute];
    }
}

/** Clock Hands */

- (void)drawClockHourHand:(CGFloat)hour {
    
    // canvas center
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);

    CGFloat angleCorrection = ToRadians(30 * 3); // angle correction start at angle 270°, default at 0°
    CGFloat angle = ToRadians(30 * hour) - angleCorrection;
    CGPoint startPoint = PolarToDecart(center, -(self.hourHandLength * 0.15), angle);
    CGPoint endPoint = PolarToDecart(center, self.hourHandLength, angle);

    [self.hourHandColor setFill];
    [self.hourHandColor setStroke];

    [self drawPinAtStartPoint:startPoint endPoint:endPoint width:self.hourHandWidth capStype:kCGLineCapRound];
}

- (void)drawClockMinHand:(CGFloat)min {
    
    // canvas center
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    CGFloat angleCorrection = ToRadians(30 * 3); // angle correction start at angle 270°, default at 0°
    CGFloat angle = ToRadians(6 * min) - angleCorrection;
    CGPoint startPoint = PolarToDecart(center, -(self.minHandLength * 0.25), angle);
    CGPoint endPoint = PolarToDecart(center, self.minHandLength, angle);
    
    [self.minHandColor setFill];
    [self.minHandColor setStroke];
    
    [self drawPinAtStartPoint:startPoint endPoint:endPoint width:self.minHandWidth capStype:kCGLineCapRound];
}

- (void)drawClockSecHand:(CGFloat)sec {
    
    // canvas center
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    CGFloat angleCorrection = ToRadians(30 * 3); // angle correction start at angle 270°, default at 0°
    CGFloat angle = ToRadians(6 * sec) - angleCorrection;
    CGPoint startPoint = PolarToDecart(center, -(self.secHandLength * 0.3), angle);
    CGPoint endPoint = PolarToDecart(center, self.secHandLength, angle);
    
    [self.secHandColor setFill];
    [self.secHandColor setStroke];
    
    [self drawPinAtStartPoint:startPoint endPoint:endPoint width:self.secHandWidth capStype:kCGLineCapRound];
}


@end
