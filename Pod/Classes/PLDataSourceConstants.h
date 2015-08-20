//
//  PLDataSourceConstants.h
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-07-27.
//  Copyright (c) 2015 Pendar Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef PLDataSource_PLDataSourceConstants_h
#define PLDataSource_PLDataSourceConstants_h

#define THROW_UNIMPLEMENTED_METHOD_EXCEPTION @throw \
[NSException exceptionWithName:PLUnimplementedMethodException \
reason:[NSString stringWithFormat:@"%@ subclasses must override `%@`.",\
NSStringFromClass([self class]), NSStringFromSelector(_cmd)] \
userInfo:nil]

extern NSString* const PLUnimplementedMethodException;

#endif
