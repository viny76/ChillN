//
//  stringFromDateTranslate.m
//  Abbvie
//
//  Created by Vincent Jardel on 15/12/2015.
//  Copyright © 2015 Creatiwity. All rights reserved.
//

#import "StringFromDateTranslate.h"

@implementation StringFromDateTranslate

+ (NSString *)translateDate:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]  initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentDateComponents = [gregorian components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitYear
                                                           fromDate:date];
    
    date = [gregorian dateFromComponents:currentDateComponents];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] firstObject]];
    [formatter setLocale:locale];
    [formatter setDateFormat:Localized(@"DATE_FORMAT")];
    
    return [formatter stringFromDate:date];
}

+ (NSString *)translateTime:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]  initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentDateComponents = [gregorian components:NSCalendarUnitHour|NSCalendarUnitMinute
                                                           fromDate:date];
    
    date = [gregorian dateFromComponents:currentDateComponents];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] firstObject]];
    [formatter setLocale:locale];
    [formatter setDateFormat:Localized(@"TIME_FORMAT")];
    
    return [formatter stringFromDate:date];
}

@end
