//
//  DSAnimationSwitch.h
//  DSAnimationSwitch
//
//  Created by Sam on 11/26/15.
//  Copyright © 2015 Ding Sai. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Switch type
typedef enum{
    DSAnimationSwitchStyleLight,
    DSAnimationSwitchStyleDark,
    DSAnimationSwitchStyleDefault
} DSAnimationSwitchStyle;

#pragma mark - Switch State
typedef enum{
    DSAnimationSwitchStateOn,
    DSAnimationSwitchStateOff
} DSAnimationSwitchState;

#pragma mark - Switch Size
typedef enum{
    DSAnimationSwitchSizeBig,
    DSAnimationSwitchSizeSmall,
    DSAnimationSwitchSizeNormal
} DSAnimationSwitchSize;

#pragma mark - delegate method
@protocol DSAnimationSwitchDelegate <NSObject>

- (void)SwitchStateChanged:(DSAnimationSwitchState)currentState;

@end



@interface DSAnimationSwitch : UIControl


//Delegate
@property(nonatomic, assign) id<DSAnimationSwitchDelegate> delegate;

#pragma State
// 当前状态，YES to ON , NO to OFF
@property(nonatomic) BOOL isOn;
// 是否可调节，YES to enabled , NO to disabled
@property(nonatomic) BOOL isEnabled;
// 缓冲效果是否开启
@property(nonatomic) BOOL isBounceEnabled;
// 波纹效果是否开启
@property(nonatomic) BOOL isRippleEnabled;


#pragma colour
// 开启颜色
@property(nonatomic, strong) UIColor *OnColor;
// 关闭颜色
@property(nonatomic, strong) UIColor *OffColor;
// 轨道颜色
@property(nonatomic, strong) UIColor *TrackOnColor;
// 波纹颜色
@property(nonatomic, strong) UIColor *RippleColor;


#pragma UI
// Button
@property(nonatomic, strong) UIButton *switchThumb;
// track
@property(nonatomic, strong) UIView *track;


#pragma methods

- (id)init;

- (id)initWithSize:(DSAnimationSwitchSize)size state:(DSAnimationSwitchState)state;

- (BOOL)getSwitchState;

- (void)setOn:(BOOL)on animated:(BOOL)animated;




@end
