//
//  NSData+SDDataCache.h
//  SDCycleScrollView
//
//  Created by aier on 15-3-30.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (SDDataCache)

- (void)saveDataCacheWithIdentifier:(NSString *)identifier;
+ (NSData *)getDataCacheWithIdentifier:(NSString *)identifier;

@end
