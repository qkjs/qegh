//
//  ViewController.m
//  企鹅过河
//
//  Created by Bernie Suen on 15/8/12.
//  Copyright (c) 2015年 Bernie Suen. All rights reserved.
//

#import "ViewController.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#define viewColor [UIColor blackColor];

@interface ViewController ()

#pragma mark - 设置属性
@property (nonatomic, strong) UIView *zxSkyView;
@property (nonatomic, strong) UIView *zxSeaView;
@property (nonatomic, strong) UIView *zxLeftView;
@property (nonatomic, strong) UIView *zxCenterView;
@property (nonatomic, strong) UIView *zxRightView;

@property (nonatomic, strong) UIButton *zxRePlayButton;
@property (nonatomic, strong) UILabel *zxScoreLab;

@property (nonatomic, strong) UIImageView *zxIcon;
@property (nonatomic, strong) UIView *zxWoodView;
@property (nonatomic, strong) CADisplayLink *zxTimer;
@property (nonatomic, assign) BOOL touchEnabled;



#pragma mark - 几个重要的点
#pragma mark
#define leftViewLocalX 40
#define leftViewLocalY screenH/3 * 2 - 40

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [self zxSkyView];
    [self zxSeaView];
    [self zxLeftView];
    [self reSetIconFream];
    [self zxRePlayButton];
    [self zxScoreLab];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -lasyload

- (UIView *) zxSkyView {
    if (!_zxSkyView) {
        _zxSkyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH/3 * 2)];
        _zxSkyView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_zxSkyView];
    }
    return _zxSkyView;
}

- (UIView *) zxSeaView {
    if (!_zxSeaView) {
        _zxSeaView = [[UIView alloc] initWithFrame:CGRectMake(0, screenH/3 * 2, screenW, screenH/3)];
        _zxSeaView.backgroundColor = [UIColor cyanColor];
        [self.view addSubview:_zxSeaView];
    }
    return _zxSkyView;
}

- (UIView *) zxLeftView {
    if (!_zxLeftView) {
        _zxLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, screenH/3 * 2 - leftViewLocalX, leftViewLocalX, screenH -  (leftViewLocalY))];
        _zxLeftView.backgroundColor = viewColor;
        [self.view addSubview:_zxLeftView];
    }
    return _zxLeftView;
}

- (UIView *) zxCenterView {
    if (!_zxCenterView) {
        _zxCenterView = [[UIView alloc] initWithFrame:[self zxInitTheView]];
        _zxCenterView.backgroundColor = viewColor;
        [_zxCenterView bringSubviewToFront:self.zxSeaView];
        [self.view addSubview:_zxCenterView];
    }
    return _zxCenterView;
}

- (UIView *) zxRightView {
    if (!_zxRightView) {
        
        _zxRightView = [[UIView alloc] init];
        _zxRightView.backgroundColor = viewColor;
        [_zxRightView bringSubviewToFront:self.view];
        [self.zxIcon bringSubviewToFront:self.view];
        
        [self.view addSubview:_zxRightView];
    }
    return _zxRightView;
}

- (UIView *) zxWoodView {
    if (!_zxWoodView) {
        
        _zxWoodView = [[UIView alloc] init];
        _zxWoodView.backgroundColor = [UIColor blackColor];
        _zxWoodView.layer.anchorPoint = CGPointMake(0.0,1.0);
        [_zxWoodView bringSubviewToFront:self.view];
        [self.view addSubview:_zxWoodView];
    }
    return _zxWoodView;
}

- (UILabel *) zxScoreLab{
    if (!_zxScoreLab) {
        _zxScoreLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, screenW, 60)];
        _zxScoreLab.textAlignment = NSTextAlignmentCenter;
        _zxScoreLab.textColor = [UIColor blackColor];
        _zxScoreLab.numberOfLines = 0;
        _zxScoreLab.text = @"0";
        [self.view addSubview:_zxScoreLab];
    }
    return _zxScoreLab;
}

- (UIButton *) zxRePlayButton{
    if (!_zxRePlayButton) {
        _zxRePlayButton = [UIButton buttonWithType:UIButtonTypeSystem];
        CGFloat ButtonW = 150;
        CGFloat ButtonH = 50;
        _zxRePlayButton.bounds = CGRectMake(0, 0, ButtonW, ButtonH);
        _zxRePlayButton.center = CGPointMake(self.view.center.x, self.view.center.y * 0.75);
        [_zxRePlayButton setTitle:@"点击开始" forState:UIControlStateNormal];
        [_zxRePlayButton bringSubviewToFront:self.view];
        [_zxRePlayButton setBackgroundColor:[UIColor redColor]];
        
        [_zxRePlayButton addTarget:self action:@selector(zxInitTheGame) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_zxRePlayButton];
    }
    return _zxRePlayButton;
}

- (UIImageView *) zxIcon{
    if (!_zxIcon) {
        _zxIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon"]];
        [self.view addSubview:_zxIcon];
    }
    return _zxIcon;
}

#pragma mark - 初始化

- (void) zxInitTheGame{
    if (self.zxCenterView) {
        self.zxCenterView.backgroundColor = [UIColor clearColor];
        self.zxCenterView = nil;
    }
    self.touchEnabled  = YES;
    [self.zxRePlayButton setHidden:YES];
    self.zxScoreLab.text = @"0";

    [self zxInitWood];
    [self zxLeftView];
    [self zxCenterView];
    [self zxRightView];
    [self reSetIconFream];
}

