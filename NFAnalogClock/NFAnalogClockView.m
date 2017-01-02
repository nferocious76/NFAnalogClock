//
//  NFAnalogClockView.m
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 11/26/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import "NFAnalogClockView.h"
#import "NFMathGeometry.h"
#import "NFAnalogClockView+Extension.h"

typedef enum : NSUInteger {
    Hour,
    Minute,
    Second,
} ClockHand;

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

// clock's active hand
@property (nonatomic) ClockHand activeClockHand;

@end

@implementation NFAnalogClockView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<NFAnalogClockViewDelegate>)delegate dataSource:(id<NFAnalogClockViewDataSource>)dataSource {
    
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        self.dataSource = dataSource;
        
        [self loadDefaultData];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self loadDefaultData];
}

- (void)loadDefaultData {
    
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    
    _currentHour = 11;
    _currentMinute = 59;
    _currentSecond = 59;
    
    _dateTimeCanvasPercent = 0.20;
    
    _enableHourDial = YES;
    _enableMinDial = YES;
    _enableSecDial = YES;
    _enableClockLabel = YES;
    _showMinHand = YES;
    _showSecHand = YES;
    _enableGradient = NO;
    
    self.enableDateTimeLabel = YES;

    // hour
    _hourDialColor = [UIColor lightGrayColor];
    _hourHandColor = [UIColor grayColor];
    
    _hourDialWidth = 2;
    _hourDialLength = 10;
    _hourHandLength = self.radius * 0.7;
    _hourHandWidth = 5;
    
    // minutes
    _minDialColor = [[UIColor greenColor] colorWithAlphaComponent:0.8];
    _minHandColor = [UIColor greenColor];
    
    _minDialWidth = 1.5;
    _minDialLength = 5;
    _minHandLength = self.radius * 0.9;
    _minHandWidth = 4;
    
    // seconds
    _secDialColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
    _secHandColor = [UIColor blueColor];
    
    _secDialWidth = 1;
    _secDialLength = 2.5;
    _secHandLength = self.radius * 0.95;
    _secHandWidth = 3;
    
    _hourLabelFont = [UIFont systemFontOfSize:12];
    _hourLabelColor = [UIColor blackColor];
    
    _dateTimeLabelFont = [UIFont systemFontOfSize:16];
    _dateTimeLabelColor = [UIColor redColor];
    
    _clockFaceColor = [UIColor yellowColor];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    
    if ([self.dataSource respondsToSelector:@selector(dateFormatForClockView:)]) {
        self.dateFormatter.dateFormat = [self.dataSource dateFormatForClockView:self];
    }else{
        self.dateFormatter.dateFormat = NFAnalogClockDefaultDateFormat();
    }
    
    self.gradientLocations = @[@(0.15), @(0.85)];
    self.gradientColors = @[(id)[UIColor blueColor].CGColor,
                            (id)[UIColor yellowColor].CGColor];
    
    _clockDate = [NSDate date];
    NSString *currentDateTime = [self.dateFormatter stringFromDate:self.clockDate];
    [self setDateTimeLabel:currentDateTime];

}

#pragma mark - Drawing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetAllowsFontSmoothing(context, YES);
    
    // canvas center
    CGPoint canvasCenterPoint = [self canvasCenterWithDateTimeEnabled:self.enableDateTimeLabel];

    [self.clockFaceColor setFill];
    [self.clockFaceColor setStroke];
    
    CGFloat maxAngle = ToRadians(360);
    CGContextAddArc(context, canvasCenterPoint.x, canvasCenterPoint.y, self.radius + 0.5, 0, maxAngle, 0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    CGContextSetAlpha(context, self.alpha);
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);

    // draw dial pins
    if (self.enableHourDial) {
        [self drawHourDialAtCenterPoint:canvasCenterPoint];
    }
    
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
    
    if (self.showMinHand) {
        [self drawClockMinHandAtCenterPoint:canvasCenterPoint minute:self.currentMinute];
    }
    
    if (self.showSecHand) {
        [self drawClockSecHandAtCenterPoint:canvasCenterPoint second:self.currentSecond];
    }
    
    if (self.enableDateTimeLabel) {
        [self drawClockDateTimeLabel:self.dateTimeLabel];
    }
    
    CGContextRestoreGState(context);
}

#pragma mark - Setters

- (void)setEnableHourDial:(BOOL)enableHourDial {
    _enableHourDial = enableHourDial;
    
    [self setNeedsDisplay];
}

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

