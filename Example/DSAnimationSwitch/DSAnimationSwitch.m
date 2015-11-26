//
//  DSAnimationSwitch.m
//  DSAnimationSwitch
//
//  Created by Sam on 11/26/15.
//  Copyright © 2015 Ding Sai. All rights reserved.
//

#import "DSAnimationSwitch.h"
#import <QuartzCore/QuartzCore.h>

@interface DSAnimationSwitch()
//轨道宽度
@property (nonatomic) CGFloat trackThickness;
//按钮大小
@property (nonatomic) CGFloat thumbSize;

@property (nonatomic) CGFloat thumbOnPosition;
@property (nonatomic) CGFloat thumbOffPosition;
@property (nonatomic , strong)CAShapeLayer *rippleLayer;

@end

@implementation DSAnimationSwitch


- (instancetype)init
{
    self = [self initWithSize:DSAnimationSwitchSizeBig state:DSAnimationSwitchStateOn];
    return self;
}


- (id)initWithSize:(DSAnimationSwitchSize)size state:(DSAnimationSwitchState)state {
    
    //初始化
    self.OnColor = [UIColor colorWithRed:47.0/255.0 green:163.0/255.0 blue:220.0/255.0 alpha:1.0];
    self.OffColor = [UIColor groupTableViewBackgroundColor];
    self.TrackOnColor = [UIColor colorWithRed:47.0/255.0 green:163.0/255.0 blue:220.0/255.0 alpha:0.3];
    self.RippleColor = [UIColor blueColor];
    
    self.isEnabled = YES;
    self.isRippleEnabled = YES;
    self.isBounceEnabled = YES;
    
    CGRect frame;
    CGRect trackFrame = CGRectZero;
    CGRect thumbFrame = CGRectZero;
    
    //switch size
    switch (size) {
        case DSAnimationSwitchSizeBig:
            frame = CGRectMake(0, 0, 60, 50);
            self.trackThickness = 33.0;
            self.thumbSize = 41.0;
            break;
        case DSAnimationSwitchSizeNormal:
            frame = CGRectMake(0, 0, 40, 30);
            self.trackThickness = 17.0;
            self.thumbSize = 24.0;
            break;
        case DSAnimationSwitchSizeSmall:
            frame = CGRectMake(0, 0, 30, 25);
            self.trackThickness = 13.0;
            self.thumbSize = 18.0;
            break;
            
        default:
            frame = CGRectMake(0, 0, 40, 30);
            self.trackThickness = 13.0;
            self.thumbSize = 20.0;
            break;
    }
    
    trackFrame.size.height = self.trackThickness;
    trackFrame.size.width = frame.size.width;
    trackFrame.origin.x = 0.0;
    trackFrame.origin.y = (frame.size.height - trackFrame.size.height) / 2;
    
    thumbFrame.size.height = self.thumbSize;
    thumbFrame.size.width = thumbFrame.size.height;
    thumbFrame.origin.x = 0.0;
    thumbFrame.origin.y = (frame.size.height - thumbFrame.size.height) / 2;
    
    //Actual initialization with selected size
    self = [super initWithFrame:frame];
    
    self.track = [[UIView alloc] initWithFrame:trackFrame];
    self.track.backgroundColor = [UIColor grayColor];
    self.track.layer.cornerRadius = MIN(self.track.frame.size.height, self.track.frame.size.width) / 2;
    [self addSubview:self.track];
    
    
    self.switchThumb = [[UIButton alloc] initWithFrame:thumbFrame];
    self.switchThumb.backgroundColor = [UIColor whiteColor];
    self.switchThumb.layer.cornerRadius = self.switchThumb.frame.size.height / 2;
    self.switchThumb.layer.shadowOpacity = 0.5;
    self.switchThumb.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.switchThumb.layer.shadowColor = [UIColor blackColor].CGColor;
    self.switchThumb.layer.shadowRadius = 2.0f;
    
    
    //add events
    [self.switchThumb addTarget:self action:@selector(onTouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
    [self.switchThumb addTarget:self action:@selector(onTouchUpOutsideOrCanceled:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
    [self.switchThumb addTarget:self action:@selector(switchThumbTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchThumb addTarget:self action:@selector(onTouchDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.switchThumb addTarget:self action:@selector(onTouchUpOutsideOrCanceled:withEvent:) forControlEvents:UIControlEventTouchCancel];
    
    [self addSubview:self.switchThumb];

    
    self.thumbOnPosition = self.frame.size.width - self.switchThumb.frame.size.width;
    self.thumbOffPosition = self.switchThumb.frame.origin.x;
    
    //set position from state property
    switch (state) {
        case DSAnimationSwitchStateOn:
            self.isOn = YES;
            self.switchThumb.backgroundColor = self.OnColor;
            CGRect thumbFrame = self.switchThumb.frame;
            thumbFrame.origin.x = self.thumbOnPosition;
            self.switchThumb.frame = thumbFrame;
            break;
        
        case DSAnimationSwitchStateOff:
            self.isOn = NO;
            self.switchThumb.backgroundColor = self.OffColor;
            break;
        default:
            self.isOn = NO;
            self.switchThumb.backgroundColor = self.OffColor;
            break;
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchAreaTapped:)];
    [self addGestureRecognizer:singleTap];
    
    return self;
    
}

// when addsubview is called;
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    if (self.isOn == YES){
        self.switchThumb.backgroundColor = self.OnColor;
        self.track.backgroundColor = self.TrackOnColor;
    }else{
        self.switchThumb.backgroundColor = self.OffColor;
        self.track.backgroundColor = self.OffColor;
    }
    
    if (self.isEnabled == NO){
        self.switchThumb.backgroundColor = [UIColor grayColor];
        self.track.backgroundColor = [UIColor grayColor];
    }
    
}


- (BOOL)getSwitchState{
    return self.isOn;
}


- (void)setOn:(BOOL)on animated:(BOOL)animated {
    
    if (on == YES){
        if (animated == YES){
            [self changeThumbStateONwithAnimation];
        }else{
            [self changeThumbStateONwithoutAnimation];
        }
    }else{
        if (animated == YES){
            [self changeThumbStateOFFwithAnimation];
        }else{
            [self changeThumbStateOFFwithoutAnimation];
        }
    }
}

//overide setEnable
- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    
    if (enabled == YES){
        if (self.isOn == YES){
            self.switchThumb.backgroundColor = self.OnColor;
            self.track.backgroundColor = self.TrackOnColor;
        }else{
            self.switchThumb.backgroundColor = self.OffColor;
            self.track.backgroundColor = self.OffColor;
        }
        self.isEnabled = YES;
    }else{
        self.switchThumb.backgroundColor = self.OffColor;
        self.track.backgroundColor = self.OffColor;
        self.isEnabled = NO;
    }
}


//tap gesture event
- (void)switchAreaTapped:(UITapGestureRecognizer *)recognizer {
    //delegate method
    if ([self.delegate respondsToSelector:@selector(SwitchStateChanged:)]){
        NSLog(@"taped");
        if (self.isOn == YES){
            [self.delegate SwitchStateChanged:DSAnimationSwitchStateOff];
        }else{
            [self.delegate SwitchStateChanged:DSAnimationSwitchStateOn];
        }
    }

    
    [self changeThumbState];
    
}

- (void)changeThumbState{
    if (self.isOn == YES){
        [self changeThumbStateOFFwithAnimation];
    }else{
        [self changeThumbStateONwithAnimation];
    }
    
    if (self.isRippleEnabled == YES){
        [self animateRippleEffect];
    }
}

//switch movement animation
- (void)changeThumbStateONwithAnimation {
    [UIView animateWithDuration:0.15f
                          delay:0.05f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect thumbFrame = self.switchThumb.frame;
                         thumbFrame.origin.x = self.thumbOnPosition +  3.0f;
                         self.switchThumb.frame = thumbFrame;
                         self.switchThumb.backgroundColor = self.OnColor;
                         self.track.backgroundColor = self.TrackOnColor;
                         self.userInteractionEnabled = NO;

                     }completion:^(BOOL finished){
                         if (self.isOn == NO){
                             self.isOn = YES;
                             [self sendActionsForControlEvents:UIControlEventValueChanged];
                         }
                         
                         self.isOn = YES;
                         [UIView animateWithDuration:0.15f
                                          animations:^{
                                              CGRect thumbFrame = self.switchThumb.frame;
                                              thumbFrame.origin.x = self.thumbOnPosition;
                                              self.switchThumb.frame = thumbFrame;
                                          }completion:^(BOOL finished){
                                              self.userInteractionEnabled = YES;
                                          }];
                     }];
}

- (void)changeThumbStateOFFwithAnimation
{
    // switch movement animation
    [UIView animateWithDuration:0.15f
                          delay:0.05f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect thumbFrame = self.switchThumb.frame;
                         thumbFrame.origin.x = self.thumbOffPosition-3.0f;
                         self.switchThumb.frame = thumbFrame;
                         if (self.isEnabled == YES) {
                             self.switchThumb.backgroundColor = self.OffColor;
                             self.track.backgroundColor = self.OffColor;
                         }
                         else {
                             self.switchThumb.backgroundColor = self.OffColor;
                             self.track.backgroundColor = self.OffColor;
                         }
                         self.userInteractionEnabled = NO;
                     }
                     completion:^(BOOL finished){
                         // change state to OFF
                         if (self.isOn == YES) {
                             self.isOn = NO; // Expressly put this code here to change surely and send action correctly
                             [self sendActionsForControlEvents:UIControlEventValueChanged];
                         }
                         self.isOn = NO;
                         [UIView animateWithDuration:0.15f
                                          animations:^{
                                              // Bounce to the position
                                              CGRect thumbFrame = self.switchThumb.frame;
                                              thumbFrame.origin.x = self.thumbOffPosition;
                                              self.switchThumb.frame = thumbFrame;
                                          }
                                          completion:^(BOOL finished){
                                              self.userInteractionEnabled = YES;
                                          }];
                     }];
}


// Without animation
- (void)changeThumbStateONwithoutAnimation
{
    CGRect thumbFrame = self.switchThumb.frame;
    thumbFrame.origin.x = self.thumbOnPosition;
    self.switchThumb.frame = thumbFrame;
    if (self.isEnabled == YES) {
        self.switchThumb.backgroundColor = self.OnColor;
        self.track.backgroundColor = self.TrackOnColor;
    }
    else {
        self.switchThumb.backgroundColor = self.OffColor;
        self.track.backgroundColor = self.OffColor;
    }
    
    if (self.isOn == NO) {
        self.isOn = YES;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    self.isOn = YES;
}

- (void)changeThumbStateOFFwithoutAnimation
{
    CGRect thumbFrame = self.switchThumb.frame;
    thumbFrame.origin.x = self.thumbOffPosition;
    self.switchThumb.frame = thumbFrame;
    if (self.isEnabled == YES) {
        self.switchThumb.backgroundColor = self.OffColor;
        self.track.backgroundColor = self.OffColor;
    }
    else {
        self.switchThumb.backgroundColor = self.OffColor;
        self.track.backgroundColor = self.OffColor;
    }
    
    if (self.isOn == YES) {
        self.isOn = NO;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    self.isOn = NO;
}


//initialize ripple effect
- (void)initializeRipple {
    
    self.rippleLayer = [CAShapeLayer layer];
    float rippleScale = 2;
    CGRect rippleFrame = CGRectZero;
    rippleFrame.origin.x = -self.switchThumb.frame.size.width / (rippleScale * 2);
    rippleFrame.origin.y = -self.switchThumb.frame.size.height / (rippleScale * 2);
    rippleFrame.size.width = self.switchThumb.frame.size.width * rippleScale;
    rippleFrame.size.height = rippleFrame.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rippleFrame cornerRadius:self.switchThumb.layer.cornerRadius*2];
    self.rippleLayer.path = path.CGPath;
    self.rippleLayer.frame = rippleFrame;
    self.rippleLayer.opacity = 0.2;
    self.rippleLayer.strokeColor = [UIColor clearColor].CGColor;
    self.rippleLayer.fillColor = self.RippleColor.CGColor;
    self.rippleLayer.lineWidth = 0;
    
    [self.switchThumb.layer insertSublayer:self.rippleLayer below:self.switchThumb.layer];
    
}

- (void)animateRippleEffect {
    if (self.rippleLayer == nil){
        [self initializeRipple];
    }
    
    // begain animation
    self.rippleLayer.opacity = 0.0;
    [CATransaction begin];
    
    // remove animation
    [CATransaction setCompletionBlock:^{
        [self.rippleLayer removeFromSuperlayer];
        self.rippleLayer = nil;
    }];
    
    //scale ripple
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.5];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.25];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @0.4;
    alphaAnimation.toValue = @0;
    
    // group animation
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation , alphaAnimation];
    animation.duration = 0.4f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.rippleLayer addAnimation:animation forKey:nil];
    [CATransaction commit];
}



