//
//  ViewController2.m
//  RunLoop
//
//  Created by JianfengXu on 2019/11/10.
//  Copyright © 2019 JianfengXu. All rights reserved.
//  Observe观察者 观察RunLoop本身

#import "ViewController2.h"
//定义一个block
typedef void(^RunLoopBlock)(void);

static NSString *IDENTIFIER = @"IDENTIFIER";
static CGFloat CELL_HEIGHT = 135.f;

@interface ViewController2 ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *myTableView;
//装任务的数组
@property (nonatomic, strong) NSMutableArray *tasks;
//最大任务数
@property (nonatomic,assign)NSUInteger maxQueueLength;

@property (nonatomic,assign) NSTimer *timer;

@end

@implementation ViewController2

- (void)timerMethod{
    //什么都不做目的只是叫RunLoop有事情做
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self addRunLoopObserver];
    
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:IDENTIFIER];
    
    _tasks = [NSMutableArray array];
    _maxQueueLength = 25;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];

}
//MARK 内部实现方法

//添加文字
+(void)addLabel:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 300, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"Runloop优化TableView实现监听原理%ld",(long)indexPath.row];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.tag = 0;
    [cell.contentView addSubview:label];
    
}
//加载第一张图片
+(void)addImage1With:(UITableViewCell *)cell{
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30, 85, 85)];
    imageView1.tag = 1;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"20121024114828_TtcQe" ofType:@"jpeg"];
    UIImage *image1 = [UIImage imageWithContentsOfFile:path1];
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    imageView1.image = image1;
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView1];
    } completion:nil];
}
//加载第二张图片
+(void)addImage2With:(UITableViewCell *)cell{
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(105, 30, 85, 85)];
    imageView2.tag = 2;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"20121024114828_TtcQe" ofType:@"jpeg"];
    UIImage *image2 = [UIImage imageWithContentsOfFile:path1];
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    imageView2.image = image2;
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView2];
    } completion:nil];
}
//加载第三张图片
+(void)addImage3With:(UITableViewCell *)cell{
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(200, 30, 85, 85)];
    imageView3.tag = 3;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"20121024114828_TtcQe" ofType:@"jpeg"];
    UIImage *image3 = [UIImage imageWithContentsOfFile:path1];
    imageView3.contentMode = UIViewContentModeScaleAspectFit;
    imageView3.image = image3;
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView3];
    } completion:nil];
}
//MARK 初始化方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.myTableView.frame = self.view.bounds;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

-(void)loadView{
    self.view = [UIView new];
    self.myTableView = [UITableView new];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    
}

#pragma Mark -<tableView>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 500;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //清除掉contentView上面的子控件 节约内存
    for (NSInteger i = 1; i<=5; i++) {
        [[cell.contentView viewWithTag:i] removeFromSuperview];
    }
    //添加文字
    [ViewController2 addLabel:cell indexPath:indexPath];
    //添加图片
    [self addTask:^{
        [ViewController2 addImage1With:cell];
    }];
    [self addTask:^{
        [ViewController2 addImage2With:cell];
    }];
    [self addTask:^{
        [ViewController2 addImage3With:cell];
    }];
   
    return cell;
}
#pragma MARK - <关于RunLoop的代码>

- (void)addTask:(RunLoopBlock)task{
    [self.tasks addObject:task];
    if (self.tasks.count >self.maxQueueLength) {
        //干掉最开始的任务
        [self.tasks removeObjectAtIndex:0];
    }
    
}

static void Callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    NSLog(@"哥们来了但并不会消耗CPU");
    //取出任务执行
   ViewController2 *vc = (__bridge ViewController2 *)info;
    if (vc.tasks.count == 0) {
        return;
    }
    //取出一个任务
    RunLoopBlock task = vc.tasks.firstObject;
    task();
    [vc.tasks removeObjectAtIndex:0];
    
}

//以下代码C语言  高级程序员话题
//添加RunLoop
- (void)addRunLoopObserver{
    //拿到当前RunLoop
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    //定义一个上下文
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    //定义一个观察者
    CFRunLoopObserverRef defaultModeObserver;
    //创建一个观察者
    defaultModeObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopAfterWaiting, YES, 0, &Callback, &context);
    //添加RunLoop的观察者 kCFRunLoopDefaultMode拖拽时展示
    CFRunLoopAddObserver(runLoop, defaultModeObserver, kCFRunLoopCommonModes);
    
    CFRelease(defaultModeObserver);
}






@end
