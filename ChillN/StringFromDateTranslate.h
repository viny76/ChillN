//
//  stringFromDateTranslate.h
//  Abbvie
//
//  Created by Vincent Jardel on 15/12/2015.
//  Copyright © 2015 Creatiwity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface StringFromDateTranslate : NSObject

+ (NSString *)translateDate:(NSDate *)date;
+ (NSString *)translateTime:(NSDate *)date;

@end
