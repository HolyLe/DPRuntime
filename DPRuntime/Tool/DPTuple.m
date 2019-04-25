//
//  DPTuple.m
//  DiamondPark
//
//  Created by 麻小亮 on 2019/4/18.
//  Copyright © 2019 DiamondPark. All rights reserved.
//

#import "DPTuple.h"

@implementation DPTupleNil

+ (DPTupleNil *)dpTupleNil{
    static DPTupleNil *tupleNil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tupleNil = [DPTupleNil new];
    });
    return tupleNil;
}

@end

@interface DPTuple ()

@property (nonatomic, copy, readonly) NSArray * tupleArray;

@end

@implementation DPTuple

- (instancetype)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        _tupleArray = array;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithArray:@[]];
}

+ (instancetype)tupleWithObjects:(id)object, ...{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    va_list args;
    va_start(args, object);
    for (id currentObject = object; currentObject != nil; currentObject = va_arg(args, id)) {
        
        [objects addObject:currentObject];
    }
    va_end(args);
    return [[self alloc] initWithArray:objects];
    
    
}

+ (instancetype)tupleWithArray:(NSArray *)array{
    return [[self alloc] initWithArray:array];
}

+ (instancetype)tupleWithObjectsFromArray:(NSArray *)array convertNullsToNils:(BOOL)convert{
    if (!convert) {
        return [[self alloc] initWithArray:array];
    }
    
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:array.count];
    for (id object in array) {
        [newArray addObject:(object == NSNull.null ? DPTupleNil.dpTupleNil : object)];
    }
    
    return [[self alloc] initWithArray:newArray];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (NSUInteger)count{
    return self.tupleArray.count;
}
- (NSArray *)array{
    return self.tupleArray;
}

#pragma mark - NSFastEnumeration -

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained [])buffer count:(NSUInteger)len{
    return [self.tupleArray countByEnumeratingWithState:state objects:buffer count:_count];
}
#pragma mark - get -

- (id)objectAtIndex:(NSInteger)index{
    if (index >= self.count) return nil;
    id object = self.tupleArray[index];
    return object == DPTupleNil.dpTupleNil? nil : object;
}


- (id)first{
    return self[0];
}

- (id)second{
    return self[1];
}

- (id)third{
    return self[2];
}

- (id)fourth{
    return self[3];
}

- (id)fifth{
    return self[4];
}

- (id)last{
    return self[self.count - 1];
}


@end
@implementation DPTuple(ObjectSubscripting)

- (id)objectAtIndexedSubscript:(NSUInteger)idx{
    return [self objectAtIndex:idx];
}

@end
