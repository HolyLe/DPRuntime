//
//  ViewController.m
//  DPRuntime
//
//  Created by 麻小亮 on 2019/4/23.
//  Copyright © 2019 DiamondPark. All rights reserved.
//

#import "ViewController.h"
#import "Aspects.h"
#import "DPRuntime.h"
@interface ViewController ()

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [ViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionBefore usingBlock:^(id a, id o){
//
//        } error:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self dp_swizzingWithSel:@selector(viewWillAppear:) withOptions:DPRuntimeMethodSwizzleOptionsAfter block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
        
    }];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

@end
