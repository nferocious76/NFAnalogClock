//
//  MathGeometry.h
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 11/12/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NSString *NFAnalogClockDefaultDateFormat();

struct PolarCoordinate {
    CGFloat radius;
    CGFloat angle;
};

struct PolarCoordinate PolarCoordinateMake(CGFloat radius, CGFloat angle);

CGFloat ToDegrees(CGFloat radians);

CGFloat ToRadians(CGFloat degrees);

CGFloat SegmentAngle(CGPoint startPoint, CGPoint endPoint);

CGFloat SegmentLength(CGPoint startPoint, CGPoint endPoint);

CGPoint PolarToDecart(CGPoint startPoint, CGFloat radius, CGFloat angle);

struct PolarCoordinate DecartToPolar(CGPoint center, CGPoint point);
