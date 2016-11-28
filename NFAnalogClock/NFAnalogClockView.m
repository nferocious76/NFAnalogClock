//
//  NFAnalogClockView.m
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 11/26/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import "NFAnalogClockView.h"
#import "NFMathGeometry.h"

@interface NFAnalogClockView()

// hour
@property (nonatomic) CGFloat hourHandLength;

// minutes
@property (nonatomic) CGFloat minHandLength;

// seconds
@property (nonatomic) CGFloat secHandLength;

// clock's radius
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat dateTimeCanvasPercent;

@property (nonatomic) BOOL isMinHandActive;

@end

@implementation NFAnalogClockView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self loadDefaultData];
}

- (void)loadDefaultData {
    
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];

    // default radius
    self.radius = (self.frame.size.height > self.frame.size.width ? self.frame.size.width / 2 : self.frame.size.height / 2) - 10;

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
    self.enableDateTimeLabel = YES;
    
    self.hourLabelFont = [UIFont systemFontOfSize:12];
    self.hourLabelColor = [UIColor blackColor];
    
    self.dateTimeLabelFont = [UIFont systemFontOfSize:16];
    self.dateTimeLabelColor = [UIColor redColor];

    self.currentHour = 0;
    self.currentMinute = 0;
    self.currentSecond = 0;
    
    self.dateTimeCanvasPercent = 0.20;
    
    self.dateTimeLabel = [[NSDate date] description];
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
    CGPoint canvasCenterPoint = [self canvasCenterWithDateTimeEnabled:self.enableDateTimeLabel];
    
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
    [self drawClockHourHandAtCenterPoint:canvasCenterPoint hour:self.currentHour];
    [self drawClockMinHandAtCenterPoint:canvasCenterPoint minute:self.currentMinute];
    [self drawClockSecHandAtCenterPoint:canvasCenterPoint second:self.currentSecond];
    
    if (self.enableDateTimeLabel) {
        [self drawClockDateTimeLabel:self.dateTimeLabel];
    }
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

- (void)setEnableClockLabel:(BOOL)enableClockLabel {
    _enableClockLabel = enableClockLabel;
    
    [self setNeedsDisplay];
}

- (void)setEnableDateTimeLabel:(BOOL)enableDateTimeLabel {
    _enableDateTimeLabel = enableDateTimeLabel;
    
    if (enableDateTimeLabel) {
        CGFloat canvasHeight = self.frame.size.height - (self.frame.size.height * self.dateTimeCanvasPercent);
        self.radius = (canvasHeight > self.frame.size.width ? self.frame.size.width / 2 : canvasHeight / 2) - 10;
    }else{
        self.radius = (self.frame.size.height > self.frame.size.width ? self.frame.size.width / 2 : self.frame.size.height / 2) - 10;
    }

    [self setNeedsDisplay];
}

- (void)setCurrentHour:(CGFloat)currentHour {
    _currentHour = currentHour;
    
    [self setNeedsDisplay];
}

- (void)setCurrentMinute:(CGFloat)currentMinute {
    _currentMinute = currentMinute;
    
    [self setNeedsDisplay];
}

- (void)setCurrentSecond:(CGFloat)currentSecond {
    _currentSecond = currentSecond;
    
    [self setNeedsDisplay];
}

- (void)setDateTimeLabel:(NSString *)dateTimeLabel {
    _dateTimeLabel = dateTimeLabel;
    
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

- (void)drawClockDateTimeLabel:(NSString *)dateTimeLabel {

    NSDictionary *fontAttribute = @{NSFontAttributeName: self.dateTimeLabelFont, NSForegroundColorAttributeName: self.dateTimeLabelColor};
    CGSize hourLabelSize = [dateTimeLabel sizeWithAttributes:fontAttribute];
    
    CGFloat canvasHeight = self.frame.size.height - (self.frame.size.height * self.dateTimeCanvasPercent);
    CGFloat dateTimeCanvasHeight = self.frame.size.height * self.dateTimeCanvasPercent;
    CGFloat canvasOriginY = (dateTimeCanvasHeight / 2) - (hourLabelSize.height / 2);
    
    CGFloat originX = (self.frame.size.width / 2) - (hourLabelSize.width / 2);
    CGFloat originY = canvasHeight + canvasOriginY;
    CGRect hourLabelRect = CGRectMake(originX, originY, hourLabelSize.width, hourLabelSize.height);
    
    [dateTimeLabel drawInRect:hourLabelRect withAttributes:fontAttribute];
}

/** Clock Hands */

- (void)drawClockHourHandAtCenterPoint:(CGPoint)center hour:(CGFloat)hour {

    CGFloat hourRatio = hour + (self.currentMinute / 60);
    CGFloat angleCorrection = ToRadians(30 * 3); // angle correction start at angle 270°, default at 0°
    CGFloat angle = ToRadians(30 * hourRatio) - angleCorrection;
    CGPoint startPoint = PolarToDecart(center, -(self.hourHandLength * 0.15), angle);
    CGPoint endPoint = PolarToDecart(center, self.hourHandLength, angle);

    [self.hourHandColor setFill];
    [self.hourHandColor setStroke];

    [self drawPinAtStartPoint:startPoint endPoint:endPoint width:self.hourHandWidth capStype:kCGLineCapRound];
}

- (void)drawClockMinHandAtCenterPoint:(CGPoint)center minute:(CGFloat)min {
    
    CGFloat angleCorrection = ToRadians(30 * 3); // angle correction start at angle 270°, default at 0°
    CGFloat angle = ToRadians(6 * min) - angleCorrection;
    CGPoint startPoint = PolarToDecart(center, -(self.minHandLength * 0.25), angle);
    CGPoint endPoint = PolarToDecart(center, self.minHandLength, angle);
    
    [self.minHandColor setFill];
    [self.minHandColor setStroke];
    
    [self drawPinAtStartPoint:startPoint endPoint:endPoint width:self.minHandWidth capStype:kCGLineCapRound];
}

- (void)drawClockSecHandAtCenterPoint:(CGPoint)center second:(CGFloat)sec {

    CGFloat angleCorrection = ToRadians(30 * 3); // angle correction start at angle 270°, default at 0°
    CGFloat angle = ToRadians(6 * sec) - angleCorrection;
    CGPoint startPoint = PolarToDecart(center, -(self.secHandLength * 0.3), angle);
    CGPoint endPoint = PolarToDecart(center, self.secHandLength, angle);
    
    [self.secHandColor setFill];
    [self.secHandColor setStroke];
    
    [self drawPinAtStartPoint:startPoint endPoint:endPoint width:self.secHandWidth capStype:kCGLineCapRound];
}

- (CGPoint)canvasCenterWithDateTimeEnabled:(BOOL)enabled {
    // canvas center
    CGPoint canvasCenterPoint = CGPointZero;
    
    if (enabled) {
        CGFloat canvasHeight = self.frame.size.height - (self.frame.size.height * self.dateTimeCanvasPercent);
        canvasCenterPoint = CGPointMake(self.frame.size.width / 2, canvasHeight / 2);
    }else{
        canvasCenterPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }
    
    return canvasCenterPoint;
}

#pragma mark - Touches

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:self];
    
    if ([self isTouchPointValid:touchLocation forMinuteHand:YES]) {
        self.isMinHandActive = YES;
        
        return YES;
    }
    
    if ([self isTouchPointValid:touchLocation forMinuteHand:NO]) {
        self.isMinHandActive = NO;
        
        return YES;
    }
    
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:self];
    [self calculateAngleForMinuteHand:self.isMinHandActive atTouchPoint:touchLocation];

    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:self];
    self.isMinHandActive = NO;

    NSLog(@"Tracking ended at: %@", NSStringFromCGPoint(touchLocation));
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    
    NSLog(@"Tracking canceled: %@", event);
}

