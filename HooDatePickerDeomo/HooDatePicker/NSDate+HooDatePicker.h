//
//  NSDate+HooDatePicker.h
//  HooDatePickerDeomo
//
//  Created by hujianghua on 6/21/16.
//  Copyright © 2016 hujianghua. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kDateFormatYYYYMMDD;
extern NSString *const kDateFormatYYMMDDTHHmmss;


@interface NSDate (HooDatePicker)

+ (NSDateFormatter *)shareDateFormatter;

- (NSInteger)daysBetween:(NSDate *)aDate;

- (NSDate *)dateByAddingDays:(NSInteger)days;

- (NSString *)stringForFormat:(NSString *)format;


@end

@interface NSCalendar (AT)

+ (instancetype)sharedCalendar;

@end