- (void)setEnableGradient:(BOOL)enableGradient {
    _enableGradient = enableGradient;
    
    [self setNeedsDisplay];
}

- (void)setShowMinHand:(BOOL)showMinHand {
    _showMinHand = showMinHand;
    
    [self setNeedsDisplay];
}

- (void)setShowSecHand:(BOOL)showSecHand {
    _showSecHand = showSecHand;
    
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
    if (self.enableGradient) {
        for (CALayer *layer in [self.layer sublayers]) {
            [layer removeFromSuperlayer];
        }
    }

    CGFloat angleCorrection = ToRadians(30 * 3); // angle correction start at angle 270°, default at 0°
    for (int i = 0; i < 12; i++) {
        
        CGFloat angle = ToRadians(30 * i) - angleCorrection;
        CGPoint startPoint = PolarToDecart(center, self.radius - self.hourDialLength, angle);
        CGPoint endPoint = PolarToDecart(center, self.radius, angle);
        
        [self.hourDialColor setFill];
        [self.hourDialColor setStroke];
        
        if (self.enableGradient) {
            [self drawGradientPinAtStartPoint:startPoint endPoint:endPoint width:self.hourDialWidth capStype:kCGLineCapSquare];
        }else{
            [self drawPinAtStartPoint:startPoint endPoint:endPoint width:self.hourDialWidth capStype:kCGLineCapSquare];
        }
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

- (void)drawGradientPinAtStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint width:(CGFloat)width capStype:(CGLineCap)capStype {
    // Test
    [self drawPinAtStartPoint:startPoint endPoint:endPoint width:width capStype:capStype];

    CAGradientLayer* gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = self.gradientColors;
    gradientLayer.locations = self.gradientLocations;
    
    CGFloat square = width / 2;
    CGRect maskRect = CGRectMake(startPoint.x - square, startPoint.y, width, self.hourDialLength);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskRect cornerRadius:0];
    
    CAShapeLayer* mask = [[CAShapeLayer alloc] init];
    mask.frame = self.bounds;
    mask.path = maskPath.CGPath;
    mask.fillColor = [UIColor blackColor].CGColor;
    gradientLayer.mask = mask;
    
    [self.layer addSublayer:gradientLayer];

    // test layer
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:width];
    
    if (startPoint.y == endPoint.y) {
        CGPoint sPoint = CGPointMake(startPoint.x, startPoint.y - square);
        CGPoint sPoint2 = CGPointMake(startPoint.x, startPoint.y + square);
        CGPoint ePoint = CGPointMake(endPoint.x, endPoint.y + square);
        CGPoint ePoint2 = CGPointMake(endPoint.x, endPoint.y - square);
        
        [path moveToPoint:sPoint];
        [path addLineToPoint:sPoint2];
        [path addLineToPoint:ePoint];
        [path addLineToPoint:ePoint2];
    }else if (startPoint.x == endPoint.x) {
        CGPoint sPoint = CGPointMake(startPoint.x - square, startPoint.y);
        CGPoint sPoint2 = CGPointMake(startPoint.x + square, startPoint.y);
        CGPoint ePoint = CGPointMake(endPoint.x + square, endPoint.y);
        CGPoint ePoint2 = CGPointMake(endPoint.x - square, endPoint.y);
        
        [path moveToPoint:sPoint];
        [path addLineToPoint:sPoint2];
        [path addLineToPoint:ePoint];
        [path addLineToPoint:ePoint2];
    }/*else{
        CGPoint sPoint = CGPointMake(startPoint.x - square, startPoint.y - square);
        CGPoint sPoint2 = CGPointMake(startPoint.x + square, startPoint.y + square);
        CGPoint ePoint = CGPointMake(endPoint.x + square, endPoint.y + square);
        CGPoint ePoint2 = CGPointMake(endPoint.x - square, endPoint.y - square);
        
        [path moveToPoint:sPoint];
        [path addLineToPoint:sPoint2];
        [path addLineToPoint:ePoint];
        [path addLineToPoint:ePoint2];
    }*/
    [path closePath];

    CAGradientLayer* gradientLayer2 = [[CAGradientLayer alloc] init];
    gradientLayer2.frame = self.bounds;
    gradientLayer2.colors = @[(id)[UIColor greenColor].CGColor,
                              (id)[UIColor redColor].CGColor];
    gradientLayer2.locations = self.gradientLocations;

    CAShapeLayer* mask2 = [[CAShapeLayer alloc] init];
    mask2.frame = self.bounds;
    mask2.path = path.CGPath;
    mask2.fillColor = [UIColor blackColor].CGColor;
    gradientLayer2.mask = mask2;
    
    [self.layer addSublayer:gradientLayer2];

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

#pragma mark - Control Touches

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch preciseLocationInView:self];
    
    if (self.showMinHand) {
        if ([self isTouchPointValid:touchLocation forClockHand:Minute]) {
            self.activeClockHand = Minute;
            
            [self stopTime];
            return YES;
        }
    }
    
    if ([self isTouchPointValid:touchLocation forClockHand:Hour]) {
        self.activeClockHand = Hour;
        
        [self stopTime];
        return YES;
    }
    
    if (self.showSecHand) {
        if ([self isTouchPointValid:touchLocation forClockHand:Second]) {
            self.activeClockHand = Second;
            
            [self stopTime];
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch preciseLocationInView:self];
    CGPoint prevTouchPoint = [touch precisePreviousLocationInView:self];
    
    [self calculateAngleForClockHand:self.activeClockHand atTouchPoint:touchPoint prevTouchPoint:prevTouchPoint];
    
    NFTime *time = [self updateClock];
    if ([self.delegate respondsToSelector:@selector(clockView:didUpdateTime:)]) {
        [self.delegate clockView:self didUpdateTime:time];
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch preciseLocationInView:self];
    CGPoint prevTouchPoint = [touch precisePreviousLocationInView:self];
    
    [self calculateAngleForClockHand:self.activeClockHand atTouchPoint:touchPoint prevTouchPoint:prevTouchPoint];
    
    NFTime *time = [self updateClock];
    if ([self.delegate respondsToSelector:@selector(clockView:didUpdateTime:)]) {
        [self.delegate clockView:self didUpdateTime:time];
    }
    
    NSLog(@"Tracking ended at: %@", NSStringFromCGPoint(touchPoint));
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    
    NSLog(@"Tracking canceled: %@", event);
}

