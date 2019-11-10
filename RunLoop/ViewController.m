//
//  ViewController.m
//  RunLoop
//
//  Created by JianfengXu on 2019/11/9.
//  Copyright © 2019 JianfengXu. All rights reserved.
// RunLoop运行循环 是一个死循环  目前iOS开发中几乎用不到
/* 目的：
 1.保证程序不退出
 2.负责监听事件 触摸 时钟 网络事件
 3.RunLoop非常懒惰，做完一件事情就会休息
 4.处理三样东西 Source Observer Timer
 5.子线程的RunLoop循环默认是不开启的
 **/

//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,assign)BOOL finished;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _finished = NO;
    
    //默认将Timer加入TRunLoop
  //  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeMethod) userInfo:nil repeats:YES];
  
    
    
    //放入子线层
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSTimer *timer =  [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeMethod) userInfo:nil repeats:YES];
           //共五种模式 只会用到三种  其余两种程序初始化时会用到 处理特殊事件
           //NSDefaultRunLoopMode 在UI交互时卡顿 默认模式只要有事件就处理
           //UITrackingRunLoopMode （有限切换）UI交互时触发此种模式
           //NSRunLoopCommonModes 占位模式 （默认下和UITrack模式下运行）
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
       // [[NSRunLoop currentRunLoop] run];//跑起来 执行这行代码出现死循环 将模式置换为NSDefaultRunLoopMode 自己添加一个循环条件
        while (self.finished) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0.01]];
        }
        
        
        NSLog(@"来了%@",[NSThread currentThread]);

    });
  
    
}
//如果Timer有耗时操作 阻塞主线程 需要放到子线程
-(void)timeMethod{
    NSLog(@"come here");
    //睡一觉
    [NSThread sleepForTimeInterval:1.0];
    if (_finished) {
        [NSThread exit];
        NSLog(@"让当前线程挂掉,挂掉得是子线程");
    }
    
    
    static int num = 0;
    NSLog(@"%@ %d",[NSThread currentThread],num++);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _finished = NO;
    
    //主线程可以被干掉
   // [NSThread exit];
}

@end
