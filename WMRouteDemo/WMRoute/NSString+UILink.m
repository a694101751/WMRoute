//
//  NSString+UILink.m
//  AuthorityLook
//
//  Created by Saya on 2020/8/22.
//  Copyright © 2020 Aaron. All rights reserved.
//

#import "NSString+UILink.h"

NSString * const StoryboardScheme = @"sb://";
NSString * const XibScheme        = @"xib://";
NSString * const CodeScheme       = @"code://";

@implementation NSString (UILink)

+ (id)storyboard_resolvingSymlinkController:(NSString*)controllerLink {
    NSArray *parts = [controllerLink componentsSeparatedByString:@"/"];

    NSString *storyboardName = [parts objectAtIndex:0];
    NSString *controllerId = parts.count == 2 ? [parts objectAtIndex:1] : nil;

    UIViewController *controller = nil;
    @try {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];

        if (controllerId) {
            controller = [storyboard instantiateViewControllerWithIdentifier:controllerId];
        } else {
            controller = [storyboard instantiateInitialViewController];

            if (!controller) {
                NSLog(@"may be you forgot to set initial view controller in %@.storyboard", storyboardName);
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error:can not load controller <%@>, reason:%@", controllerLink, exception);
    }
    @finally {
        return controller;
    }
}

+ (id)xib_resolvingSymlinkController:(NSString*)controllerLink {
    UIViewController *controller = nil;
    
    @try {
        NSString *nibName         = controllerLink;
        NSString *className       = controllerLink;
        Class     controllerClass = NSClassFromString(className);
        controller = [[controllerClass alloc] initWithNibName:nibName bundle:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Error:can not load controller <%@>, reason:%@", controllerLink, exception);
    }
    @finally {
        return controller;
    }
}

+ (id)code_resolvingSymlinkController:(NSString*)controllerLink {
    UIViewController *controller = nil;
    
    @try {
        NSString *className = controllerLink;
        Class controllerClass = NSClassFromString(className);
        controller = [[controllerClass alloc] init];
    }
    @catch (NSException *exception) {
        NSLog(@"Error:can not load controller <%@>, reason:%@", controllerLink, exception);
    }
    @finally {
        return controller;
    }
}

+ (id)controllerForLink:(NSString *)link {
    if([link hasPrefix:XibScheme]) {
        return [[self class] xib_resolvingSymlinkController:[link substringFromIndex:XibScheme.length]];
    }
    else if([link hasPrefix:CodeScheme]) {
        return [[self class] code_resolvingSymlinkController:[link substringFromIndex:CodeScheme.length]];
    }
    else if([link hasPrefix:StoryboardScheme]) {
        return [[self class] storyboard_resolvingSymlinkController:[link substringFromIndex:StoryboardScheme.length]];
    } else {
        NSLog(@"not support scheme %@", link);
        return nil;
    }
}

- (id)instantiateController {
    return [[self class] controllerForLink:self];
}

@end
