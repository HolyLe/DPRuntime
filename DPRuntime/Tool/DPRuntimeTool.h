//
//  DPRuntimeTool.h
//  DiamondPark
//
//  Created by 麻小亮 on 2019/4/18.
//  Copyright © 2019 DiamondPark. All rights reserved.
//

#import "DPRuntimeDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface DPRuntimeTool : NSObject


/**
 对一个类的某一个方法执行操作
 
 @param clas 执行操作的类
 @param selector 执行操作的方法
 @param options 执行操作的类型
 @param block 调用的block
 */
+ (void)swizzingWithClass:(Class)clas sel:(SEL)selector withOptions:(DPRuntimeMethodSwizzleOptions)options block:(DPRuntimeObjectSwizzingBlock)block;

/**
 对一个类的某一个方法执行操作
 
 @param object 执行操作的类
 @param selector 执行操作的方法
 @param options 执行操作的类型
 @param block 新的方法
 */
+ (void)swizzingWithObject:(id)object sel:(SEL)selector withOptions:(DPRuntimeMethodSwizzleOptions)options block:(DPRuntimeObjectSwizzingBlock)block;

/**
 对一个类的某一个方法执行操作
 
 @param clas 执行操作的类
 @param selector 执行操作的方法
 @param options 执行操作的类型
 @param block 调用的block
 */
+ (void)swizzingWithClass:(Class)clas sel:(SEL)selector withOptions:(DPRuntimeMethodSwizzleOptions)options block:(DPRuntimeObjectSwizzingBlock)block performBlock:(DPPerformBlock)performBlock;

/**
 对一个类的某一个方法执行操作
 
 @param object 执行操作的类
 @param selector 执行操作的方法
 @param options 执行操作的类型
 @param block 新的方法
 */
+ (void)swizzingWithObject:(id)object sel:(SEL)selector withOptions:(DPRuntimeMethodSwizzleOptions)options block:(DPRuntimeObjectSwizzingBlock)block performBlock:(DPPerformBlock)performBlock;

/**
 对象方法替换
 */
+ (void)swizzingWithClass:(Class)clas sel:(SEL)selector withNewSel:(SEL)newSelector;

/**
 类方法替换
 */
+ (void)swizzingWithMetaClass:(Class)clas sel:(SEL)selector withNewSel:(SEL)newSelector;

@end

NS_ASSUME_NONNULL_END
