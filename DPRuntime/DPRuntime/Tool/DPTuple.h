//
//  DPTuple.h
//  DiamondPark
//
//  Created by 麻小亮 on 2019/4/18.
//  Copyright © 2019 DiamondPark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface DPTupleNil : NSObject
+ (DPTupleNil *)dpTupleNil;
@end
@interface DPTuple : NSObject<NSFastEnumeration, NSCopying>

+ (instancetype)tupleWithArray:(NSArray *)array;

+ (instancetype)tupleWithObjectsFromArray:(NSArray *)array convertNullsToNils:(BOOL)convert;

+ (instancetype)tupleWithObjects:(id)object,...NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, assign) NSUInteger  count;

///获取数据
@property (nonatomic, readonly, nullable) id first;
@property (nonatomic, readonly, nullable) id second;
@property (nonatomic, readonly, nullable) id third;
@property (nonatomic, readonly, nullable) id fourth;
@property (nonatomic, readonly, nullable) id fifth;
@property (nonatomic, readonly, nullable) id last;

- (nullable id)objectAtIndex:(NSInteger)index;

- (nullable NSArray *)array;

@end

@interface DPTuple (ObjectSubscripting)

- (nullable id)objectAtIndexedSubscript:(NSUInteger)idx;

@end


NS_ASSUME_NONNULL_END