- (void) zxInitWood{
    //初始化 木棒位置
    
    CGFloat woodW = 4.0;
    CGFloat woodH = 4.0;
    CGFloat woodY = leftViewLocalY - woodH;
    CGFloat woodX = leftViewLocalX ;
    
    self.zxWoodView.frame = CGRectMake(woodX, woodY, woodW, woodH);
    
    //初始化旋转View
    self.zxWoodView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
}

//随机生成一个view的位置
- (CGRect) zxInitTheView{
    
    NSInteger cW = screenW - leftViewLocalX - screenW * 0.8;
    CGFloat w =  (arc4random() % cW) + 20;
    
    NSInteger cX = screenW - leftViewLocalX - 20 - w;
    NSInteger x = (arc4random() % cX) + leftViewLocalX + 20;
    
    CGFloat y = leftViewLocalY;
    CGFloat h = screenH -  (leftViewLocalY);
    
    return  CGRectMake(x, y, w, h);
}

#pragma mark - 逻辑
- (void) zxWoodChangeToLong{
    CGFloat changeWood = 0.8;
    
    CGFloat x = self.zxWoodView.frame.origin.x;
    CGFloat y = self.zxWoodView.frame.origin.y - changeWood;
    CGFloat w = self.zxWoodView.frame.size.width;
    CGFloat h = self.zxWoodView.frame.size.height + changeWood;
    
    self.zxWoodView.frame = CGRectMake(x, y, w, h);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.touchEnabled) {
        [self zxInitWood];
        self.zxTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(zxWoodChangeToLong)];
        [self.zxTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.touchEnabled) {
        self.touchEnabled = NO;
        [self.zxTimer invalidate];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.zxWoodView.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        }];
        [self zxJudge];
    }
}

- (void) reSetIconFream{
    CGFloat iconW = 18;
    CGFloat iconH = 18;
    CGFloat iconX = leftViewLocalX - iconW - 1;
    CGFloat iconY = leftViewLocalY- iconH ;
    
    self.zxIcon.frame = CGRectMake(iconX, iconY, iconW, iconH);
}

#pragma mark - 判断胜负
- (void) zxJudge{
    CGFloat winMaxX = CGRectGetMaxX(self.zxCenterView.frame);
    CGFloat winMinX = CGRectGetMinX(self.zxCenterView.frame);
    CGFloat currentX = CGRectGetMaxX(self.zxWoodView.frame);
    
    NSLog(@"x:%f", currentX );
    
    if (currentX > winMinX && currentX <= winMaxX) {
        [self zxWin];
    } else {
        [self zxLost];
    }
    
}

- (void) zxWin{
    self.zxScoreLab.text = [NSString stringWithFormat:@"%d", self.zxScoreLab.text.intValue + 1 ];
    
    CGRect iconOldFream = self.zxIcon.frame;
    CGFloat iconX = CGRectGetMaxX(self.zxCenterView.frame) - iconOldFream.size.width;
    CGFloat iconY = iconOldFream.origin.y;
    CGFloat iconW = iconOldFream.size.width;
    CGFloat iconH = iconOldFream.size.height;

    
    [UIView animateWithDuration:1 animations:^{

        self.zxRePlayButton.enabled = NO;
        self.zxIcon.frame = CGRectMake(iconX, iconY, iconW, iconH);
    } completion:^(BOOL finished) {
        [self.zxWoodView setHidden:YES];
        [self zxInitWood];
        
        
        CGRect tmpRect = [self zxInitTheView];
        self.zxRightView.frame = (CGRect){{screenW, tmpRect.origin.y}, tmpRect.size};
        
        [UIView animateWithDuration:1 animations:^{
            self.zxLeftView.frame = CGRectMake(- self.zxLeftView.frame.size.width, self.zxLeftView.frame.origin.y, self.zxLeftView.bounds.size.width, self.zxLeftView.bounds.size.height);
            
            self.zxCenterView.frame = CGRectMake(leftViewLocalX - self.zxCenterView.bounds.size.width, leftViewLocalY, self.zxCenterView.bounds.size.width, self.zxCenterView.bounds.size.height);
            
            //交换中试图到左视图
            self.zxLeftView = self.zxCenterView;
            self.zxCenterView = self.zxRightView;
            
            self.zxIcon.frame = iconOldFream;
            
            self.zxRightView.frame = tmpRect;
            
            
            self.zxCenterView = self.zxRightView;
            self.zxRightView = nil;
        }completion:^(BOOL finished) {
            
            [self zxInitWood];
            [self.zxWoodView setHidden:NO];

            self.touchEnabled = YES;
            self.zxRePlayButton.enabled = YES;
        }];
    }];

}

- (void) zxLost{

    
    CGRect iconOldFream = self.zxIcon.frame;
    CGFloat iconX = CGRectGetMaxX(self.zxWoodView.frame);
    CGFloat iconY = iconOldFream.origin.y;
    CGFloat iconW = iconOldFream.size.width;
    CGFloat iconH = iconOldFream.size.height;
    
    [UIView animateWithDuration:1 animations:^{
        self.zxIcon.frame = CGRectMake(iconX, iconY, iconW, iconH);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.zxIcon.frame = CGRectMake(iconX, screenH, iconW, iconH);
            self.zxWoodView.transform = CGAffineTransformRotate(self.zxWoodView.transform, M_PI * 0.5);
        } completion:^(BOOL finished) {
            [self.zxRePlayButton setHidden:NO];
            self.zxScoreLab.text = @"一个不小心,我们可怜的小企鹅又掉下去了。点击开始，挽救我们的小企鹅!";
        }];
    }];

}

@end
