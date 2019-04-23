//
//  DPRuntimeTool.h
//  DiamondPark
//
//  Created by 麻小亮 on 2019/4/15.
//  Copyright © 2019 DiamondPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPRuntimeTool.h"
NS_ASSUME_NONNULL_BEGIN

@protocol DPRuntimeProtocol <NSObject>

@optional
/**
 返回yes或不实现方法，则调用下面的方法
 */

+ (BOOL)dp_runtimeRequireClasses:(Class)clas;

/**
 在程序初始化时调动，只会执行一次
 */
+ (void)dp_runtimeRequireClasses:(Class _Nonnull *_Nullable)clases currentClass:(Class)clas count:(unsigned int)count;

/**
 上一个方法的遍历
 */
+ (void)dp_runtimeRequiredEachClasses:(Class)clas currentClass:(Class)currentClass;

/**
 类中所有方法的遍历
 */
+ (void)dp_runtimeClassEachMethod:(Method)method;

+ (void)dp_runtimeObjectEachMethod:(Method)method;

@end

typedef void(^dp_deallocTask)(id self);

@interface NSObject(DPRuntime)

/**
方法添加block回调
 */
- (void)dp_swizzingWithSel:(SEL)selector withOptions:(DPRuntimeMethodSwizzleOptions)options block:(DPRuntimeObjectSwizzingBlock)block;

- (void)dp_swizzingWithSel:(SEL)selector withOptions:(DPRuntimeMethodSwizzleOptions)options block:(DPRuntimeObjectSwizzingBlock)block performBlock:(DPPerformBlock)performBlock;
/**
 方法添加selector
 */
- (void)dp_swizzingClassWithSel:(SEL)selector newSelector:(SEL)newSelector;

/**
 类方法替换
 */
- (void)dp_swizzingMetaClassWithSel:(SEL)selector newSelector:(SEL)newSelector;

/**
 添加销毁任务
 */
- (void)dp_addDellocTask:(dp_deallocTask)task;

@end

@interface DPRuntime : NSObject


+ (DPRuntime *)runtime;


/**
 项目中所有的类
 */
@property (nonatomic, readonly) Class _Nonnull *_Nullable  allClasses;

/**
 所有类的数量
 */
@property (nonatomic, assign, readonly) unsigned int count;


@end



NS_ASSUME_NONNULL_END
