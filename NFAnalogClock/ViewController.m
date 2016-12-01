//
//  ViewController.m
//  NFAnalogClock
//
//  Created by Neil Francis Hipona on 11/26/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import "ViewController.h"
#import "NFAnalogClockTimeManager.h"

@interface ViewController ()<UITextFieldDelegate, NFAnalogClockViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *hourInputField;
@property (weak, nonatomic) IBOutlet UITextField *minuteInputField;
@property (weak, nonatomic) IBOutlet UITextField *secondInputField;


@property (weak, nonatomic) IBOutlet NFAnalogClockView *clockView;
@property (nonatomic, strong) NFAnalogClockTimeManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.clockView.delegate = self;
    self.manager = [[NFAnalogClockTimeManager alloc] initWithAnalogClockView:self.clockView];
    
    [self.hourInputField addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.minuteInputField addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.secondInputField addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self.manager stopTime];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.manager startTime];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldTextDidChange:(UITextField *)tf {
    [self.manager stopTime];
    
    if (tf == self.hourInputField) {
        CGFloat value = [tf.text floatValue];
        self.clockView.currentHour = value;
        
    }else if (self.minuteInputField == tf ) {
        CGFloat value = [tf.text floatValue];
        self.clockView.currentMinute = value;
        
    }else if (self.secondInputField == tf ) {
        CGFloat value = [tf.text floatValue];
        self.clockView.currentSecond = value;
    }
}

#pragma mark - NFAnalogClockViewDelegate

- (void)clockView:(NFAnalogClockView *)clockView didUpdateTime:(NSString *)timeString {
    
    NSLog(@"%@", timeString);
}

@end
