//
//  NFAnalogClockTimeManager.h
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 11/26/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NFAnalogClockView.h"

@interface NFAnalogClockTimeManager : NSObject

-(instancetype)initWithAnalogClockView:(NFAnalogClockView *)clockView;

- (void)startTime;
- (void)stopTime;


@end
