//
//  ViewController.m
//  Facebook_Pop动画
//
//  Created by 欢欢 on 16/1/11.
//  Copyright © 2016年 Charles_Wl. All rights reserved.
//

#import "ViewController.h"
#import <POP.h>
@interface ViewController ()
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIButton *springView;
@property (nonatomic, strong)UIView *basicView;
@property (nonatomic, strong)UIView *sprView;
@property (nonatomic, strong)UIView *decaryView;
@property (nonatomic)NSInteger buttonTag;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //POP的衰减动画事例
    //[self popWithDecayAnimation];
    //POP的衰减动画事例
    //[self popWithSpringAnimation];
    //POP的所有动画事例
    [self popWithAllAnimation];
}

/**POP的所有动画事例*/
- (void)popWithAllAnimation {
    
    _basicView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-70)];
    _basicView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_basicView];
    
    _sprView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-70)];
    _sprView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_sprView];
    
    _decaryView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-70)];
    _decaryView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_decaryView];
    //基本动画
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    basicAnimation.toValue = @(self.basicView.center.x + 300);
    basicAnimation.beginTime = CACurrentMediaTime() + 1.0;
    [_basicView pop_addAnimation:basicAnimation forKey:nil];
    //弹簧动画
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    springAnimation.toValue = @(self.basicView.center.x + 300);
    springAnimation.beginTime = CACurrentMediaTime() + 1.0;
    //弹力[0,20]
    springAnimation.springBounciness = 10.0;
    //速度[0,20]
    //springAnimation.springSpeed = 0.0;
    //[_sprView pop_addAnimation:springAnimation forKey:nil];
    //衰减动画
    POPDecayAnimation *decayAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    //加速度
    decayAnimation.velocity = @(600);
    decayAnimation.beginTime = CACurrentMediaTime() + 1.0;
    //[_decaryView pop_addAnimation:decayAnimation forKey:nil];
}

/**POP的弹簧动画事例*/
- (void)popWithSpringAnimation {
    
    self.springView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.springView.backgroundColor = [UIColor redColor];
    self.springView.center = self.view.center;
    [self.view addSubview:self.springView];
    [self.springView addTarget:self action:@selector(springAnimation:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)springAnimation:(UIButton *)button {
    [self.springView.layer removeAllAnimations];
    [self.springView.layer pop_removeAllAnimations];
    self.buttonTag ++ ;
    if (self.buttonTag%2) {
        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
        springAnimation.springSpeed = 0;
        springAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
        [self.springView.layer pop_addAnimation:springAnimation forKey:nil];
    } else {
        
        //基本动画
        CABasicAnimation *springAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        springAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
        springAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
        [self.springView.layer addAnimation:springAnimation forKey:nil];
        self.springView.bounds = CGRectMake(0, 0, 50, 50);
    }
    
}

/**POP的衰减动画事例*/
- (void)popWithDecayAnimation {
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.button.backgroundColor = [UIColor blueColor];
    self.button.layer.cornerRadius = 50;
    self.button.center = self.view.center;
    [self.button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didClickOnPanGesture:)];
    [self.button addGestureRecognizer:panGesture];
}

- (void)buttonEvent:(UIButton *)btn {
    [btn.layer pop_removeAllAnimations];
}

- (void)didClickOnPanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint gesture = [panGesture translationInView:self.view];
    panGesture.view.center = CGPointMake(panGesture.view.center.x + gesture.x, panGesture.view.center.y + gesture.y);
    [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        //获取加速度
        CGPoint velocity = [panGesture velocityInView:self.view];
        
        //初始化POP的衰减动画
        POPDecayAnimation *decayAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        decayAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        [panGesture.view.layer pop_addAnimation:decayAnimation forKey:nil];
    }
    
}

#pragma mark - 按钮响应事件 -

- (IBAction)clickOnRedView:(UIButton *)sender {
    _basicView.hidden = YES;
    _sprView.hidden = YES;
    _decaryView.hidden = YES;
    [self popAnimationWith:_basicView];
}

- (IBAction)clickOnYellowView:(UIButton *)sender {
    _basicView.hidden = YES;
    _sprView.hidden = YES;
    _decaryView.hidden = YES;
    [self popAnimationWith:_sprView];
}

- (IBAction)clickOnGreenView:(UIButton *)sender {
    _basicView.hidden = YES;
    _sprView.hidden = YES;
    _decaryView.hidden = YES;
    [self popAnimationWith:_decaryView];
}

- (void)popAnimationWith:(UIView *)object {
    object.hidden = NO;
    CGFloat x = [UIScreen mainScreen].bounds.size.width;
    CGFloat y = [UIScreen mainScreen].bounds.size.height;
    object.frame = CGRectMake(x, 0, x, y - 70);
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    springAnimation.toValue = @(object.center.x - ([UIScreen mainScreen].bounds.size.width));
    springAnimation.beginTime = CACurrentMediaTime();
    //弹力[0,20]
    springAnimation.springBounciness = 8.0;
    [object pop_addAnimation:springAnimation forKey:nil];
}
@end
