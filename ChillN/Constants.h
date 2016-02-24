//
//  Constants.m
//  Abbvie
//
//  Created by Creatiwity on 08/08/2014.
//  Copyright (c) 2014 Creatiwity. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Localized(s) NSLocalizedString(s, @"")

#define CellHeight 44.0f
#define CellHeightSmall 34.0f
#define CellHeightTB 68.0f
#define CellHeightLarge 54.0f

#ifdef DEBUG
    #define GA_UID_IBD @"UA-72944921-1"
    #define GA_UID_RD  @"UA-72944921-3"
#else
    #define GA_UID_IBD @"UA-72944921-2"
    #define GA_UID_RD  @"UA-72944921-4"
#endif

@interface Constants : NSObject

@end
