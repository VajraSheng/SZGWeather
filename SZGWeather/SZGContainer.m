//
//  SZGContainer.m
//  SZGWeather
//
//  Created by 盛振国 on 15/5/30.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "SZGContainer.h"

@interface SZGContainer () <UIGestureRecognizerDelegate>

@property (nonatomic) BOOL isSideViewShowing;


@end

@implementation SZGContainer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)awakeFromNib
{
    [self load];
}

#pragma mark - Layout
- (void)load
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    _sideController = (SZGSideController *)[storyboard instantiateViewControllerWithIdentifier:@"side"];
    _sideController.containerController = self;
    [self.view addSubview:_sideController.view];
    [_sideController.view setTag:2];
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.85, self.view.bounds.size.height);
    [_sideController.view setFrame:frame];
    
    _mainController = (SZGPageController *)[storyboard instantiateViewControllerWithIdentifier:@"main"];
    _mainController.containerController = self;
    
    [self.view addSubview:_mainController.view];
    [_mainController.view setTag:1];
    [_mainController.view setFrame:self.view.bounds];
    
    [self.view bringSubviewToFront:_mainController.view];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.delegate = self;
    [_mainController.view addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    panGesture.delegate = self;
    [_mainController.view addGestureRecognizer:panGesture];
}

#pragma mark - Methods of Gestures

- (void)panGesture:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (!_isSideViewShowing) {
        //only first page of PageController can use this pan gesture
        if (![_mainController isFirstPage]) {
            return;
        }
    }
    //when the side view is showing , all pages of PageController can pan 
    static CGFloat currentTranslateX;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        currentTranslateX = _mainController.view.transform.tx;
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat transX = [panGestureRecognizer translationInView:_mainController.view].x;
        transX = transX + currentTranslateX;
        if (transX < 0) {
            return;
        }
        if (transX > 250) {
            return;
        }
        CGAffineTransform transform = CGAffineTransformMakeTranslation(transX, 0);
        _mainController.view.transform = transform;
    }else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat panX = [panGestureRecognizer translationInView:_mainController.view].x;
        CGFloat finalX = currentTranslateX + panX;
        CGFloat middle = self.view.bounds.size.width / 2;
        if (finalX <= middle) {
            [self hideSideView];
        }else
            [self showSideView];
    }
    
}

- (void)tapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self hideSideView];
}

-(void) swipeGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
  
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if ([_mainController isFirstPage]) {
            [self showSideView];
        }
        
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Control side view's hidden
- (void)showSideView
{
    [_sideController.view setHidden:NO];
    CALayer *layer = [_mainController.view layer];
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowOpacity = 1;
    layer.shadowRadius = 20.0;
    [UIView animateWithDuration:1 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width * 0.85, 0);
        _mainController.view.transform = transform;
    } completion:^(BOOL finished) {
        _mainController.scrollView.scrollEnabled = NO;
        _isSideViewShowing = YES;
    }];
    
    
}

- (void)hideSideView
{
    [UIView animateWithDuration:1 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);
        _mainController.view.transform = transform;
    } completion:^(BOOL finished) {
        _mainController.scrollView.scrollEnabled = YES;
        _isSideViewShowing = NO;
        // 最后调用防止出现白底
        [_sideController.view setHidden:YES];
    }];
    
    
}


#pragma mark - When side view editing ,show the side view full screen.
- (void)changeEditTableToFullScreen
{
    self.sideController.view.frame = self.view.bounds;
    [_mainController.view setHidden:YES];
}

- (void)endEditTable
{
    self.sideController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.85, self.view.bounds.size.height);
    [_mainController.view setHidden:NO];
}


#pragma mark - reload of subviews
- (void)reload
{
    [self load];
    [self.mainController gotoTheLastPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
