//
//  DPRuntimeTool.m
//  DiamondPark
//
//  Created by 麻小亮 on 2019/4/18.
//  Copyright © 2019 DiamondPark. All rights reserved.
//

#import "DPRuntimeTool.h"
#import "NSInvocation+DPCategory.h"
#import "DPRuntime.h"

@interface DPRuntimeSwizzleAttributeMapNode : NSObject
{
    @package
    DPRuntimeObjectSwizzingBlock _swizzingBlock;
    DPPerformBlock _perFormBlock;
    DPRuntimeSwizzleAttributeMapNode *_next;
    DPRuntimeSwizzleAttributeMapNode *_prev;
}
@end

@implementation DPRuntimeSwizzleAttributeMapNode
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)start:(void (^)(DPRuntimeObjectSwizzingBlock block))block finish:(void (^)(void))finish object:(id)object sel:(SEL)selector stop:(BOOL *)stop{
    __weak typeof(self)weakSelf = self;
    self->_perFormBlock(^{
        __strong typeof (weakSelf)self = weakSelf;
        if (!self) return;
        if (block) {
            block(self->_swizzingBlock);
        }
        
        if (self ->_next) {
            [self->_next start:block finish:finish object:object sel:selector stop:stop];
        }else{
            finish();
        }
        
    }, object, selector);
}

- (void)dealloc
{
    NSLog(@"node 销毁了 %@",self);
}

@end

@interface DPRuntimeSwizzleAttributeMap : NSObject
{
    @package
    DPRuntimeSwizzleAttributeMapNode *_head;
    DPRuntimeSwizzleAttributeMapNode *_tail;
    void (^_block)(DPRuntimeObjectSwizzingBlock block);
    void (^_finishBlock) (DPRuntimeSwizzleAttributeMap *map) ;
    id _object;
    SEL _selector;
    BOOL *stop;
}
@end

@implementation DPRuntimeSwizzleAttributeMap

- (void)start{
    if (self->_head == nil) {
        self->_finishBlock(self);
    }else{
        __weak typeof(self)weakSelf = self;
        [self->_head start:self->_block finish:^{
            __strong typeof (weakSelf)self = weakSelf;
            if (!self) return;
            self->_finishBlock(self);
            self->_block = nil;
        } object:_object sel:_selector stop:stop];
    }
}

- (void)addDPRuntimeNode:(DPRuntimeSwizzleAttributeMapNode *)node{
    
    if (_tail) {
        _tail->_next = node;
        node->_prev = _tail;
    }else{
        _head = node;
    }
    _tail = node;
}

- (void)insetDPRuntimeNode:(DPRuntimeSwizzleAttributeMapNode *)node{
    
    if (_head) {
        node->_next = _head;
        _head->_prev = node;
    }else{
        _tail = node;
    }
    _head = node;
}

- (void)insetDPRuntimeMap:(DPRuntimeSwizzleAttributeMap *)map{
    if (!map) return;
    DPRuntimeSwizzleAttributeMapNode *node = map->_tail;
    while (node) {
        DPRuntimeSwizzleAttributeMapNode *newNode = [DPRuntimeSwizzleAttributeMapNode new];
        if (newNode->_swizzingBlock) {
            newNode->_swizzingBlock = [node->_swizzingBlock copy];
            newNode->_perFormBlock = [node->_perFormBlock copy];
        }
        [self insetDPRuntimeNode:newNode];
        if (node->_prev) {
            node = node->_prev;
        }else{
            break;
        }
    }
}

- (void)appendDPRuntimeMap:(DPRuntimeSwizzleAttributeMap *)map{
    if (!map) return;
    DPRuntimeSwizzleAttributeMapNode *node = map->_head;
    while (node) {
        DPRuntimeSwizzleAttributeMapNode *newNode = [DPRuntimeSwizzleAttributeMapNode new];
        newNode->_swizzingBlock = [node->_swizzingBlock copy];
        newNode->_perFormBlock = [node->_perFormBlock copy];
        [self addDPRuntimeNode:newNode];
        if (node->_next) {
            node = node->_next;
        }else{
            break;
        }
    }
}

- (void)dp_deallocMap{
    DPRuntimeSwizzleAttributeMapNode *node = self->_head;
    if (node) {
        while (node->_next) {
            if (node->_prev) {
                node->_prev = nil;
            }
            DPRuntimeSwizzleAttributeMapNode *newNode = node->_next;
            node->_next = nil;
            node = newNode;
        }
    }
}