- (void)onTouchDown:(UIButton*)btn withEvent:(UIEvent*)event
{
    // NSLog(@"touchDown called");
    if ([self.delegate respondsToSelector:@selector(SwitchStateChanged:)]){
        NSLog(@"taped");
        if (self.isOn == YES){
            [self.delegate SwitchStateChanged:DSAnimationSwitchStateOff];
        }else{
            [self.delegate SwitchStateChanged:DSAnimationSwitchStateOn];
        }
    }
    
    
    // Animate for appearing ripple circle when tap and hold the switch thumb
    [CATransaction begin];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @0;
    alphaAnimation.toValue = @0.2;
    
    // Do above animations at the same time with proper duration
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 0.4f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.rippleLayer addAnimation:animation forKey:nil];
    
    [CATransaction commit];
    //  NSLog(@"Ripple end pos: %@", NSStringFromCGRect(circleShape.frame));
}

// Change thumb state when touchUPInside action is detected
- (void)switchThumbTapped: (id)sender
{
    if ([self.delegate respondsToSelector:@selector(SwitchStateChanged:)]){
        NSLog(@"taped");
        if (self.isOn == YES){
            [self.delegate SwitchStateChanged:DSAnimationSwitchStateOff];
        }else{
            [self.delegate SwitchStateChanged:DSAnimationSwitchStateOn];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(SwitchStateChanged:)]) {
        if (self.isOn == YES) {
            [self.delegate SwitchStateChanged:DSAnimationSwitchStateOff];
        }
        else{
            [self.delegate SwitchStateChanged:DSAnimationSwitchStateOn];
        }
    }
    
    [self changeThumbState];
}