#pragma mark - Calculations

- (BOOL)isTouchPointValid:(CGPoint)touchPoint forClockHand:(ClockHand)hand {
    // canvas center
    CGPoint canvasCenterPoint = [self  canvasCenterWithDateTimeEnabled:self.enableDateTimeLabel];
    struct PolarCoordinate polar = DecartToPolar(canvasCenterPoint, touchPoint);
    
    CGFloat angleCorrection = ToRadians(30 * 3); // angle correction start at angle 270°, default at 0°
    CGFloat fullCircleAngle = ToRadians(360);
    CGFloat correctedCircleAngle = fullCircleAngle - angleCorrection;

    switch (hand) {
        case Hour: {
            
            CGFloat hourRatio = self.currentHour + (self.currentMinute / 60);
            CGFloat angle = ToRadians(30 * hourRatio) + correctedCircleAngle;
            CGFloat calculatedAngle = angle >= fullCircleAngle ? angle - fullCircleAngle : angle;
            CGFloat angleDiff = (polar.angle - calculatedAngle);
            
            BOOL touchRadius = polar.radius <= self.hourHandLength && polar.radius > 0;
            BOOL isValid = angleDiff >= -0.04 && angleDiff <= 0.04 && touchRadius;
            
            if (isValid) {
                NSLog(@"valid hour touch angle: %f -- hour angle: %f", polar.angle, angle);
            }
            
            return isValid;
        } break;

        case Minute: {
            
            CGFloat angle = ToRadians(6 * self.currentMinute) + correctedCircleAngle;
            CGFloat calculatedAngle = angle >= fullCircleAngle ? angle - fullCircleAngle : angle;
            CGFloat angleDiff = (polar.angle - calculatedAngle);
            
            BOOL touchRadius = polar.radius <= self.minHandLength && polar.radius > 0;
            BOOL isValid = angleDiff >= -0.03 && angleDiff <= 0.03 && touchRadius;
            
            if (isValid) {
                NSLog(@"valid min touch angle: %f -- min angle: %f", polar.angle, angle);
            }
            
            return isValid;
        } break;

        case Second: {
            
            CGFloat angle = ToRadians(6 * self.currentSecond) + correctedCircleAngle;
            CGFloat calculatedAngle = angle >= fullCircleAngle ? angle - fullCircleAngle : angle;
            CGFloat angleDiff = (polar.angle - calculatedAngle);
            
            BOOL touchRadius = polar.radius <= self.secHandLength && polar.radius > 0;
            BOOL isValid = angleDiff >= -0.03 && angleDiff <= 0.03 && touchRadius;
            
            if (isValid) {
                NSLog(@"valid min touch angle: %f -- min angle: %f", polar.angle, angle);
            }
            
            return isValid;
        } break;

        default:
            NSLog(@"invalid touch angle: %f", polar.angle);
            
            return NO;
    }
}

