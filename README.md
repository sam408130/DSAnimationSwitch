# DSAnimationSwitch

###DEMO
[简书](http://www.jianshu.com/p/241965005ba9)

![](https://github.com/sam408130/DSAnimationSwitch/blob/master/demo.gif)


###Usage

```
  DSAnimationSwitch *mySwitch = [DSAnimationSwitch alloc] init];
  mySwith.delegate = self;
  
  or 
  
  DSAnimationSwitch *mySwitch = [DSAnimationSwitch alloc] initWithSize:DSAnmationSwitchSizeBig state:DSAnimationSwitchStateOn];
  
  typedef enum{
    DSAnimationSwitchStateOn,
    DSAnimationSwitchStateOff
  } DSAnimationSwitchState;


  typedef enum{
    DSAnimationSwitchSizeBig,
    DSAnimationSwitchSizeSmall,
    DSAnimationSwitchSizeNormal
  } DSAnimationSwitchSize;
  
  
  #delegate
  
  - (void)SwitchStateChanged:(DSAnimationSwitchState)currentState {
    if (currentState == 1){
        self.label.text = @"关";
        self.label.textColor = [UIColor grayColor];
    }else{
        self.label.text = @"开";
        self.label.textColor = [UIColor colorWithRed:47.0/255.0 green:163.0/255.0 blue:220.0/255.0 alpha:1.0];
    }
}
```

###TODO
* 改变颜色接口
* 更多订制颜色
