//
//  ViewController.m
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 11/26/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import "ViewController.h"
#import "NFAnalogClockTimeManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet NFAnalogClockView *clockView;
@property (nonatomic, strong) NFAnalogClockTimeManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.manager = [[NFAnalogClockTimeManager alloc] initWithAnalogClockView:self.clockView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
