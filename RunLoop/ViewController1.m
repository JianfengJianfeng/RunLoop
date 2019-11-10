//
//  ViewController1.m
//  RunLoop
//
//  Created by JianfengXu on 2019/11/10.
//  Copyright © 2019 JianfengXu. All rights reserved.
//  GCD封装好的RunLoop 处理source事件


#import "ViewController1.h"

@interface ViewController1 ()

@property(nonatomic,strong)dispatch_source_t timer;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //source事件源（输入源）
    /*按照函数调用栈source分为两种
     source0:
     source1:内核事件 （线程通讯事件等」
     */
    
    //GCD的定时器
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    //设置定时器
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC, 0);
    //设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"%@------",[NSThread currentThread]);
    });
    dispatch_resume(self.timer);

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

@end
