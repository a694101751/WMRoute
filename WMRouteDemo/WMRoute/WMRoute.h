//
//  WMRoute.h
//  WMAvoid
//
//  Created by Aaron on 2020/9/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WMRouteUrlDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMRoute : NSObject

+ (instancetype)route;

@property (nonatomic, strong, readonly) UIViewController *topViewController;

@property (nonatomic, strong, readonly) UINavigationController *navigationController;

- (void)pushWithURLString:(NSString *)urlString
                    param:(NSDictionary * _Nullable)param
                 animated:(BOOL)animated;

- (void)foldPushWithURLString:(NSString *)urlString
                        param:(NSDictionary * _Nullable)param
                     animated:(BOOL)animated;

- (void)popToRootController:(int)activeIndex
      currentViewController:(UIViewController *)viewController;

- (void)presentWithURLString:(NSString *)urlString
                       param:(NSDictionary * _Nullable)param
                    animated:(BOOL)animated
                  completion:(void (^ __nullable)(void))completion;
@end

NS_ASSUME_NONNULL_END
