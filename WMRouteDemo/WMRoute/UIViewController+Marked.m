//
//  UIViewController+Marked.m
//  AuthorityLook
//
//  Created by Saya on 2020/8/22.
//  Copyright © 2020 Aaron. All rights reserved.
//

#import "UIViewController+Marked.h"
#import <objc/runtime.h>

@implementation UIViewController (Marked)

- (BOOL)marked {
    id value = objc_getAssociatedObject( self, _cmd );
    return [value boolValue];
}

- (void)setMarked:(BOOL)marked {
    objc_setAssociatedObject(self, @selector(marked), @(marked), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
