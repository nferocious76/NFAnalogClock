//
//  MathGeometry.m
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 11/12/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import "NFMathGeometry.h"

NSString *NFAnalogClockDefaultDateFormat() {
    return @"dd MMMM yyyy HH:mm:ss a";
}

struct PolarCoordinate PolarCoordinateMake(CGFloat radius, CGFloat angle)
{
    struct PolarCoordinate pCoordinate;
    pCoordinate.radius = radius;
    pCoordinate.angle = angle;
    
    return pCoordinate;
}

CGFloat ToDegrees(CGFloat radians) {
    
    return radians * 180 / M_PI;
}

CGFloat ToRadians(CGFloat degrees) {
    
    return degrees * M_PI / 180;
}

CGFloat SegmentAngle(CGPoint startPoint, CGPoint endPoint) {
    
    CGPoint v = CGPointMake(endPoint.x - startPoint.x, endPoint.y - startPoint.y);
    double vmag = sqrt(powf(v.x, 2.0) + powf(v.y, 2.0));
    v.x /= vmag;
    v.y /= vmag;
    
    double radians = atan2(v.y,v.x);
    return radians;
}

CGFloat SegmentLength(CGPoint startPoint, CGPoint endPoint) {
    struct PolarCoordinate pCoordinate = DecartToPolar(startPoint, endPoint);
    
    return pCoordinate.radius;
}

CGPoint PolarToDecart(CGPoint startPoint, CGFloat radius, CGFloat angle) {
    double x = radius * cos(angle) + startPoint.x;
    double y = radius * sin(angle) + startPoint.y;
    
    return CGPointMake(x, y);
}


struct PolarCoordinate DecartToPolar(CGPoint center, CGPoint point) {
    CGFloat x = point.x - center.x;
    CGFloat y = point.y - center.y;
    
    double radius = sqrt(pow(x, 2.0) + pow(y, 2.0));
    double angle = acos(x/(sqrt(pow(x, 2.0) + pow(y, 2.0))));
    
    struct PolarCoordinate polar = PolarCoordinateMake(radius, angle);
    
    if (y < 0) {
        polar.angle = 2 * M_PI - polar.angle;
    }
    
    return polar;
}
