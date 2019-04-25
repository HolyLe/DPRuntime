//
//  DPRuntimeDefine.h
//  DiamondPark
//
//  Created by 麻小亮 on 2019/4/18.
//  Copyright © 2019 DiamondPark. All rights reserved.
//

#ifndef DPRuntimeDefine_h
#define DPRuntimeDefine_h
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "DPTuple.h"

static inline BOOL isValidImp(IMP imp){
    return imp != _objc_msgForward;
}

typedef NS_OPTIONS(NSUInteger,DPRuntimeMethodSwizzleOptions) {
    DPRuntimeMethodSwizzleOptionsBefore = 1 << 0,//调用在之前
    DPRuntimeMethodSwizzleOptionsAfter = 1 << 1,//调用在之后
    DPRuntimeMethodSwizzleOptionsClass = 1 << 2,//类方法还是实例方法,暂不支持静态方法
};

typedef void (^DPBlock)(void);
typedef void (^DPPerformBlock)(DPBlock perform, id object, SEL sel);
/**
 @param object 返回方法替换的对象
 @param sel 旧方法
 @param options 替换操作类型
 @param tuple 参数
 @param stop 是否停止对方法的执行

 */

typedef void(^ DPRuntimeObjectSwizzingBlock)(id object, SEL sel, DPRuntimeMethodSwizzleOptions options, DPTuple *tuple, BOOL *stop);

#endif /* DPRuntimeDefine_h */
