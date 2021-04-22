//
//  TTCycleContainerViewController.m
//  OCDemoGroup
//
//  Created by tangshuanghui on 2021/4/21.
//

#import "TTCycleContainerViewController.h"

@interface TTCycleContainerViewController ()

@property (nonatomic, strong) UIButton * clickButton;

@end

@implementation TTCycleContainerViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 88, self.view.bounds.size.width, 40)];
    label.text = [NSString stringWithFormat:@"当前是第%ld页", (self.index + 1)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor systemGrayColor];
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
    self.clickButton.tag = self.index;
    [self.view addSubview:self.clickButton];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self refreshShowViewUI];
}

- (void)refreshShowViewUI
{
    CGRect frame = self.view.frame;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        edgeInsets = self.view.safeAreaInsets;
    } else {
        // Fallback on earlier versions
    }
//    NSLog(@"self.view - insets - %@", NSStringFromUIEdgeInsets(edgeInsets));
    self.clickButton.frame = frame;
}

- (void)clickButtonAction:(UIButton *)sender
{
    if (self.clickBlock) {
        self.clickBlock(sender.tag);
    }
}

- (UIButton *)clickButton
{
    if (nil == _clickButton) {
        _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickButton.frame = CGRectZero;
        [_clickButton setTitle:@"" forState:UIControlStateNormal];
        [_clickButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _clickButton;
}

@end
