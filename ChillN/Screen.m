//
//  Screen.m
//  Abbvie
//
//  Created by Creatiwity on 08/08/2014.
//  Copyright (c) 2014 Creatiwity. All rights reserved.
//

#import "Screen.h"

@implementation Screen

+ (float)width {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    return screenSize.width;
}

+ (float)height {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    return screenSize.height;
}

@end
