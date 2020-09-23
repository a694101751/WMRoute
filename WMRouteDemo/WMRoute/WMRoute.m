//
//  WMRoute.m
//  WMAvoid
//
//  Created by Aaron on 2020/9/23.
//

#import "WMRoute.h"
#import "NSString+UILink.h"
#import "UIViewController+Marked.h"
#import "AAPLCustomPresentationController.h"

@implementation WMRoute

+ (instancetype)route {
    static WMRoute *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[self alloc] init];
    });
    return router;
}

- (UIViewController *)viewControllerWithUrlString:(NSString *)urlString param:(NSDictionary * _Nullable)param {
    UIViewController *viewController = [urlString instantiateController];
    viewController.hidesBottomBarWhenPushed = YES;
    if (param) {
        [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            @try {
                [viewController setValue:obj forKey:key];
            } @catch (NSException *exception) {}
        }];
    }
    return viewController;
}

- (void)foldPushWithURLString:(NSString *)urlString
                        param:(NSDictionary * _Nullable)param
                     animated:(BOOL)animated {
    [self pushWithURLString:urlString param:param fold:YES animated:animated];
}

- (void)pushWithURLString:(NSString *)urlString
                    param:(NSDictionary * _Nullable)param
                 animated:(BOOL)animated {
    [self pushWithURLString:urlString param:param fold:NO animated:animated];
}

- (void)pushWithURLString:(NSString *)urlString
                    param:(NSDictionary * _Nullable)param
                     fold:(BOOL)fold
                 animated:(BOOL)animated {
    UIViewController *viewController = [self viewControllerWithUrlString:urlString param:param];
    if (fold) {
        [self foldPushViewController:viewController animated:animated];
    } else {
        [self.navigationController pushViewController:viewController animated:animated];
    }
}

- (UIViewController *)topViewController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

- (UINavigationController *)navigationController {
    UINavigationController *navigationController = (UINavigationController *)self.topViewController;
    
    if ([navigationController isKindOfClass:[UINavigationController class]] == NO) {
        if ([navigationController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabbarController = (UITabBarController *)navigationController;
            navigationController = tabbarController.selectedViewController;
            if ([navigationController isKindOfClass:[UINavigationController class]] == NO) {
                navigationController = tabbarController.selectedViewController.navigationController;
            }
        } else {
            navigationController = navigationController.navigationController;
        }
    }
    
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
       return navigationController;
    }
    
    if (navigationController == nil) {
        UITabBarController *tabBarController = (UITabBarController *)self.topViewController.presentingViewController;
        if ([tabBarController.selectedViewController isKindOfClass:UINavigationController.class]) {
            navigationController = tabBarController.selectedViewController;
            return navigationController;
        };
    }
    
    return nil;
}

- (NSMutableArray *)controllerAfterFold:(UINavigationController*)navi {
    NSMutableArray *controllers  = navi.viewControllers.mutableCopy;
    NSEnumerator *enumerator = [controllers reverseObjectEnumerator];
    NSMutableArray *removed    = [NSMutableArray array];
    UIViewController *controller = nil;
    BOOL havMark = NO;
    
    for (UIViewController *theControl in controllers) {
        if (theControl.marked) {
            havMark = YES;
        }
    }
    
    if (havMark) {
        while ((controller = [enumerator nextObject])) {
            if (controller.marked) {
                break;
            } else {
                [removed addObject:controller];
            }
        }
        [controllers removeObjectsInArray:removed];
    }
    
    return controllers;
}

- (void)foldPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSMutableArray *controllers = [self controllerAfterFold:self.navigationController];
    [controllers addObject:viewController];
    [self.navigationController setViewControllers:controllers animated:animated];
}

- (void)popToRootController:(int)activeIndex currentViewController:(UIViewController *)viewController {
    UINavigationController *currentNavi = viewController.navigationController;
    UIWindow *window = viewController.view.window;
    UITabBarController *tabcontrl = (UITabBarController *)window.rootViewController;
    if (![tabcontrl isKindOfClass:[UITabBarController class]]) {
        return;
    }
    tabcontrl.selectedIndex = activeIndex;
    UINavigationController *navi = (UINavigationController*)tabcontrl.viewControllers[activeIndex];
    [navi popToRootViewControllerAnimated:NO];
    [currentNavi popToRootViewControllerAnimated:NO];
}

- (void)slidePresentWithURLString:(NSString *)urlString
                            param:(NSDictionary * _Nullable)param
                         animated: (BOOL)flag
                       completion:(void (^ __nullable)(void))completion {
    UIViewController *viewController = [self viewControllerWithUrlString:urlString param:param];
    [self slidePresentViewController:viewController param:param animated:flag completion:completion];
}

- (void)slidePresentViewController:(UIViewController *)viewController
                             param:(NSDictionary * _Nullable)param
                          animated: (BOOL)flag
                        completion:(void (^ __nullable)(void))completion {
    AAPLCustomPresentationController *presentationController = [[AAPLCustomPresentationController alloc] initWithPresentedViewController:viewController presentingViewController:self.topViewController];
    viewController.transitioningDelegate = presentationController;
    [self.topViewController presentViewController:viewController animated:flag completion:completion];
}

- (void)presentWithURLString:(NSString *)urlString
                       param:(NSDictionary * _Nullable)param
                    animated:(BOOL)animated
                  completion:(void (^ __nullable)(void))completion {
    UIViewController *viewController = [self viewControllerWithUrlString:urlString param:param];
    UIPresentationController<UIViewControllerTransitioningDelegate> *presentationController = nil;
    presentationController = [[AAPLCustomPresentationController alloc] initWithPresentedViewController:viewController presentingViewController:self.topViewController];
    viewController.transitioningDelegate = presentationController;
    [self.topViewController presentViewController:viewController animated:animated completion:completion];
}

@end
