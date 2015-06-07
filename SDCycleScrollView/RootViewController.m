//
//  RootViewController.m
//  SDCycleScrollView
//
//  Created by sky on 15/5/29.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"

@interface RootViewController ()
- (IBAction)next:(id)sender;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)next:(id)sender {
    
    UIViewController *ctl = [[ViewController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
    
}
@end
