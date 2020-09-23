//
//  ViewController.m
//  WMRouteDemo
//
//  Created by Aaron on 2020/9/23.
//

#import "ViewController.h"
#import "WMRoute.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)pushButtonClick:(id)sender {
    [[WMRoute route]pushWithURLString:URL_TestAViewController param:nil animated:YES];
}

- (IBAction)presentButtonClick:(id)sender {
    [[WMRoute route]presentWithURLString:URL_TestBViewController param:@{@"textId":@"33333"} animated:YES completion:nil];
}
@end
