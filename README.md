# TTCycleScrollViewController
基于UIPageViewController封装的无线循环滚动控件，支持自定义界面
可应用于广告banner页循环，可用于多个相似页面滚动联动
无需太操心内存管理相关

Method
    TTCycleViewController * cycleViewController = [[TTCycleViewController alloc] init];
    cycleViewController.delegate = self;
    cycleViewController.infiniteLoop = YES;
    cycleViewController.dataList = @[@"1", @"2", @"3", @"4", @"5"];
    cycleViewController.view.frame = CGRectMake(0, 88 + 10, [UIScreen mainScreen].bounds.size.width, 200);
    [self addChildViewController:cycleViewController];
    [self.view addSubview:cycleViewController.view];
