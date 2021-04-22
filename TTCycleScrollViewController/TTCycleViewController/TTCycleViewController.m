//
//  TTCycleViewController.m
//  OCDemoGroup
//
//  Created by tangshuanghui on 2021/4/21.
//

#import "TTCycleViewController.h"
#import "TTCycleContainerViewController.h"

@interface TTCycleViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController * pageViewController;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) NSTimer * timer;
/// 当imageURLs为空时的背景图
@property (nonatomic, strong) UIImageView *backgroundImageView;
/// 待优化手动滚动时间间隔短定时器方法
@property (nonatomic, assign) NSTimeInterval lastTimeInterval;

@end

@implementation TTCycleViewController

- (void)dealloc
{
    [self invalidateTimer];
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _autoScrollTimeInterval = 2.0;
    _autoScroll = YES;
    _infiniteLoop = YES;
    // 底层默认比较图
    [self.view addSubview:self.backgroundImageView];
    // 内容展示图
    [self setupPageViewControllerUI];
    // 页面指示图
    [self setupPageControl];
    // 主动开启定时器
    [self setupTimer];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self refreshShowViewUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self invalidateTimer];
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
    self.backgroundImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.pageControl.frame = CGRectMake(0, frame.size.height - 20, frame.size.width, 20);
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

- (void)setDataList:(NSArray *)dataList
{
    _dataList = dataList;
    [self setupTimer];
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    _infiniteLoop = infiniteLoop;
}

- (void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    [self invalidateTimer];
    if (_autoScroll) {
        [self setupTimer];
    }
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
    self.backgroundImageView.image = placeholderImage;
}

- (void)setupTimer
{
    // 大于1张图片才滚动 低于2张图片不无限循环滚动
    if (self.dataList.count <= 1) {
        self.infiniteLoop = NO;
        return;
    }
    // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    [self invalidateTimer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}

- (void)invalidateTimer
{
    NSLog(@"消除定时器");
    [_timer invalidate];
    _timer = nil;
}

// 自动滚动
- (void)automaticScroll
{
    if (self.currentIndex + 1 >= self.dataList.count) {
        // 已经滚动到最后一页 这时需滚动到第一页
        self.currentIndex = 0;
    } else {
        self.currentIndex += 1;
    }
    // 更新页数指示器
    self.pageControl.currentPage = self.currentIndex;
    [self.pageViewController setViewControllers:@[[self viewControllerAtIndex:self.currentIndex]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    if ([self.delegate respondsToSelector:@selector(cycleScrollViewController:didScrollToIndex:)]) {
        [self.delegate cycleScrollViewController:self didScrollToIndex:self.currentIndex];
    }
}

- (void)setupPageControl
{
    self.pageControl.numberOfPages = self.dataList.count;
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
}

- (void)setupPageViewControllerUI
{
    if (self.dataList.count == 0) {
        return;
    }
    [self.pageViewController setViewControllers:@[[self viewControllerAtIndex:self.currentIndex]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(TTCycleContainerViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        if (index == 0 && self.infiniteLoop) {
            return [self viewControllerAtIndex:(self.dataList.count - 1)];
        }
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法,自动来维护次序
    // 不用我们去操心每个ViewController的顺序问题
    return [self viewControllerAtIndex:index];
}

#pragma mark 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(TTCycleContainerViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.dataList count]) {
        if (self.infiniteLoop) {
            return [self viewControllerAtIndex:0];
        }
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    [self invalidateTimer];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    // 此方法确定当前页位置
    NSUInteger index = [self indexOfViewController:(TTCycleContainerViewController *)[pageViewController.viewControllers firstObject]];
    self.currentIndex = index;
    [self updateTitleIndexNumber];
    [self setupTimer];
    self.pageControl.currentPage = self.currentIndex;
}

- (void)updateTitleIndexNumber
{
//    [self.headerView updateTitleNumber:[NSString stringWithFormat:@"%ld/%ld", (long)(self.currentIndex + 1), (long)self.photoList.count]];
}

#pragma mark - 根据index得到对应的UIViewController
- (TTCycleContainerViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.dataList count] == 0) || (index >= [self.dataList count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    TTCycleContainerViewController * containerViewController = [[TTCycleContainerViewController alloc] init];
    containerViewController.index = index;
    __weak typeof(self) weakSelf = self;
    containerViewController.clickBlock = ^(NSInteger index) {
        if ([weakSelf.delegate respondsToSelector:@selector(cycleScrollViewController:didSelectItemAtIndex:)]) {
            [weakSelf.delegate cycleScrollViewController:weakSelf didSelectItemAtIndex:index];
        }
    };

    return containerViewController;
}
 
#pragma mark - 数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(TTCycleContainerViewController *)viewController {
    return viewController.index;
}

#pragma mark -- Lazy Init
- (UIPageControl *)pageControl
{
    if (nil == _pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.tintColor = [UIColor grayColor];
    }
    
    return _pageControl;
}

- (UIPageViewController *)pageViewController
{
    if (nil == _pageViewController) {
        NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(UIPageViewControllerSpineLocationMin)};
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
    }
    
    return _pageViewController;
}

- (UIImageView *)backgroundImageView
{
    if (nil == _backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        _backgroundImageView.backgroundColor = [UIColor systemBlueColor];
    }
    
    return _backgroundImageView;
}


@end
