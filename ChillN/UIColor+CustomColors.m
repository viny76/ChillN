//
//  UIColor+CustomColors.m
//  Abbvie
//
//  Created by Jeirgino Ranarivelo on 07/08/2014.
//  Copyright (c) 2014 Creatiwity. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

// Wall weight graph background + Calendar future medication to take point color
+ (UIColor *)colorGraphBackground {
    return [UIColor colorWithRed:153.0/255.0 green:200.0/255.0f blue:255.0/255.0f alpha:1.0f];
}

// Color used in the line gray border
+ (UIColor *)colorBorder {
    return [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0f alpha:1.0];
}

// Gray color for text on a white bg: header label title color + calendar day next month
+ (UIColor *)colorHeaderLabel {
    return [UIColor colorWithRed:138.0/255.0 green:142.0/255.0 blue:145.0/255.0f alpha:1.0];
}

// Color used in Wall filter background: HeaderView background + Settings + Wall (selected bg button)
+ (UIColor *)colorHeaderViewBackground {
    return [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0f alpha:1.0];
}

// Switch tint color
+ (UIColor *)colorSwitchTintColor {
    return [UIColor colorWithRed:45.0/255.0 green:58.0/255.0 blue:75.0/255.0f alpha:1.0];
}

// Color used in Wall: Weight and Regions button not selected + wall cell regions label color
+ (UIColor *)colorWallRegionsButton {
    return [UIColor colorWithRed:27.0/255.0 green:142.0/255.0 blue:199.0/255.0f alpha:1.0];
}

// Color used in button to display a link color: Nav bar + Button + day calendar + wall (non-selected bg button) + pageView dot
+ (UIColor *)colorPrimaryButton {
    return [UIColor colorWithRed:0.0/255.0 green:163.0/255.0 blue:236.0/255.0f alpha:1.0];
}

// Color used in wall for selected period (color background) on weight graph
+ (UIColor *)colorGraphPeriodSelected {
    return [UIColor colorWithRed:172/255.0f green:210/255.0f blue:244/255.0f alpha:1.0f];
}

// Color used in Gamification
+ (UIColor *)colorScoreGamificationBackground {
    return [UIColor colorWithRed:242/255.0f green:245/255.0f blue:250/255.0f alpha:1.0f];
}

+ (UIColor *)colorScoreGamificationLabel {
    return [UIColor colorWithRed:52/255.0f green:66/255.0f blue:84/255.0f alpha:1.0f];
}

+ (UIColor *)colorLowScoreGamification {
    return [UIColor colorWithRed:246/255.0f green:74/255.0f blue:81/255.0f alpha:1.0f];
}

+ (UIColor *)colorMiddleScoreGamification {
    return [UIColor colorWithRed:251/255.0f green:160/255.0f blue:89/255.0f alpha:1.0f];
}

+ (UIColor *)colorHighScoreGamification {
    return [UIColor colorWithRed:160/255.0f green:224/255.0f blue:97/255.0f alpha:1.0f];
}

// Color used in calendar: color number of day
+ (UIColor *)colorNumberDayCalendar {
    return [UIColor colorWithRed:25.f/255.f green:63.f/255.f blue:93.f/255.f alpha:1.f];
}

// Color used for UIButton in cell and label in Treatment
+ (UIColor *)colorLabelAndButtonCell {
    return [UIColor colorWithRed:0/255.f green:163/255.f blue:241/255.f alpha:1.f];
}

// Color used in TextView for Placeholder
+ (UIColor *)colorTextViewPlaceholder {
    return [UIColor colorWithRed:127.f/255.f green:127.f/255.f blue:127.f/255.f alpha:1.f];
}

@end
