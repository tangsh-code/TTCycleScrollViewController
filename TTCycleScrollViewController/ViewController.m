//
//  ViewController.m
//  TTCycleScrollViewController
//
//  Created by tangshuanghui on 2021/4/22.
//

#import "ViewController.h"
#import "TTCycleViewController.h"

@interface ViewController () <TTCycleViewControllerDelegate>

@property (nonatomic, strong) TTCycleViewController * cycleViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TTCycleViewController * cycleViewController = [[TTCycleViewController alloc] init];
    cycleViewController.delegate = self;
    cycleViewController.infiniteLoop = YES;
    cycleViewController.dataList = @[@"1", @"2", @"3", @"4", @"5"];
    cycleViewController.view.frame = CGRectMake(0, 88 + 10, [UIScreen mainScreen].bounds.size.width, 200);
    [self addChildViewController:cycleViewController];
    [self.view addSubview:cycleViewController.view];
    self.cycleViewController = cycleViewController;
}

#pragma mark --- TTCycleViewControllerDelegate
- (void)cycleScrollViewController:(TTCycleViewController *)cycleScrollViewController didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"index ===> %ld", index);
    
}

- (void)cycleScrollViewController:(TTCycleViewController *)cycleScrollViewController didScrollToIndex:(NSInteger)index
{
    NSLog(@"ScrollToIndex ===> %ld", index);
}

@end
