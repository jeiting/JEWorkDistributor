//
//  JEWorkDistributor.m
//  roosevelt
//
//  Created by Jacob Eiting on 7/23/13.
//  Copyright (c) 2013 Jacob Eiting. All rights reserved.
//

#import "JEWorkDistributor.h"

@interface JEWorkDistributor ()

@property (nonatomic, copy) dispatch_block_t workBlock;
@property (nonatomic, copy) JEWorkDistributorIsCompletedBlock isCompleteBlock;
@property (nonatomic, copy) dispatch_block_t completed;

@property (nonatomic, copy) dispatch_block_t repeatBlock;

@property (nonatomic, strong) dispatch_group_t group;

@end

@implementation JEWorkDistributor

+ (id)repeatBlock:(dispatch_block_t)block until:(JEWorkDistributorIsCompletedBlock)isCompleted onComplete:(dispatch_block_t)completed
{
    JEWorkDistributor *distributor = [[JEWorkDistributor alloc] init];
    
    distributor.workBlock = block;
    distributor.isCompleteBlock = isCompleted;
    distributor.completed = completed;
    
    [distributor start];
    
    return distributor;
}

- (void)start
{
    self.group = dispatch_group_create();
    
    __block JEWorkDistributor *weakSelf = self;
    self.repeatBlock = ^{
        
        weakSelf.workBlock();
        
        if (!weakSelf.isCompleteBlock())
        {
            dispatch_group_async(weakSelf.group, dispatch_get_main_queue(), weakSelf.repeatBlock);
        }
        else
        {
            weakSelf.completed();
            weakSelf.repeatBlock = nil;
            weakSelf.isCompleteBlock = nil;
            weakSelf.workBlock = nil;
        }
    };
    
    self.repeatBlock();
}

- (void)wait
{
    dispatch_group_wait(self.group, DISPATCH_TIME_FOREVER);
}

@end
