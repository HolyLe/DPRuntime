//
//  ViewController.m
//  DPRuntime
//
//  Created by 麻小亮 on 2019/4/23.
//  Copyright © 2019 DiamondPark. All rights reserved.
//

#import "ViewController.h"
#import "DPRuntime.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"111111111111");
    [self.view dp_swizzingWithSel:@selector(setNeedsDisplay) withOptions:DPRuntimeMethodSwizzleOptionsBefore block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
        NSLog(@"1111");
    }];
    [[NSMutableArray array] addObject:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.view setNeedsLayout];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.view setNeedsDisplay];
    });
    // Do any additional setup after loading the view, typically from a nib.
}


@end
