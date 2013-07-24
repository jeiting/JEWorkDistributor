//
//  JEWorkDistributor.h
//  roosevelt
//
//  Created by Jacob Eiting on 7/23/13.
//  Copyright (c) 2013 Jacob Eiting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^JEWorkDistributorIsCompletedBlock)();

@interface JEWorkDistributor : NSObject

+ (id)repeatBlock:(dispatch_block_t)block until:(JEWorkDistributorIsCompletedBlock)isCompleted onComplete:(dispatch_block_t)completed;
- (void)start;
- (void)wait;

@end