- (CGFloat)prevFullRotationTimeRatioForPreviousTouchPoint:(CGPoint)prevTouchPoint angleCorrection:(CGFloat)angleCorrection fullCircleAngle:(CGFloat)fullCircleAngle {
    // canvas center
    CGPoint canvasCenterPoint = [self  canvasCenterWithDateTimeEnabled:self.enableDateTimeLabel];
    struct PolarCoordinate polar = DecartToPolar(canvasCenterPoint, prevTouchPoint);
    
    CGFloat angle = (polar.angle + angleCorrection);
    CGFloat calculatedAngle = angle >= fullCircleAngle ? angle - fullCircleAngle : angle;
    
    CGFloat percentRatio = calculatedAngle / fullCircleAngle;
    CGFloat fullCircleDegrees = 360 * percentRatio;
    CGFloat timeRatio = fullCircleDegrees / 6;
    
    CGFloat minute = roundf(timeRatio);
    return minute;
}

- (BOOL)isRotationClockwiseForTouchPoint:(CGPoint)touchPoint prevTouchPoint:(CGPoint)prevTouchPoint {
    // canvas center
    CGPoint canvasCenterPoint = [self  canvasCenterWithDateTimeEnabled:self.enableDateTimeLabel];
    struct PolarCoordinate polar = DecartToPolar(canvasCenterPoint, touchPoint);
    struct PolarCoordinate prevPolar = DecartToPolar(canvasCenterPoint, prevTouchPoint);
    
    CGFloat value = polar.angle - prevPolar.angle;
    return value > 0;
}

- (void)calculateAngleForClockHand:(ClockHand)hand atTouchPoint:(CGPoint)touchPoint prevTouchPoint:(CGPoint)prevTouchPoint {
    // canvas center
    CGPoint canvasCenterPoint = [self  canvasCenterWithDateTimeEnabled:self.enableDateTimeLabel];
    struct PolarCoordinate polar = DecartToPolar(canvasCenterPoint, touchPoint);
    
    CGFloat angleCorrection = ToRadians(30 * 3); // angle correction start at angle 270°, default at 0°
    CGFloat fullCircleAngle = ToRadians(360);
    CGFloat angle = (polar.angle + angleCorrection);
    CGFloat calculatedAngle = angle >= fullCircleAngle ? angle - fullCircleAngle : angle;
    
    CGFloat percentRatio = calculatedAngle / fullCircleAngle;
    CGFloat fullCircleDegrees = 360 * percentRatio;
    CGFloat timeRatio = fullCircleDegrees / 6;
    
    switch (hand) {
        case Hour: {
            CGFloat fullHours = timeRatio / 5;
            CGFloat hour = truncf(fullHours);
            CGFloat minute = roundf((fullHours - hour) * 60);
            
            if (minute == 60) {
                hour += 1;
                minute = 0;
            }

            self.currentHour = hour;
            self.currentMinute = minute;

        } break;

        case Minute: {
            CGFloat minute = roundf(timeRatio);
            CGFloat prevMinute = [self prevFullRotationTimeRatioForPreviousTouchPoint:prevTouchPoint angleCorrection:angleCorrection fullCircleAngle:fullCircleAngle];

            if (prevMinute == 0 && minute >= 59) {
                self.currentHour -= 1;
            }else if (minute == 0 && prevMinute >= 59) {
                self.currentHour += 1;
            }
            
            if (self.currentHour < 0) {
                self.currentHour = 11;
            }else if (self.currentHour > 12) {
                self.currentHour = 1;
            }
            
            self.currentMinute = minute;
        } break;

        case Second: {
            CGFloat second = roundf(timeRatio);
            self.currentSecond = second;

        } break;

        default:
            break;
    }
}

#pragma mark - Controls

- (void)setCurrentClockTimeWithHour:(CGFloat)hour minute:(CGFloat)minute second:(CGFloat)second {
    self.currentHour = hour;
    self.currentMinute = minute;
    self.currentSecond = second;
    
    [self setNeedsDisplay];
    [self updateClock];
}

- (void)refreshClockView {
    
    [self setNeedsDisplay];
    [self updateClock];
}

@end
