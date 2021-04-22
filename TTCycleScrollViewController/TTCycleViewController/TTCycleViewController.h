//
//  TTCycleViewController.h
//  OCDemoGroup
//
//  Created by tangshuanghui on 2021/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTCycleViewController;
@protocol TTCycleViewControllerDelegate <NSObject>

@optional
/** 点击图片回调 */
- (void)cycleScrollViewController:(TTCycleViewController *)cycleScrollViewController didSelectItemAtIndex:(NSInteger)index;

/** 图片滚动回调 */
- (void)cycleScrollViewController:(TTCycleViewController *)cycleScrollViewController didScrollToIndex:(NSInteger)index;

@end

@interface TTCycleViewController : UIViewController

@property (nonatomic, weak) id<TTCycleViewControllerDelegate> delegate;
// 如果只是单纯广告图片浏览功能 可适用
@property (nonatomic, strong) NSArray * dataList;
/// 当前页码
@property (nonatomic, assign) NSInteger currentIndex;
/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;
/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;
/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;
/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage * placeholderImage;

@end

NS_ASSUME_NONNULL_END