// Change thumb state when touchUPOutside action is detected
- (void)onTouchUpOutsideOrCanceled:(UIButton*)btn withEvent:(UIEvent*)event
{
    if ([self.delegate respondsToSelector:@selector(SwitchStateChanged:)]){
        NSLog(@"taped");
        if (self.isOn == YES){
            [self.delegate SwitchStateChanged:DSAnimationSwitchStateOff];
        }else{
            [self.delegate SwitchStateChanged:DSAnimationSwitchStateOn];
        }
    }
    
    UITouch *touch = [[event touchesForView:btn] anyObject];
    CGPoint prevPos = [touch previousLocationInView:btn];
    CGPoint pos = [touch locationInView:btn];
    float dX = pos.x-prevPos.x;
    
    //Get the new origin after this motion
    float newXOrigin = btn.frame.origin.x + dX;
    //NSLog(@"Released tap X pos: %f", newXOrigin);
    
    if (newXOrigin > (self.frame.size.width - self.switchThumb.frame.size.width)/2) {
        //NSLog(@"thumb pos should be set *ON*");
        [self changeThumbStateONwithAnimation];
    }
    else {
        //NSLog(@"thumb pos should be set *OFF*");
        [self changeThumbStateOFFwithAnimation];
    }
    
    if (self.isRippleEnabled == YES) {
        [self animateRippleEffect];
    }
}

// Drag the switch thumb
- (void)onTouchDragInside:(UIButton*)btn withEvent:(UIEvent*)event
{
    if ([self.delegate respondsToSelector:@selector(SwitchStateChanged:)]){
        NSLog(@"taped");
        if (self.isOn == YES){
            [self.delegate SwitchStateChanged:DSAnimationSwitchStateOff];
        }else{
            [self.delegate SwitchStateChanged:DSAnimationSwitchStateOn];
        }
    }
    
    UITouch *touch = [[event touchesForView:btn] anyObject];
    CGPoint prevPos = [touch previousLocationInView:btn];
    CGPoint pos = [touch locationInView:btn];
    float dX = pos.x-prevPos.x;
    
    //Get the original position of the thumb
    CGRect thumbFrame = btn.frame;
    
    thumbFrame.origin.x += dX;
    //Make sure it's within two bounds
    thumbFrame.origin.x = MIN(thumbFrame.origin.x,self.thumbOnPosition);
    thumbFrame.origin.x = MAX(thumbFrame.origin.x,self.thumbOffPosition);
    
    //Set the thumb's new frame if need to
    if(thumbFrame.origin.x != btn.frame.origin.x) {
        btn.frame = thumbFrame;
    }
}












@end
