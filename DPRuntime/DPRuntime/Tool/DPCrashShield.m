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

/**
 UI
 */
void DPCrashShieldUI(Class class,SEL sel){
    __block void (*oldImp) (__unsafe_unretained id , SEL) = NULL;
    oldImp = (__typeof__(oldImp))class_getMethodImplementation(class, sel);
    
    void (^block) (id)  = ^(id self){
            if (oldImp == NULL) {
                struct objc_super superInfo = {
                    .receiver = self,
                    .super_class = class_getSuperclass(class)
                };
                void (*msg)(struct objc_super *,SEL) = (__typeof__(msg))objc_msgSendSuper;
                msg(&superInfo,sel);
            }else{
                oldImp(self,sel);
            }
    };
    
    IMP newImp = imp_implementationWithBlock(^(id self,SEL selector){
        if (!pthread_main_np()) {
            NSLog(@"DPCrash-------------------------------\n-----------\n Class:%@ object:%@ selector: %@ *****is Not in Main Thread****\n------------------------\n",[self class], self, NSStringFromSelector(sel));
            dispatch_async(dispatch_get_main_queue(), ^{
                block(self);
            });
        }else{
            block(self);
        }
    });
    oldImp = (__typeof__(oldImp)) method_setImplementation(class_getInstanceMethod(class, sel), newImp);
}
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
    [self dpUICrashShield];
    [self dpContainerShield];
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
    Class class = objc_getClass("__NSArrayM");
    [DPRuntimeTool swizzingWithClass:class sel:@selector(addObject:) withOptions:DPRuntimeMethodSwizzleOptionsBefore block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
        if (tuple.first == nil) {
            *stop = YES;
        }
    }];
    [DPRuntimeTool swizzingWithClass:class sel:@selector(insertObject:atIndex:) withOptions:DPRuntimeMethodSwizzleOptionsBefore block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
        if (tuple.first == nil) {
            *stop = YES;
        }
    }];
    [DPRuntimeTool swizzingWithClass:class sel:@selector(addObject:) withOptions:DPRuntimeMethodSwizzleOptionsBefore block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
        if (tuple.first == nil) {
            *stop = YES;
        }
    }];
    [DPRuntimeTool swizzingWithClass:class sel:@selector(objectAtIndex:) withOptions:DPRuntimeMethodSwizzleOptionsBefore block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
        if ([tuple.first integerValue] >= [object count]) {
            *stop = YES;
        }
    }];
    
//    [DPRuntimeTool swizzingWithClass:class sel:@selector(addObject:) withOptions:DPRuntimeMethodSwizzleOptionsBefore block:^(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop) {
//        if (tuple.first == nil) {
//            *stop = YES;
//        }
//    }];
}

+ (void)dpArrayShield:(Class)clas{
    
}
@end
