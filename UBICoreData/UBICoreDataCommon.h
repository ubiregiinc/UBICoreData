//
//  UBICoreDataCommon.h
//
//  Created by Yuki Yasoshima on 2015/11/27.
//  Copyright (c) 2015 Yuki Yasoshima. All rights reserved.
//

#define UBI_SET_PREDICATE_WITH_VARIADIC_ARGS \
    NSPredicate* predicate = nil; \
    if ([predicateOrString isKindOfClass:[NSString class]]) { \
        va_list args; \
        va_start(args, predicateOrString); \
        predicate = [NSPredicate predicateWithFormat:predicateOrString arguments:args]; \
        va_end(args); \
    } else if ([predicateOrString isKindOfClass:[NSPredicate class]]) { \
        predicate = predicateOrString; \
    } else { \
        NSAssert(0, @"invalid predicate: %@", predicateOrString); \
    }
