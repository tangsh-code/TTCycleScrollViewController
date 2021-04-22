//
//  TTCycleContainerViewController.h
//  OCDemoGroup
//
//  Created by tangshuanghui on 2021/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBannerBlock)(NSInteger index);

@interface TTCycleContainerViewController : UIViewController

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) ClickBannerBlock clickBlock;

@end

NS_ASSUME_NONNULL_END
