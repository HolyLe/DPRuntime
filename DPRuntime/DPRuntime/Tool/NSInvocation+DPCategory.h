//
//  NSInvocation+DPCategory.h
//  DiamondPark
//
//  Created by 麻小亮 on 2019/4/19.
//  Copyright © 2019 DiamondPark. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@class DPTuple;
@interface NSInvocation (DPCategory)

@property (nonatomic, copy) DPTuple *dp_argumentsTuple;

- (id)dp_argumentAtIndex:(NSInteger)index;

- (id)dp_returnValue;

- (void)dp_setArgument:(id)object atIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