- (void)dealloc
{
    
}
@end

@interface  DPRuntimeSwizzleAttributeDetail : NSObject{
    @package
    DPRuntimeSwizzleAttributeMap* _beforeMap;
    DPRuntimeSwizzleAttributeMap* _afterMap;
    BOOL _isSwizzled;
}
@end

@implementation DPRuntimeSwizzleAttributeDetail

- (DPRuntimeSwizzleAttributeMap *)aftermap{
    if (!_afterMap) {
        _afterMap = [DPRuntimeSwizzleAttributeMap new];
        
    }
    return _afterMap;
}

- (DPRuntimeSwizzleAttributeMap *)beforemap{
    if (!_beforeMap) {
        _beforeMap = [DPRuntimeSwizzleAttributeMap new];
    }
    return _beforeMap;
}
@end

@interface DPRuntimeSwizzleAttribute : NSObject{
    @package
    CFMutableDictionaryRef _selectMap;
    
}
@end

@implementation DPRuntimeSwizzleAttribute

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectMap = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }
    return self;
}
@end

@interface DPSwizzleClassAttribute : NSObject{
    @package
    BOOL _isSwizzled;
    DPRuntimeSwizzleAttribute *_attribute;
    Class _subClass;
}
@end

@implementation DPSwizzleClassAttribute


@end

static NSString * const DPSubClassSuffix = @"_DPSwizzleMethod_";
static NSString * const DPNewSelectorPrefix = @"dp_newSelector_";
static NSString * const DPExchangeSelectorPrefix = @"dp_exchangeSelector_";

static void *DPDynamicClassSwizzleAttribute = &DPDynamicClassSwizzleAttribute;
static SEL DPNewForSelector(SEL originalSelector) {
    NSString *selectorName = NSStringFromSelector(originalSelector);
    return NSSelectorFromString([DPNewSelectorPrefix stringByAppendingString:selectorName]);
}

