//
//  HooDatePicker.h
//  HooDatePickerDeomo
//
//  Created by hujianghua on 3/5/16.
//  Copyright © 2016 hujianghua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HooDatePickerMode) {
    HooDatePickerModeTime,
    HooDatePickerModeDate,
    HooDatePickerModeDateAndTime,
    HooDatePickerModeYearAndMonth
};

@class HooDatePicker;

@protocol HooDatePickerDelegate<NSObject>
@optional
- (void)datePicker:(HooDatePicker *)datePicker dateDidChange:(NSDate *)date;
- (void)datePicker:(HooDatePicker *)datePicker clickedCancelButton:(UIButton *)sender;
- (void)datePicker:(HooDatePicker *)datePicker clickedSureButton:(UIButton *)sender date:(NSDate*)date;
@end

@interface HooDatePicker : UIControl

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSDate *date;
/**
 *  specify min/max date range. default is nil. When min > max, the values are ignored.
 */
@property (nonatomic, strong) NSDate *minimumDate;

@property (nonatomic, strong) NSDate *maximumDate;

@property (nonatomic, assign) HooDatePickerMode datePickerMode;
/**
 *  default is [NSLocale currentLocale]. setting nil returns to default
 */
@property(nonatomic,retain) NSLocale      *locale;
/**
 *  default is [NSCalendar currentCalendar]. setting nil returns to default
 */
@property(nonatomic,copy)   NSCalendar    *calendar;
/**
 *   default is nil. use current time zone or time zone from calendar
 */
@property(nonatomic,retain) NSTimeZone    *timeZone;

@property (nonatomic, strong) NSObject<HooDatePickerDelegate> *delegate;
/**
 *  read only property, indicate in datepicker is open.
 */
@property(nonatomic,readonly) BOOL        isOpen;

- (instancetype)initWithSuperView:(UIView*)superView;

- (void)show;

- (void)dismiss;

- (void)setDate:(NSDate *)date animated:(BOOL)animated;

- (void)setTintColor:(UIColor *)tintColor;

- (void)setHighlightColor:(UIColor *)highlightColor;
@end
