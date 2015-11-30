//
//  TestHelpers.h
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-11-15.
//  Copyright © 2015 Hirad Motamed. All rights reserved.
//

#ifndef TestHelpers_h
#define TestHelpers_h

#define CHECK_ARG(__BOOL_EXPR__) [OCMArg checkWithBlock:^BOOL(id arg) { \
    return __BOOL_EXPR__; \
}]

#endif /* TestHelpers_h */