DPSwizzleClassAttribute *DPClassAttributeWithClass(id object){
    id attribute = objc_getAssociatedObject(object, &DPDynamicClassSwizzleAttribute);
    if (!attribute) {
        attribute = [DPSwizzleClassAttribute new];
        objc_setAssociatedObject(object, &DPDynamicClassSwizzleAttribute, attribute, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return attribute;
}
/**
 新创建的类返回的class是当前类
 */
static void DPSwizzleGetClass(Class class, Class statedClass){
    SEL selector = @selector(class);
    IMP newImp = imp_implementationWithBlock(^ (id self){
        return statedClass;
    });
    class_replaceMethod(class, selector, newImp, method_getTypeEncoding(class_getInstanceMethod(class, selector)));
}


/**
 因为setClass改变了方法替换对象的类，所以在这里处理
 */
static void DPSwizzleMethodSignatureForSelectore(Class class){
    IMP newImp = imp_implementationWithBlock(^(id self,SEL selector){
        Class originClass = object_getClass(class);
        
        if (DPClassAttributeWithClass(originClass)->_isSwizzled) {
            selector = DPNewForSelector(selector);
        }
        Method method = class_getInstanceMethod(originClass, selector);
        
        if (method == NULL) {
            struct objc_super tar = {
                .super_class = class_getSuperclass(class),
                .receiver = self
            };
            return ((NSMethodSignature * (*)(struct objc_super *, SEL, SEL))objc_msgSendSuper)(&tar,@selector(methodSignatureForSelector:),selector);
        }else{
            return [NSMethodSignature signatureWithObjCTypes:method_getTypeEncoding(method)];
        }
    });
    SEL selector = @selector(methodSignatureForSelector:);
    Method methodSignatureForSelectorMethod = class_getInstanceMethod(class, selector);
    if (method_getImplementation(methodSignatureForSelectorMethod) == _objc_msgForward) {
        methodSignatureForSelectorMethod = class_getClassMethod([class class], DPNewForSelector(selector));
    }
    class_replaceMethod(class, selector, newImp, method_getTypeEncoding(methodSignatureForSelectorMethod));
}

static void DPSwizzleRespondsToSelector(Class class){
    SEL sel = sel_registerName("respondsToSelector:");
    Method responds = class_getInstanceMethod(class,sel);
    
    BOOL (*responsToSelector)(id, SEL, SEL) = (__typeof__ (responsToSelector))method_getImplementation(responds);
    
    IMP newImp = imp_implementationWithBlock(^BOOL(id self,SEL selector){
        unsigned count;
        Method *methods = class_copyMethodList(class, &count);
        Method method = NULL;
        for (unsigned i = 0; i < count ; i++) {
            if (sel_isEqual(method_getName(methods[i]), sel)){
                method = methods[i];
                break;
            }
        }
        if (method != NULL && method_getImplementation(method) == _objc_msgForward) {
            if (objc_getAssociatedObject(self, DPNewForSelector(selector))) return YES;
        }
        return responsToSelector(self,sel,selector);
    });
    class_replaceMethod(class, sel, newImp, method_getTypeEncoding(responds));
}


static void DPSwizzleForwardInvocation(Class class) {
    
    SEL forwadInvationSel = @selector(forwardInvocation:);
    Method forwadInvationMethod = class_getInstanceMethod(class, forwadInvationSel);
    
    void (*forwadInvocation)(id , SEL, NSInvocation *) = NULL;
    
    if (forwadInvationMethod != NULL) {
        forwadInvocation = (__typeof__ (forwadInvocation))method_getImplementation(forwadInvationMethod);
    }
    IMP newImp = imp_implementationWithBlock(^(id self, NSInvocation *invocaion){
        DPTuple *tuple = invocaion.dp_argumentsTuple;
        
        DPRuntimeSwizzleAttribute *attribute = DPClassAttributeWithClass(self)->_attribute;
        DPRuntimeSwizzleAttributeDetail *objectDetail;
        
        __block BOOL stop = NO;
        
        if (attribute) {
            objectDetail = CFDictionaryGetValue(attribute->_selectMap, (__bridge const void *)(NSStringFromSelector(invocaion.selector)));
        }
        
        DPRuntimeSwizzleAttributeMap *beforeMap = [DPRuntimeSwizzleAttributeMap new];
        DPRuntimeSwizzleAttributeMap *afterMap = [DPRuntimeSwizzleAttributeMap new];
        beforeMap->stop = &stop;
        Class performClass = [self class];
        while (performClass != nil) {
            DPRuntimeSwizzleAttribute * attributeClass = DPClassAttributeWithClass(performClass)->_attribute;
            if (attributeClass) {
                DPRuntimeSwizzleAttributeDetail * classDetail = CFDictionaryGetValue(attributeClass->_selectMap, (__bridge const void *)(NSStringFromSelector(invocaion.selector)));
                if (classDetail) {
                    [beforeMap appendDPRuntimeMap:classDetail->_beforeMap];
                    [afterMap insetDPRuntimeMap:classDetail->_afterMap];
                }
            }
            performClass = class_getSuperclass(performClass);
        }
        if (objectDetail) {
            [beforeMap appendDPRuntimeMap:objectDetail->_beforeMap];
            [afterMap appendDPRuntimeMap:objectDetail->_afterMap];
        }
        beforeMap->_object = self;
        beforeMap->_selector = invocaion.selector;
        afterMap->_object = self;
        afterMap->_selector = invocaion.selector;
        beforeMap->_block = ^(DPRuntimeObjectSwizzingBlock block){
            block(self, invocaion.selector,DPRuntimeMethodSwizzleOptionsBefore, tuple, &stop);
        };
        afterMap->_block = ^(DPRuntimeObjectSwizzingBlock block){
            BOOL _stop = NO;
            block(self, invocaion.selector,DPRuntimeMethodSwizzleOptionsAfter, tuple, &_stop);
        };
        afterMap->_finishBlock = ^(DPRuntimeSwizzleAttributeMap *map){
            stop = NO;
            [map dp_deallocMap];
        };
        beforeMap->_finishBlock = ^(DPRuntimeSwizzleAttributeMap *map){
            [map dp_deallocMap];
            if (stop) return;
            Class invocationClass = object_getClass(invocaion.target);
            SEL sel = DPNewForSelector(invocaion.selector);
            if ([invocationClass instancesRespondToSelector:sel]) {
                invocaion.selector = sel;
                [invocaion invoke];
            }
            [afterMap start];
        };
        [beforeMap start];
        
    });
    
    class_replaceMethod(class, forwadInvationSel, newImp, method_getTypeEncoding(forwadInvationMethod));
}

static Class DPSwizzleClass(NSObject * object){
    Class class = object.class;
    Class baseClass = object_getClass(object);
    if (class_isMetaClass(baseClass)) {
        for (unsigned int i = 0; i < [DPRuntime runtime].count; i++) {
            Class objecClass = [DPRuntime runtime].allClasses[i];
            Class selectedClass = objecClass;
            while (selectedClass != nil) {
                if (selectedClass == class) {
                    if (DPClassAttributeWithClass(objecClass)->_isSwizzled) break;
                    DPSwizzleForwardInvocation(objecClass);
                    DPClassAttributeWithClass(objecClass)->_isSwizzled = YES;
                    break;
                }else{
                    selectedClass = class_getSuperclass(selectedClass);
                }
            }
        }
        return class;
    };
    Class knownDynamicSubclass= DPClassAttributeWithClass(object)->_subClass;
    if (knownDynamicSubclass) return knownDynamicSubclass;
    if (baseClass!= class) {
        DPSwizzleForwardInvocation(baseClass);
        DPSwizzleRespondsToSelector(baseClass);
        DPSwizzleGetClass(baseClass, class);
        DPSwizzleGetClass(object_getClass(baseClass), class);
        DPSwizzleMethodSignatureForSelectore(baseClass);
        return baseClass;
    }
    
    const char *subclassName = [NSStringFromClass(class) stringByAppendingString:DPSubClassSuffix].UTF8String;
    Class subclass = objc_getClass(subclassName);
    if (subclass == nil) {
        subclass = objc_allocateClassPair(class, subclassName, 0);
        if (subclass == nil) return nil;
        DPSwizzleForwardInvocation(subclass);
        DPSwizzleRespondsToSelector(subclass);
        DPSwizzleGetClass(subclass, class);
        DPSwizzleGetClass(object_getClass(subclass), class);
        DPSwizzleMethodSignatureForSelectore(subclass);
        objc_registerClassPair(subclass);
    }
    object_setClass(object, subclass);
    
    DPClassAttributeWithClass(object)->_subClass = subclass;
    return subclass;
    
}
static void DPNSObjectSwizzle(SEL selector,id object){
    SEL newSel = DPNewForSelector(selector);
    Class class = DPSwizzleClass(object);
    Method method = class_getInstanceMethod(class, selector);
    IMP imp = method_getImplementation(method);
    if (imp != _objc_msgForward) {
        const char *typeEncoding = method_getTypeEncoding(method);
        Class orignClass = [class class];
        Method targetMethod;
        const void * key = (__bridge const void *)NSStringFromSelector(selector);
        DPRuntimeSwizzleAttribute *attribute = DPClassAttributeWithClass(orignClass)->_attribute;
        if (attribute) {
            DPRuntimeSwizzleAttributeDetail *detail = CFDictionaryGetValue(attribute->_selectMap,  key);
            if (!detail) {
                detail = [DPRuntimeSwizzleAttributeDetail new];
                CFDictionarySetValue(attribute->_selectMap, key,(__bridge void *)detail);
            }
            if (detail->_isSwizzled) {
                targetMethod = class_getClassMethod(orignClass, newSel);
            }else{
                targetMethod = method;
            }
            detail->_isSwizzled = YES;
        }else{
            targetMethod = method;
        }
        
        BOOL addedAlias __attribute__((unused)) = class_addMethod(class, newSel, method_getImplementation(targetMethod), typeEncoding);
        NSCAssert(addedAlias, @"Original implementation for %@ is already copied to %@ on %@", NSStringFromSelector(selector), NSStringFromSelector(newSel), class);
        
        class_replaceMethod(class, selector, _objc_msgForward, typeEncoding);
    }
}
static void ModelSetWithDictionaryFunction(const void *_key, const void *_value,void *_context) {
    DPRuntimeSwizzleAttributeDetail *detail = (__bridge DPRuntimeSwizzleAttributeDetail *)_value;
    [detail->_afterMap dp_deallocMap];
    [detail->_beforeMap dp_deallocMap];
    detail->_afterMap = nil;
    detail->_beforeMap = nil;
}

static void DPNSObjectAttribueAdd(id object, SEL selector, DPRuntimeMethodSwizzleOptions options, id block, DPPerformBlock performBlock){
    @synchronized (object) {
        id targetBlock = [block copy];
        DPRuntimeSwizzleAttribute *attribute = DPClassAttributeWithClass(object)->_attribute;
        if (!attribute) {
            attribute = [DPRuntimeSwizzleAttribute new];
            DPClassAttributeWithClass(object)->_attribute = attribute;
        }
        
        DPNSObjectSwizzle(selector, object);
        if (!object_isClass(object)) {
            [object dp_addDellocTask:^(id  _Nonnull self) {
                DPRuntimeSwizzleAttribute *attribute = DPClassAttributeWithClass(self)->_attribute;
                CFDictionaryApplyFunction(attribute->_selectMap,ModelSetWithDictionaryFunction, NULL);
            }];
        }
        const void * key = (__bridge const void *)NSStringFromSelector(selector);
        
        DPRuntimeSwizzleAttributeDetail *detail = CFDictionaryGetValue(attribute->_selectMap,  key);
        if (!detail) {
            detail = [DPRuntimeSwizzleAttributeDetail new];
            CFDictionarySetValue(attribute->_selectMap, key, (__bridge const void *)detail);
        }
        DPRuntimeSwizzleAttributeMapNode *node = [DPRuntimeSwizzleAttributeMapNode new];
        node->_perFormBlock = [performBlock copy];
        node->_swizzingBlock = targetBlock;
        if (options & DPRuntimeMethodSwizzleOptionsBefore) {
            [[detail beforemap] addDPRuntimeNode:node];
        }
        if(options & DPRuntimeMethodSwizzleOptionsAfter){
            [[detail aftermap] addDPRuntimeNode:node];
        }
    }
}


@implementation DPRuntimeTool


+ (void)swizzingWithObject:(id)object sel:(SEL)selector withOptions:(DPRuntimeMethodSwizzleOptions)options block:(DPRuntimeObjectSwizzingBlock)block{
    [self swizzingWithObject:object sel:selector withOptions:options block:block performBlock:^(DPBlock perform, id object, SEL sel) {
        perform();
    }];
}

+ (void)swizzingWithClass:(Class)clas sel:(SEL)selector withOptions:(DPRuntimeMethodSwizzleOptions)options block:(DPRuntimeObjectSwizzingBlock)block{
    [self swizzingWithClass:clas sel:selector withOptions:options block:block performBlock:^(DPBlock perform, id object, SEL sel) {
        perform();
    }];
}

+ (void)swizzingWithObject:(id)object sel:(SEL)selector withOptions:(DPRuntimeMethodSwizzleOptions)options block:(DPRuntimeObjectSwizzingBlock)block performBlock:(nonnull DPPerformBlock)performBlock{
    DPNSObjectAttribueAdd(object,selector, options,block, performBlock);
}

+ (void)swizzingWithClass:(Class)clas sel:(SEL)selector withOptions:(DPRuntimeMethodSwizzleOptions)options block:(DPRuntimeObjectSwizzingBlock)block performBlock:(nonnull DPPerformBlock)performBlock{
    DPNSObjectAttribueAdd(clas,selector, options,block, performBlock);
}


+ (void)swizzingWithClass:(Class)clas sel:(SEL)selector withNewSel:(SEL)newSelector{
    Method oldMehod;
    Method newMethod;
    BOOL (^checkBlock) (Method method)  = ^BOOL (Method method){
        return !isValidImp(method_getImplementation(method));
    };
    if (class_isMetaClass(clas)) {
        oldMehod = class_getClassMethod(clas, selector);
        if (checkBlock(oldMehod)) return;
        newMethod = class_getClassMethod(clas, newSelector);
        if (checkBlock(newMethod)) return;
    }else{
        oldMehod = class_getInstanceMethod(clas, selector);
        if (checkBlock(oldMehod)) return;
        newMethod = class_getInstanceMethod(clas, newSelector);
        if (checkBlock(newMethod)) return;
    }
    method_exchangeImplementations(oldMehod, newMethod);
}

+ (void)swizzingWithMetaClass:(Class)clas sel:(SEL)selector withNewSel:(SEL)newSelector{
    [self swizzingWithClass:object_getClass(clas) sel:selector withNewSel:newSelector];
}

@end