- (BOOL)isTouchPointValid:(CGPoint)touchPoint forMinuteHand:(BOOL)isMinHand {
    // canvas center
    CGPoint canvasCenterPoint = [self  canvasCenterWithDateTimeEnabled:self.enableDateTimeLabel];
    struct PolarCoordinate polar = DecartToPolar(canvasCenterPoint, touchPoint);

    CGFloat angleCorrection = ToRadians(30 * 3); // angle correction start at angle 270°, default at 0°
    CGFloat fullCircleAngle = ToRadians(360);
    CGFloat correctedCircleAngle = fullCircleAngle - angleCorrection;
    
    BOOL isValid = NO;
    
    if (isMinHand) {
        CGFloat angle = ToRadians(6 * self.currentMinute) + correctedCircleAngle;
        CGFloat calculatedAngle = angle >= fullCircleAngle ? angle - fullCircleAngle : angle;
        CGFloat angleDiff = (polar.angle - calculatedAngle);
        isValid = angleDiff >= -0.03 && angleDiff <= 0.03;
        
        if (isValid) {
            NSLog(@"valid min touch angle: %f -- min angle: %f", polar.angle, angle);
        }

    }else{
        CGFloat hourRatio = self.currentHour + (self.currentMinute / 60);
        CGFloat angle = ToRadians(30 * hourRatio) + correctedCircleAngle;
        CGFloat calculatedAngle = angle >= fullCircleAngle ? angle - fullCircleAngle : angle;
        CGFloat angleDiff = (polar.angle - calculatedAngle);
        isValid = angleDiff >= -0.05 && angleDiff <= 0.05;
        
        if (isValid) {
            NSLog(@"valid hour touch angle: %f -- hour angle: %f", polar.angle, angle);
        }
    }

    if (!isValid) {
        NSLog(@"touch angle: %f", polar.angle);
    }
    
    return isValid;
}

- (void)calculateAngleForMinuteHand:(BOOL)isMinHand atTouchPoint:(CGPoint)touchPoint {
    // canvas center
    CGPoint canvasCenterPoint = [self  canvasCenterWithDateTimeEnabled:self.enableDateTimeLabel];
    struct PolarCoordinate polar = DecartToPolar(canvasCenterPoint, touchPoint);
    
    CGFloat angleCorrection = ToRadians(30 * 3); // angle correction start at angle 270°, default at 0°
    CGFloat fullCircleAngle = ToRadians(360);
    CGFloat angle = (polar.angle + angleCorrection);
    CGFloat calculatedAngle = angle >= fullCircleAngle ? angle - fullCircleAngle : angle;

    CGFloat percentRatio = calculatedAngle / fullCircleAngle;
    CGFloat fullCircleDegrees = 360 * percentRatio;

    if (isMinHand) {
        CGFloat minute = roundf(fullCircleDegrees / 6);
        self.currentMinute = minute;
    }else{
        CGFloat fullHours = (fullCircleDegrees / 6) / 5;
        CGFloat hour = truncf(fullHours);
        CGFloat minute = roundf((fullHours - hour) * 60);
        
        self.currentHour = hour;
        self.currentMinute = minute;
    }
    
    self.currentSecond = 0;
}

#pragma mark - Controls

- (void)setCurrentClockTimeWithHour:(CGFloat)hour minute:(CGFloat)minute second:(CGFloat)second {
    self.currentHour = hour;
    self.currentMinute = minute;
    self.currentSecond = second;
    
    [self setNeedsDisplay];
}

- (void)refreshView {
    
    [self setNeedsDisplay];
}

@end
