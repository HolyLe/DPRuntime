//
//  DPCrashShield.m
//  DiamondPark
//
//  Created by 麻小亮 on 2019/4/15.
//  Copyright © 2019 DiamondPark. All rights reserved.
//

#import "DPCrashShield.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <pthread.h>
#import "DPRuntimeTool.h"

@implementation NSObject(DPCrashShield)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [DPCrashShield start];
    });
}

@end

@implementation DPCrashShield

+ (void)start{
//    [self dpUICrashShield];
//    [self dpContainerShield];
}

+ (void)dpUICrashShield{
    NSArray *sels= @[@"setNeedsLayout",@"setNeedsDisplay",@"setNeedsDisplayInRect:", @"setNeedsUpdateConstraints"];
    for (NSString *selString in sels) {
        [DPRuntimeTool swizzingWithClass:objc_getClass("UIView") sel:NSSelectorFromString(selString) withOptions:DPRuntimeMethodSwizzleOptionsBefore block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
            
        } performBlock:^(DPBlock perform, id object, SEL sel) {
            if ([NSThread currentThread].isMainThread) {
                perform();
            }else{
                NSLog(@"对象：：：： %@ 方法：：：  %@ 不在主线程", object, NSStringFromSelector(sel));
                dispatch_async(dispatch_get_main_queue(), ^{
                    perform();
                });
            }
        }];
    }
}

+ (void)dpContainerShield{
    
    Class classM = objc_getClass("__NSArrayM");
    Class classI = objc_getClass("__NSArrayI");
    [DPRuntimeTool swizzingWithClass:classM sel:@selector(insertObject:atIndex:) withOptions:DPRuntimeMethodSwizzleOptionsBefore block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
        if (tuple.first == nil) {
            NSLog(@"Crash with insetObject nil object :::%@", object);
            *stop = YES;
        }
        if ([tuple.second integerValue] > [object count]) {
            NSLog(@"Crash Insert with out range :::%@, %ld, %ld", object, [object count], [tuple.second integerValue]);
            *stop = YES;
        }
    }];
    
    [DPRuntimeTool swizzingWithClass:classM sel:@selector(addObject:) withOptions:DPRuntimeMethodSwizzleOptionsBefore block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
        if (tuple.first == nil) {
            NSLog(@"Crash with addObject Nil :::%@", object);
            *stop = YES;
        }
    }];
    [DPRuntimeTool swizzingWithClass:classM sel:@selector(objectAtIndex:) withOptions:DPRuntimeMethodSwizzleOptionsBefore block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
        if ([tuple.first integerValue] >= [object count]) {
            NSLog(@"Crash with out range :::%@, %ld, %@", object, [object count], tuple.first);
            *stop = YES;
        }
    }];
    
    [DPRuntimeTool swizzingWithClass:classI sel:@selector(objectAtIndex:) withOptions:DPRuntimeMethodSwizzleOptionsBefore block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
        if ([tuple.first integerValue] >= [object count]) {
            NSLog(@"Crash with out range :::%@, %ld, %@", object, [object count], tuple.first);
            *stop = YES;
        }
    }];

    [DPRuntimeTool swizzingWithClass:objc_getClass("__NSSingleObjectArrayI") sel:@selector(objectAtIndex:) withOptions:DPRuntimeMethodSwizzleOptionsBefore block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
        if ([tuple.first integerValue] >= [object count]) {
            NSLog(@"Crash with out range :::%@, %ld, %@", object, [object count], tuple.first);
            *stop = YES;
        }
    }];
    
    [DPRuntimeTool swizzingWithClass:objc_getClass("__NSPlaceholderArray") sel:@selector(initWithObjects:count:) withOptions:DPRuntimeMethodSwizzleOptionsBefore block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
        if (tuple.first) {
            id __unsafe_unretained * objects;
            [tuple.first getValue:&objects];
            NSInteger count = [tuple.second integerValue];
            for (int i = 0 ; i < count; i++) {
                if (objects[i] == nil) {
                    NSLog(@"Crash log Class%@", [objects[i] class]);
                    * stop = YES;
                    return;
                }
            }
        }
    }];
    
}

+ (void)dpArrayShield:(Class)clas{
    
}
@end
