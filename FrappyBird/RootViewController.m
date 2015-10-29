//
//  RootViewController.m
//  FrappyBird
//
//  Created by lanou3g on 15/8/22.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UIAlertViewDelegate>
@property (nonatomic,retain) UIImageView *ground;
@property (nonatomic,retain) UIImageView *bird;
@property (nonatomic,retain) UIImageView *list;
@property (nonatomic,retain) UILabel *scoreLB;
@property (nonatomic,retain) UILabel *first;
@property (nonatomic,retain) UILabel *second;
@property (nonatomic,retain) UILabel *third;
@property (nonatomic,retain) UIButton *gameButton;
@property (nonatomic,retain) NSMutableArray *barrierUpGroup;
@property (nonatomic,retain) NSMutableArray *barrierDownGroup;
@property (nonatomic,retain) NSTimer *birdTime;
@property (nonatomic,retain) NSTimer *moveBarrierTime;
@property (nonatomic,retain) NSTimer *createBarrierTime;
@property (nonatomic,retain) NSTimer *scoreTime;
@property (nonatomic,assign) CGPoint moveBarrier;
@property (nonatomic,assign) CGPoint birdUp;
@property (nonatomic,assign) CGPoint birdDown;
@property (nonatomic,assign) NSInteger score;
@end
@implementation RootViewController
-(void)dealloc
{
    self.ground = nil;
    self.bird = nil;
    self.gameButton = nil;
    self.barrierUpGroup = nil;
    self.barrierDownGroup = nil;
    self.list = nil;
    self.scoreLB = nil;
    self.first = nil;
    self.second = nil;
    self.third = nil;
    self.birdTime = nil;
    self.moveBarrierTime = nil;
    self.createBarrierTime = nil;
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //布局排行榜
    [self layoutList];
}
//游戏开始
-(void)beginGame:(UIButton *)button
{
    NSLog(@"aaaa");
    //布局背景
    [self layoutGround];
    //布局记分牌
    [self layoutScore];
    //布局小鸟
    [self layoutBird];
    //布局障碍物
    [self layoutBarrier];
    //布局游戏操控
    [self layoutGameButton];
    [self.view sendSubviewToBack:_list];
}
//布局排行榜
-(void)layoutList
{
    self.list = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
    _list.center = CGPointMake(375/2, 667/2);
    _list.backgroundColor = [UIColor redColor];
    [self.view addSubview:_list];
    [_list release];
    UIButton *game = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    game.center = CGPointMake(150, 470);
    game.backgroundColor = [UIColor yellowColor];
    [game setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    [game addTarget:self action:@selector(beginGame:) forControlEvents:UIControlEventTouchUpInside];
    _list.userInteractionEnabled = YES;
    [_list addSubview:game];
    [game release];
    
    self.first = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 100, 30)];
    _first.text = [NSString stringWithFormat:@"%ld",_score];
    [_list addSubview:_first];
    [_first release];
    
    self.second = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 100, 30)];
    _second.text = [NSString stringWithFormat:@"%ld",_score];
    [_list addSubview:_second];
    [_second release];
    
    self.third = [[UILabel alloc]initWithFrame:CGRectMake(20, 140, 100, 30)];
    _third.text = [NSString stringWithFormat:@"%ld",_score];
    [_list addSubview:_third];
    [_third release];
    
}
//布局背景
-(void)layoutGround
{
    self.score = 0;
    self.ground = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.ground.image = [UIImage imageNamed:@"ground.jpg"];
    _ground.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_ground];
    [_ground release];
}
//布局记分牌
-(void)layoutScore
{
    self.scoreLB = [[UILabel alloc]initWithFrame:CGRectMake(375/2, 20, 200, 30)];
    _scoreLB.text = [NSString stringWithFormat:@"%ld",_score];
    _scoreLB.font = [UIFont systemFontOfSize:20];
    [self.ground addSubview:_scoreLB];
    [_scoreLB release];
}
//布局小鸟
-(void)layoutBird
{
    self.birdDown = CGPointMake(0, 5);
    self.birdUp = CGPointMake(0, 20);
    self.bird = [[UIImageView alloc]initWithFrame:CGRectMake(30, 300, 30,30)];
    _bird.image = [UIImage imageNamed:@"down@2x.png"];
    _bird.backgroundColor = [UIColor redColor];
    [self.ground addSubview:_bird];
    [_bird release];
    self.birdTime = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(downBird:) userInfo:nil repeats:YES];
    [_birdTime fire];
    
}
//布局障碍物
-(void)layoutBarrier
{
    self.moveBarrier = CGPointMake(20, 0);
    self.barrierUpGroup = [NSMutableArray array];
    self.barrierDownGroup = [NSMutableArray array];
    self.createBarrierTime = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(createBarrier:) userInfo:nil repeats:YES];
    [_createBarrierTime fire];
    
    self.moveBarrierTime  = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(moveBarrier:) userInfo:nil repeats:YES];
    [_moveBarrierTime fire];
}
//布局游戏操控
-(void)layoutGameButton
{
    self.gameButton = [[UIButton alloc]initWithFrame:self.view.bounds];
    [self.gameButton addTarget:self action:@selector(flappyBird:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_gameButton];
    [_gameButton release];
}
//生成障碍物
-(void)createBarrier:(NSTimer *)time
{
    if (self.barrierUpGroup.count > 1) {
        _score ++;
        _scoreLB.text = [NSString stringWithFormat:@"%ld",_score];
    }
    //上障碍物
    NSInteger a = arc4random()%(400 - 200 + 1)+200;
    UIImageView *barrierUp = [[UIImageView alloc]initWithFrame:CGRectMake(300, 0, 50, a)];
    barrierUp.backgroundColor = [UIColor lightGrayColor];
    barrierUp.image = [UIImage imageNamed:@"barrierUp.jpg"];
    [self.barrierUpGroup addObject:barrierUp];
    [self.ground addSubview:barrierUp];
    [barrierUp release];
    //下障碍物
    UIImageView *barrierDown =[[UIImageView alloc]initWithFrame:CGRectMake(300, a+80, 50, 667-(a + 80))];
    barrierDown.backgroundColor = [UIColor lightGrayColor];
    barrierDown.image = [UIImage imageNamed:@"barrierDown.jpg"];
    [self.barrierDownGroup addObject:barrierDown];
    [self.ground addSubview:barrierDown];
    [barrierDown release];
}
//移动障碍物
-(void)moveBarrier:(NSTimer *)time
{
    

    for (UIImageView *barrierUp in self.barrierUpGroup)
    {
        barrierUp.center = CGPointMake(barrierUp.center.x - self.moveBarrier.x, barrierUp.center.y - self.moveBarrier.y);
        if (_bird.frame.origin.x+20 > barrierUp.frame.origin.x && _bird.frame.origin.x < barrierUp.frame.origin.x+50 && _bird.frame.origin.y < barrierUp.frame.size.height  ) {
            [self gameOver];
        }
    }
    for (UIImageView *barrierDown in self.barrierDownGroup) {
        barrierDown.center = CGPointMake(barrierDown.center.x - self.moveBarrier.x, barrierDown.center.y - self.moveBarrier.y);
        if (_bird.frame.origin.x+20 > barrierDown.frame.origin.x && _bird.frame.origin.x < barrierDown.frame.origin.x+50 && _bird.frame.origin.y+20 > barrierDown.frame.origin.y  ) {
            [self gameOver];
        }

    }
    
}
//小鸟下降
-(void)downBird:(NSTimer *)time
{
    _bird.image = [UIImage imageNamed:@"up@2x.png"];
    self.bird.center = CGPointMake(self.bird.center.x + self.birdDown.x, self.bird.center.y + self.birdDown.y);
    if (self.bird.center.y > 667) {
        [self gameOver];
    }
}
//小鸟上飞
-(void)flappyBird:(UIButton *)button
{
    _bird.image = [UIImage imageNamed:@"up@2x.png"];
    self.bird.center = CGPointMake(self.bird.center.x - _birdUp.x, self.bird.center.y - _birdUp.y);
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.view bringSubviewToFront:_list];
    }
}
//游戏结束
-(void)gameOver;
{
    [_gameButton removeTarget:self action:@selector(flappyBird:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableArray *scoreArr = [NSMutableArray arrayWithObjects:_first.text,_second.text,_third.text, nil];
    [scoreArr addObject:[NSString stringWithFormat:@"%ld",_score]];
    [scoreArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        NSInteger num1 = [str1 integerValue];
        NSInteger num2 = [str2 integerValue];
        if (num1 > num2) {
            return NSOrderedAscending;
        }else if (num1 < num2)
        {
            return NSOrderedDescending;
        }else return NSOrderedSame;
    }];
    _first.text = scoreArr[0];
    _second.text = scoreArr[1];
    _third.text = scoreArr[2];
    [_birdTime invalidate];
    [_createBarrierTime invalidate];
    [_moveBarrierTime invalidate];
    UIAlertView * worning = [[UIAlertView alloc]initWithTitle:@"警告" message:@"你输了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [worning show];
    [_ground addSubview:worning];
    [worning release];
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
