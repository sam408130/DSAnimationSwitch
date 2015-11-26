//
//  ViewController.m
//  DSAnimationSwitch
//
//  Created by Sam on 11/26/15.
//  Copyright © 2015 Ding Sai. All rights reserved.
//

#import "ViewController.h"

#import "DSAnimationSwitch.h"

@interface ViewController () <DSAnimationSwitchDelegate>
@property(nonatomic , strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DSAnimationSwitch *samSwitch = [[DSAnimationSwitch alloc] init];
    samSwitch.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height/2);
    samSwitch.delegate = self;
    CGRect frame = samSwitch.frame;
    frame.origin.x = CGRectGetMaxX(frame) + 20;
    self.label = [[UILabel alloc] initWithFrame:frame];
    self.label.textColor = [UIColor colorWithRed:47.0/255.0 green:163.0/255.0 blue:220.0/255.0 alpha:1.0];
    self.label.font = [UIFont systemFontOfSize:30];
    self.label.text = @"开";
    [self.view addSubview:self.label];
    [self.view addSubview:samSwitch];
}

- (void)SwitchStateChanged:(DSAnimationSwitchState)currentState {
    NSLog(@"%u",currentState);
    if (currentState == 1){
        self.label.text = @"关";
        self.label.textColor = [UIColor grayColor];
    }else{
        self.label.text = @"开";
        self.label.textColor = [UIColor colorWithRed:47.0/255.0 green:163.0/255.0 blue:220.0/255.0 alpha:1.0];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
