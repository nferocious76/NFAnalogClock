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
    
    // hour
    self.hourDialColor = [UIColor lightGrayColor];
    self.hourHandColor = [UIColor grayColor];
    
    self.hourDialWidth = 2;
    self.hourDialLength = 10;
    
    
    // minutes
    self.minDialColor = [[UIColor greenColor] colorWithAlphaComponent:0.8];
    self.minHandColor = [UIColor greenColor];
    
    self.minDialWidth = 1.5;
    self.minDialLength = 5;
    
    // seconds
    self.secDialColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
    self.secHandColor = [UIColor blueColor];
    
    self.secDialWidth = 1;
    self.secDialLength = 2.5;
    
    // default radius
    self.radius = self.frame.size.height > self.frame.size.width ? self.frame.size.width / 2 : self.frame.size.height / 2;
    
}

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
    [self drawMinuteDialAtCenterPoint:canvasCenterPoint];
    [self drawSecondDialAtCenterPoint:canvasCenterPoint];
}

#pragma mark - Utils

- (void)drawHourDialAtCenterPoint:(CGPoint)center {
    
    for (int i = 0; i < 12; i++) {
        
        CGFloat angle = ToRadians(30 * i);
        CGPoint startPoint = PolarToDecart(center, self.radius - self.hourDialLength, angle);
        CGPoint endPoint = PolarToDecart(center, self.radius, angle);
        
        [self.hourDialColor setFill];
        [self.hourDialColor setStroke];
        
        [self drawPinAtStartPoint:startPoint endPoint:endPoint dialWidth:self.hourDialWidth];
    }
}

- (void)drawMinuteDialAtCenterPoint:(CGPoint)center {
    
    for (int i = 0; i < 60; i++) {
        if (i % 5 == 0) { continue; }
        
        CGFloat angle = ToRadians(6 * i);
        CGPoint startPoint = PolarToDecart(center, self.radius - self.minDialLength, angle);
        CGPoint endPoint = PolarToDecart(center, self.radius, angle);
        
        [self.minDialColor setFill];
        [self.minDialColor setStroke];
        
        [self drawPinAtStartPoint:startPoint endPoint:endPoint dialWidth:self.minDialWidth];
    }
}

- (void)drawSecondDialAtCenterPoint:(CGPoint)center {
    
    for (int i = 0; i < 360; i++) {
        if (i % 6 == 0) { continue; }

        CGFloat angle = ToRadians(1 * i);
        CGPoint startPoint = PolarToDecart(center, self.radius - self.secDialLength, angle);
        CGPoint endPoint = PolarToDecart(center, self.radius, angle);
        
        [self.secDialColor setFill];
        [self.secDialColor setStroke];
        
        [self drawPinAtStartPoint:startPoint endPoint:endPoint dialWidth:self.secDialWidth];
    }
}


- (void)drawPinAtStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint dialWidth:(CGFloat)dialWidth {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:dialWidth];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    
    [path setLineCapStyle:kCGLineCapSquare];
    [path fill];
    [path stroke];
}

@end
