#define singalton_h(name) +(instancetype)shared##name;
#if __has_feature(objc_arc)
#define  singalton_m(name) \
static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance=[super allocWithZone:zone];\
    });\
    return _instance;\
}\
+(instancetype)shared##name\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance=[[self alloc] init];\
    });\
    return _instance;\
}\
+(id)copyWithZone\
{\
    return _instance;\
}
#else
#define singalton_m(name) \
static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance=[super allocWithZone:zone];\
    });\
    return _instance;\
}\
+(instancetype)shared##name\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance=[[self alloc] init];\
    });\
    return _instance;\
}\
+(id)copyWithZone\
{\
    return _instance;\
}\
-(oneway void)release\
{\
}\
\
-(instancetype)retain\
{\
return _instance;\
}\
\
-(NSUInteger)retainCount\
{\
return 1;\
}
#endif