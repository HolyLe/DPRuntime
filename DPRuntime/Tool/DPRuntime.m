//
//  DPRuntimeTool.m
//  DiamondPark
//
//  Created by 麻小亮 on 2019/4/15.
//  Copyright © 2019 DiamondPark. All rights reserved.
//

#import "DPRuntime.h"
#import "DPRuntimeTool.h"


@interface DPRuntime ()

@property (nonatomic) Class _Nonnull *_Nullable  allClasses;

@property (nonatomic, assign) unsigned int count;

//@property (nonatomic, strong) NSMutableSet * swizzledClass;

@property (nonatomic, strong) NSMutableSet * deallocSet;



@end

@implementation DPRuntime

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unsigned int count;
        Class *classes = objc_copyClassList(&count);
        DPRuntime *runtime = [DPRuntime runtime];
        runtime.allClasses = classes;
        runtime.count = count;
        for (unsigned int i = 0; i < count; i++) {
            Class clas = classes[i];
            BOOL isConformsToPro = class_conformsToProtocol(clas, objc_getProtocol("DPRuntimeProtocol"));
            if (!isConformsToPro) {
                Class superClass = class_getSuperclass(clas);
                while (superClass != clas && superClass != NULL) {
                    isConformsToPro = class_conformsToProtocol(superClass, objc_getProtocol("DPRuntimeProtocol"));
                    if (isConformsToPro) {
                        break;
                    }
                    superClass = class_getSuperclass(superClass);
                }
            }
            if (isConformsToPro) {
                
                Class metaClass = object_getClass(clas);
                SEL requireSel = sel_registerName("dp_runtimeRequireClasses:");
                SEL sel = sel_registerName("dp_runtimeRequireClasses:currentClass:count:");
                BOOL isShouldBack = YES;
                IMP imp = class_getMethodImplementation(metaClass, requireSel);
                if (imp != NULL && imp != _objc_msgForward) {
                    isShouldBack = ((BOOL (*) (id, SEL, Class))imp)(metaClass,sel, clas);
                }
                if (!isShouldBack) continue;
                
                imp = class_getMethodImplementation(metaClass, sel);
                if (isValidImp(imp)) {
                    ((void (*) (id, SEL, Class *, Class, unsigned))imp)(metaClass,sel, classes, clas,count);
                }
                
                SEL requiredEachsel = sel_registerName("dp_runtimeRequiredEachClasses:currentClass:");
                
                imp = class_getMethodImplementation(metaClass, requiredEachsel);
                if (isValidImp(imp)) {
                    for (unsigned int j = 0; j < count; j++) {
                        ((void (*) (id, SEL, Class , Class))imp)(metaClass,requiredEachsel, classes[j], clas);
                    }
                }
                SEL classMethodsel = sel_registerName("dp_runtimeClassEachMethod:");
                
                imp = class_getMethodImplementation(metaClass, classMethodsel);
                if (isValidImp(imp)) {
                    unsigned int methodCount;
                    Method *method = class_copyMethodList(clas, &methodCount);
                    for (int j = 0; j < methodCount; j++) {
                        ((void (*) (id, SEL, Method))imp)(metaClass,classMethodsel, method[j]);
                    }
                }
                SEL objectMethodsel = sel_registerName("dp_runtimeObjectEachMethod:");
                
                imp = class_getMethodImplementation(clas, objectMethodsel);
                if (isValidImp(imp)) {
                    unsigned int methodCount;
                    Method *method = class_copyMethodList(clas, &methodCount);
                    for (int j = 0; j < methodCount; j++) {
                        ((void (*) (id, SEL, Method))imp)(clas,objectMethodsel, method[j]);
                    }
                }
            }
        }
    });
}

+ (DPRuntime *)runtime{
    static DPRuntime *runtime = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        runtime = [DPRuntime new];
        [runtime deallocSet];
        
    });
    
    return runtime;
}

- (NSMutableSet *)deallocSet{
    if (!_deallocSet) {
        _deallocSet = [NSMutableSet set];
    }
    return _deallocSet;
}



@end


static const void *DPRuntimeDeallocTasks = &DPRuntimeDeallocTasks;
static inline void dp_swizzleDeallocIfNeed(Class swizzleClass){
    NSMutableSet *deallocSet = [DPRuntime runtime].deallocSet;
    @synchronized (deallocSet) {
        NSString *className = NSStringFromClass(swizzleClass);
        if ([deallocSet containsObject:className]) return;
        SEL deallocSelector = sel_registerName("dealloc");
        
        __block void (* oldImp) (__unsafe_unretained id, SEL) = NULL;
        
        id newImpBlock = ^ (__unsafe_unretained id self){
            
            NSMutableArray *deallocTask = objc_getAssociatedObject(self, &DPRuntimeDeallocTasks);
            @synchronized (deallocTask) {
                if (deallocTask.count > 0) {
                    [deallocTask enumerateObjectsUsingBlock:^(dp_deallocTask obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj) {
                            obj(self);
                        }
                    }];
                    [deallocTask removeAllObjects];
                }
            }
            if (oldImp == NULL) {
                struct objc_super supperInfo = {
                    .receiver = self,
                    .super_class = class_getSuperclass(swizzleClass)
                };
                ((void (*) (struct objc_super *, SEL))objc_msgSendSuper)(&supperInfo, deallocSelector);
            }else{
                oldImp(self,deallocSelector);
            }
        };
        IMP newImp = imp_implementationWithBlock(newImpBlock);
        if (!class_addMethod(swizzleClass, deallocSelector, newImp, "v@:")) {
            Method deallocMethod = class_getInstanceMethod(swizzleClass, deallocSelector);
            oldImp = (__typeof__ (oldImp))method_getImplementation(deallocMethod);
            oldImp = (__typeof__ (oldImp))method_setImplementation(deallocMethod, newImp);
        }
        [deallocSet addObject:className];
    }
}

@implementation NSObject (DPRuntime)



- (void)dp_swizzingWithSel:(SEL)selector withOptions:(DPRuntimeMethodSwizzleOptions)options block:(DPRuntimeObjectSwizzingBlock)block{
    [DPRuntimeTool swizzingWithObject:self sel:selector withOptions:options block:block];
}
- (void)dp_swizzingWithSel:(SEL)selector withOptions:(DPRuntimeMethodSwizzleOptions)options block:(DPRuntimeObjectSwizzingBlock)block performBlock:(DPPerformBlock)performBlock{
    [DPRuntimeTool swizzingWithObject:self sel:selector withOptions:options block:block performBlock:performBlock];
}

- (void)dp_swizzingClassWithSel:(SEL)selector newSelector:(SEL)newSelector{
    [DPRuntimeTool swizzingWithClass:[self class] sel:selector withNewSel:newSelector];
}
- (void)dp_swizzingMetaClassWithSel:(SEL)selector newSelector:(SEL)newSelector{
    [DPRuntimeTool swizzingWithMetaClass:[self class] sel:selector withNewSel:newSelector];
}
- (NSMutableArray<dp_deallocTask> *)dp_deallocTasks{
    NSMutableArray *tasks = objc_getAssociatedObject(self, &DPRuntimeDeallocTasks);
    if (tasks) return tasks;
    tasks = [NSMutableArray array];
    dp_swizzleDeallocIfNeed(object_getClass(self));
    objc_setAssociatedObject(self, &DPRuntimeDeallocTasks, tasks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return tasks;
}

- (void)dp_addDellocTask:(dp_deallocTask)task{
    @synchronized ([self dp_deallocTasks]) {
        [[self dp_deallocTasks] addObject:task];
    }
}
@end



