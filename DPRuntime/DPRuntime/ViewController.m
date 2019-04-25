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
//    [[NSMutableArray new] addObject:nil];
//    [[NSMutableArray new] objectAtIndex:3];
//    [[NSMutableArray new] insertObject:nil atIndex:3];
//    id aa = nil;
//    NSArray *array =  @[@"1111",aa];
//    NSLog(@"%@", array);
//    [self dp_swizzingWithSel:@selector(viewWillAppear:) withOptions:DPRuntimeMethodSwizzleOptionsBefore block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
//         
//    }];
//    [self dp_swizzingWithSel:@selector(viewWillAppear:) withOptions:DPRuntimeMethodSwizzleOptionsBefore block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
//        
//    }];
    [self dp_swizzingWithSel:@selector(viewWillAppear:) withOptions:DPRuntimeMethodSwizzleOptionsAfter block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
        
    }];
    [self dp_swizzingWithSel:@selector(viewWillAppear:) withOptions:DPRuntimeMethodSwizzleOptionsAfter block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
        
    }];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ViewController *vc = [ViewController new];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dealloc
{
    
}
@end
