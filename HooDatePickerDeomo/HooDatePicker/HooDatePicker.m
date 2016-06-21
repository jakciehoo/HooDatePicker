//
//  HooDatePicker.m
//  HooDatePickerDeomo
//
//  Created by hujianghua on 3/5/16.
//  Copyright © 2016 hujianghua. All rights reserved.
//

#import "HooDatePicker.h"

// Constants :
static NSString  * const kSureButtonItemTitle = @"确定";
static NSString  * const kCancelButtonItemTitle = @"取消";

// Constants sizes :
static CGFloat const kHooDatePickerHeight = 260.0f;

static CGFloat const kHooDatePickerHeaderHeight = 44.0f;

static CGFloat const kHooDatePickerButtonHeaderWidth = 40.0f;

static CGFloat const kHooDatePickerHeaderBottomMargin = 1.0f;

static CGFloat const kHooDatePickerScrollViewDaysWidth = 90.0f;

static CGFloat const kHooDatePickerScrollViewMonthWidth = 140.0f;

static CGFloat const kHooDatePickerScrollViewDateWidth = 165.0f;

static CGFloat const kHooDatePickerScrollViewLeftMargin = 1.0f;

static CGFloat const kHooDatePickerScrollViewItemHeight = 45.0f;

static CGFloat const kHooDatePickerLineWidth = 2.0f;

static CGFloat const kHooDatePickerLineMargin = 15.0f;

static CGFloat const kHooDatePickerPadding = 15.0f;

// Constants times :
static CGFloat const kHooDatePickerAnimationDuration = 0.4f;

// Constants fonts
#define kHooDatePickerTitleFont [UIFont systemFontOfSize:18.0]
#define kHooDatePickerLabelFont [UIFont systemFontOfSize:18.0]
#define kHooDatePickerLabelSelectedFont [UIFont systemFontOfSize:20.0];

// Constants colors :
#define kHooDatePickerTintColor [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]
#define kHooDatePickerHighlightColor [UIColor colorWithRed:255.0/255.0 green:180.0/255.0 blue:18.0/255.0 alpha:1.0]
#define kHooDatePickerBackgroundColor [UIColor colorWithRed:244/255.0 green:242/255.0 blue:248/255.0 alpha:1.0]
#define kHooDatePickerScrolViewBackgroundColor [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define kHooDatePickerTitleFontColor kHooDatePickerTintColor
#define kHooDatePickerFontColorLabel kHooDatePickerTintColor
#define kHooDatePickerFontColorLabelSelected kHooDatePickerHighlightColor
#define kHooDatePickerBackgroundColorLines kHooDatePickerHighlightColor

typedef NS_ENUM(NSInteger,ScrollViewTagValue) {
    ScrollViewTagValue_DAYS = 1,
    ScrollViewTagValue_MONTHS = 2,
    ScrollViewTagValue_YEARS = 3,
    ScrollViewTagValue_HOURS = 4,
    ScrollViewTagValue_MINUTES = 5,
    ScrollViewTagValue_SECONDS = 6,
    ScrollViewTagValue_DATES = 7,
    
};

@interface HooDatePicker ()<UIScrollViewDelegate> {
    // Lines :
    UIView *_lineDaysTop, *_lineDaysBottom, *_lineMonthsTop, *_lineMonthsBottom, *_lineYearsTop,*_lineYearsBottom, *_lineDatesTop, *_lineDatesBottom, *_lineHoursTop, *_lineHoursBottom, *_lineMinutesTop, *_lineMinutesBottom, *_lineSecondsTop, *_lineSecondsBottom;
    
    // Labels :
    NSMutableArray *_labelsDays, *_labelsMonths, *_labelsYears, *_labelsDates, *_labelsHours, *_labelsMinutes, *_labelsSeconds;
    
    // Date and time selected :
    NSInteger _selectedDay,  _selectedMonth, _selectedYear,  _selectedDate, _selectedHour, _selectedMinute,  _selectedSecond;
    
    // First init flag :
    BOOL _isInitialized;
    NSInteger _minYear;

}

// Data of years, months, days, dates, hours, minutes, seconds
@property (nonatomic, strong) NSMutableArray *years, *months, *days, *dates, *hours, *minutes, *seconds;

// ScrollView for Years, Months, days ,Dates ,Hours ,Minute ,Seconds
@property (nonatomic, strong) UIScrollView *scrollViewYears, *scrollViewMonths, *scrollViewDays, *scrollViewDates, *scrollViewHours, *scrollViewMinutes,*scrollViewSeconds;

@property (nonatomic, weak) UIView *superView;

@property (nonatomic, copy) UIView *dimBackgroundView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) UIColor *highlightColor;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation HooDatePicker


#pragma mark - Initializers

- (instancetype)initWithSuperView:(UIView*)superView {
    
    
    if (self = [super initWithFrame:CGRectMake(0.0, superView.frame.size.height, superView.frame.size.width, kHooDatePickerHeight)]) {
        _datePickerMode = HooDatePickerModeDate;
        [superView addSubview:self];
        _superView = superView;
        _minYear = 1900;
        self.tintColor = kHooDatePickerTintColor;
        self.highlightColor = kHooDatePickerHighlightColor;
        [self addSubview:self.headerView];
        [self setupControl];
    }
    return self;
}

- (instancetype)initDatePickerMode:(HooDatePickerMode)datePickerMode andAddToSuperView:(UIView *)superView {
    if (self = [super initWithFrame:CGRectMake(0.0, superView.frame.size.height, superView.frame.size.width, kHooDatePickerHeight)]) {
        _datePickerMode = datePickerMode;
        [superView addSubview:self];
        _superView = superView;
        _minYear = 1900;
        self.tintColor = kHooDatePickerTintColor;
        self.highlightColor = kHooDatePickerHighlightColor;
        [self addSubview:self.headerView];
        [self setupControl];
    }
    return self;
}

- (instancetype)initDatePickerMode:(HooDatePickerMode)datePickerMode minDate:(NSDate *)minimumDate maxMamDate:(NSDate *)maximumDate  andAddToSuperView:(UIView *)superView {
    if (self = [super initWithFrame:CGRectMake(0.0, superView.frame.size.height, superView.frame.size.width, kHooDatePickerHeight)]) {
        _datePickerMode = datePickerMode;
        [superView addSubview:self];
        _superView = superView;
        _minYear = 1900;
        if (maximumDate) {
            _maximumDate = maximumDate;
        }
        if (minimumDate) {
            _minimumDate = minimumDate;
            
            NSDateComponents* componentsMin = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_minimumDate];
            NSInteger yearMin = [componentsMin year];
            _minYear = yearMin;
        }
        self.tintColor = kHooDatePickerTintColor;
        self.highlightColor = kHooDatePickerHighlightColor;
        [self addSubview:self.headerView];
        [self setupControl];
    }
    return self;
}

- (void)setupControl {
    
    // Set parent View :
    self.hidden = YES;
    
    // Clear old selectors
    [self removeSelectorYears];
    [self removeSelectorMonths];
    [self removeSelectorDays];
    [self removeSelectorHours];
    [self removeSelectorMinutes];
    [self removeSelectorSeconds];
    
    // Generate collections days, months, years, hours, minutes and seconds :
    _years = [self getYears];
    _days = [self getDaysInMonth:[NSDate date]];
    if (self.datePickerMode == HooDatePickerModeDateAndTime) {
        _dates = [self getDates];
    }
    
    // Background :
    self.backgroundColor = kHooDatePickerBackgroundColor;
    
    // Date Selectors :
    if (self.datePickerMode == HooDatePickerModeDate) {
        [self buildSelectorYearsOffsetX:0.0 andWidth:kHooDatePickerScrollViewMonthWidth];
        [self buildSelectorMonthsOffsetX:(_scrollViewYears.frame.size.width + kHooDatePickerScrollViewLeftMargin) andWidth:kHooDatePickerScrollViewDaysWidth];
        [self buildSelectorDaysOffsetX:(_scrollViewMonths.frame.origin.x + _scrollViewMonths.frame.size.width + kHooDatePickerScrollViewLeftMargin) andWidth:(self.frame.size.width - (_scrollViewMonths.frame.origin.x + _scrollViewMonths.frame.size.width + kHooDatePickerScrollViewLeftMargin))];
    }
    
    // Time Selectors :
    if (self.datePickerMode == HooDatePickerModeTime) {
        [self buildSelectorHoursOffsetX:0.0 andWidth:((self.frame.size.width / 3.0) - kHooDatePickerScrollViewLeftMargin)];
        [self buildSelectorMinutesOffsetX:(self.frame.size.width / 3.0) andWidth:((self.frame.size.width / 3.0) - kHooDatePickerScrollViewLeftMargin)];
        [self buildSelectorSecondsOffsetX:((self.frame.size.width / 3.0) * 2.0) andWidth:(self.frame.size.width / 3.0)];
    }
    
    // Date & Time Selectors :
    if (self.datePickerMode == HooDatePickerModeDateAndTime) {
        [self buildSelectorDatesOffsetX:0.0 andWidth:kHooDatePickerScrollViewDateWidth];
        [self buildSelectorHoursOffsetX:(kHooDatePickerScrollViewDateWidth + kHooDatePickerScrollViewLeftMargin) andWidth:(((self.frame.size.width - kHooDatePickerScrollViewDateWidth) / 2.0) - kHooDatePickerScrollViewLeftMargin)];
        [self buildSelectorMinutesOffsetX:(kHooDatePickerScrollViewDateWidth + kHooDatePickerScrollViewLeftMargin + ((self.frame.size.width - kHooDatePickerScrollViewDateWidth) / 2.0)) andWidth:(((self.frame.size.width - kHooDatePickerScrollViewDateWidth) / 2.0) - kHooDatePickerScrollViewLeftMargin)];
    }
    
    if (self.datePickerMode == HooDatePickerModeYearAndMonth) {
        [self buildSelectorYearsOffsetX:0.0 andWidth:self.frame.size.width * 0.5];
        [self buildSelectorMonthsOffsetX:(_scrollViewYears.frame.size.width + kHooDatePickerScrollViewLeftMargin) andWidth:self.frame.size.width * 0.5];
        
    }
    
    // Defaut Date selected :
    [self setDate:[NSDate date] animated:NO];
}


#pragma mark - Build Selector Days

- (void)buildSelectorDaysOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Days :
    _scrollViewDays = [[UIScrollView alloc] initWithFrame:CGRectMake(x, kHooDatePickerHeaderHeight + kHooDatePickerHeaderBottomMargin, width, self.frame.size.height - kHooDatePickerHeaderHeight - kHooDatePickerHeaderBottomMargin)];
    _scrollViewDays.tag = ScrollViewTagValue_DAYS;
    _scrollViewDays.delegate = self;
    _scrollViewDays.backgroundColor = kHooDatePickerScrolViewBackgroundColor;
    _scrollViewDays.showsHorizontalScrollIndicator = NO;
    _scrollViewDays.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollViewDays];
    
    _lineDaysTop = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewDays.frame.origin.x + kHooDatePickerLineMargin, _scrollViewDays.frame.origin.y + (_scrollViewDays.frame.size.height / 2) - (kHooDatePickerScrollViewItemHeight / 2), width - (2 * kHooDatePickerLineMargin), kHooDatePickerLineWidth)];
    _lineDaysTop.backgroundColor = self.highlightColor;
    [self addSubview:_lineDaysTop];
    
    _lineDaysBottom = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewDays.frame.origin.x + kHooDatePickerLineMargin, _scrollViewDays.frame.origin.y + (_scrollViewDays.frame.size.height / 2) + (kHooDatePickerScrollViewItemHeight / 2), width - (2 * kHooDatePickerLineMargin), kHooDatePickerLineWidth)];
    _lineDaysBottom.backgroundColor = self.highlightColor;
    [self addSubview:_lineDaysBottom];
    
    // Update ScrollView Data
    [self buildSelectorLabelsDays];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureDaysCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scrollViewDays addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsDays {
    
    CGFloat offsetContentScrollView = (_scrollViewYears.frame.size.height - kHooDatePickerScrollViewItemHeight) / 2.0;
    
    if (_labelsDays && _labelsDays.count > 0) {
        for (UILabel *label in _labelsDays) {
            [label removeFromSuperview];
        }
    }
    
    _labelsDays = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _days.count; i++) {
        
        NSString *day = (NSString*)[_days objectAtIndex:i];
        
        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0, (i * kHooDatePickerScrollViewItemHeight) + offsetContentScrollView, _scrollViewDays.frame.size.width, kHooDatePickerScrollViewItemHeight)];
        labelDay.text = day;
        labelDay.font = kHooDatePickerLabelFont;
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = self.tintColor;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [_labelsDays addObject:labelDay];
        [_scrollViewDays addSubview:labelDay];
    }
    
    _scrollViewDays.contentSize = CGSizeMake(_scrollViewDays.frame.size.width, (kHooDatePickerScrollViewItemHeight * _days.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorDays {
    
    if (_scrollViewDays) {
        [_scrollViewDays removeFromSuperview];
        _scrollViewDays = nil;
    }
    if (_lineDaysTop) {
        [_lineDaysTop removeFromSuperview];
        _lineDaysTop = nil;
    }
    if (_lineDaysBottom) {
        [_lineDaysBottom removeFromSuperview];
        _lineDaysBottom = nil;
    }
}

#pragma mark - Build Selector Months

- (void)buildSelectorMonthsOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Months
    
    _scrollViewMonths = [[UIScrollView alloc] initWithFrame:CGRectMake(x, kHooDatePickerHeaderHeight + kHooDatePickerHeaderBottomMargin, width, self.frame.size.height - kHooDatePickerHeaderHeight - kHooDatePickerHeaderBottomMargin)];
    _scrollViewMonths.tag = ScrollViewTagValue_MONTHS;
    _scrollViewMonths.delegate = self;
    _scrollViewMonths.backgroundColor = kHooDatePickerScrolViewBackgroundColor;
    _scrollViewMonths.showsHorizontalScrollIndicator = NO;
    _scrollViewMonths.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollViewMonths];
    
    _lineMonthsTop = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewMonths.frame.origin.x + kHooDatePickerLineMargin, _scrollViewMonths.frame.origin.y + (_scrollViewMonths.frame.size.height / 2) - (kHooDatePickerScrollViewItemHeight / 2), width - (2 * kHooDatePickerLineMargin), kHooDatePickerLineWidth)];
    _lineMonthsTop.backgroundColor = self.highlightColor;
    [self addSubview:_lineMonthsTop];
    
    _lineMonthsBottom = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewMonths.frame.origin.x + kHooDatePickerLineMargin, _scrollViewMonths.frame.origin.y + (_scrollViewMonths.frame.size.height / 2) + (kHooDatePickerScrollViewItemHeight / 2), width - (2 * kHooDatePickerLineMargin), kHooDatePickerLineWidth)];
    _lineMonthsBottom.backgroundColor = self.highlightColor;
    [self addSubview:_lineMonthsBottom];
    
    
    // Update ScrollView Data
    [self buildSelectorLabelsMonths];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureMonthsCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scrollViewMonths addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsMonths {
    
    CGFloat offsetContentScrollView = (_scrollViewYears.frame.size.height - kHooDatePickerScrollViewItemHeight) / 2.0;
    
    if (_labelsMonths && _labelsMonths.count > 0) {
        for (UILabel *label in _labelsMonths) {
            [label removeFromSuperview];
        }
    }
    
    _labelsMonths = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.months.count; i++) {
        
        NSString *day = (NSString*)[self.months objectAtIndex:i];
        
        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (i * kHooDatePickerScrollViewItemHeight) + offsetContentScrollView, _scrollViewMonths.frame.size.width, kHooDatePickerScrollViewItemHeight)];
        labelDay.text = day;
        labelDay.font = kHooDatePickerLabelFont;
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = self.tintColor;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [_labelsMonths addObject:labelDay];
        [_scrollViewMonths addSubview:labelDay];
    }
    
    _scrollViewMonths.contentSize = CGSizeMake(_scrollViewMonths.frame.size.width, (kHooDatePickerScrollViewItemHeight * self.months.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorMonths {
    
    if (_scrollViewMonths) {
        [_scrollViewMonths removeFromSuperview];
        _scrollViewMonths = nil;
    }
    if (_lineMonthsTop) {
        [_lineMonthsTop removeFromSuperview];
        _lineMonthsTop = nil;
    }
    if (_lineMonthsBottom) {
        [_lineMonthsBottom removeFromSuperview];
        _lineMonthsBottom = nil;
    }
}

#pragma mark - Build Selector Years

- (void)buildSelectorYearsOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Years
    
    _scrollViewYears = [[UIScrollView alloc] initWithFrame:CGRectMake(x, kHooDatePickerHeaderHeight + kHooDatePickerHeaderBottomMargin, width, self.frame.size.height - kHooDatePickerHeaderHeight - kHooDatePickerHeaderBottomMargin)];
    _scrollViewYears.tag = ScrollViewTagValue_YEARS;
    _scrollViewYears.delegate = self;
    _scrollViewYears.backgroundColor = kHooDatePickerScrolViewBackgroundColor;
    _scrollViewYears.showsHorizontalScrollIndicator = NO;
    _scrollViewYears.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollViewYears];
    
    _lineYearsTop = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewYears.frame.origin.x + kHooDatePickerLineMargin, _scrollViewYears.frame.origin.y + (_scrollViewYears.frame.size.height / 2) - (kHooDatePickerScrollViewItemHeight / 2), width - (2 * kHooDatePickerLineMargin), kHooDatePickerLineWidth)];
    _lineYearsTop.backgroundColor = self.highlightColor;
    [self addSubview:_lineYearsTop];
    
    _lineYearsBottom = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewYears.frame.origin.x + kHooDatePickerLineMargin, _scrollViewYears.frame.origin.y + (_scrollViewYears.frame.size.height / 2) + (kHooDatePickerScrollViewItemHeight / 2), width - (2 * kHooDatePickerLineMargin), kHooDatePickerLineWidth)];
    _lineYearsBottom.backgroundColor = self.highlightColor;
    [self addSubview:_lineYearsBottom];
    
    // Update ScrollView Data
    [self buildSelectorLabelsYears];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureYearsCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scrollViewYears addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsYears {
    
    CGFloat offsetContentScrollView = (_scrollViewYears.frame.size.height - kHooDatePickerScrollViewItemHeight) / 2.0;
    
    if (_labelsYears && _labelsYears.count > 0) {
        for (UILabel *label in _labelsYears) {
            [label removeFromSuperview];
        }
    }
    
    _labelsYears = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _years.count; i++) {
        
        NSString *day = (NSString*)[_years objectAtIndex:i];
        
        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (i * kHooDatePickerScrollViewItemHeight) + offsetContentScrollView, _scrollViewYears.frame.size.width, kHooDatePickerScrollViewItemHeight)];
        labelDay.text = day;
        labelDay.font = kHooDatePickerLabelFont;
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = self.tintColor;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [_labelsYears addObject:labelDay];
        [_scrollViewYears addSubview:labelDay];
    }
    
    _scrollViewYears.contentSize = CGSizeMake(_scrollViewYears.frame.size.width, (kHooDatePickerScrollViewItemHeight * _years.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorYears {
    
    if (_scrollViewYears) {
        [_scrollViewYears removeFromSuperview];
        _scrollViewYears = nil;
    }
    if (_lineYearsTop) {
        [_lineYearsTop removeFromSuperview];
        _lineYearsTop = nil;
    }
    if (_lineYearsBottom) {
        [_lineYearsBottom removeFromSuperview];
        _lineYearsBottom = nil;
    }
}

#pragma mark - Build Selector Dates

- (void)buildSelectorDatesOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Dates
    _scrollViewDates = [[UIScrollView alloc] initWithFrame:CGRectMake(x, kHooDatePickerHeaderHeight + kHooDatePickerHeaderBottomMargin, width, self.frame.size.height - kHooDatePickerHeaderHeight - kHooDatePickerHeaderBottomMargin)];
    _scrollViewDates.tag = ScrollViewTagValue_DATES;
    _scrollViewDates.delegate = self;
    _scrollViewDates.backgroundColor = kHooDatePickerScrolViewBackgroundColor;
    _scrollViewDates.showsHorizontalScrollIndicator = NO;
    _scrollViewDates.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollViewDates];
    
    _lineDatesTop = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewDates.frame.origin.x + kHooDatePickerLineMargin, _scrollViewDates.frame.origin.y + (_scrollViewDates.frame.size.height / 2) - (kHooDatePickerScrollViewItemHeight / 2), width - (2 * kHooDatePickerLineMargin), kHooDatePickerLineWidth)];
    _lineDatesTop.backgroundColor = self.highlightColor;
    [self addSubview:_lineDatesTop];
    
    _lineDatesBottom = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewDates.frame.origin.x + kHooDatePickerLineMargin, _scrollViewDates.frame.origin.y + (_scrollViewDates.frame.size.height / 2) + (kHooDatePickerScrollViewItemHeight / 2), width - (2 * kHooDatePickerLineMargin), kHooDatePickerLineWidth)];
    _lineDatesBottom.backgroundColor = self.highlightColor;
    [self addSubview:_lineDatesBottom];
    
    // Update ScrollView Data
    [self buildSelectorLabelsDates];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureDatesCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scrollViewDates addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsDates {
    
    CGFloat offsetContentScrollView = (_scrollViewDates.frame.size.height - kHooDatePickerScrollViewItemHeight) / 2.0;
    
    if (_labelsDates && _labelsDates.count > 0) {
        for (UILabel *label in _labelsDates) {
            [label removeFromSuperview];
        }
    }
    
    _labelsDates = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dateFormatter = self.dateFormatter;
    [dateFormatter setCalendar:self.calendar];
    [dateFormatter setTimeZone:self.timeZone];
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"MMMdd%@ EEE", @"日"]];
    
    for (int i = 0; i < _dates.count; i++) {
        
        NSDate *date = [_dates objectAtIndex:i];
        
        NSString *hour = [dateFormatter stringFromDate:date];
        
        UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(0, (i * kHooDatePickerScrollViewItemHeight) + offsetContentScrollView, _scrollViewDates.frame.size.width, kHooDatePickerScrollViewItemHeight)];
        labelDate.text = hour;
        labelDate.font = kHooDatePickerLabelFont;
        labelDate.textAlignment = NSTextAlignmentCenter;
        labelDate.textColor = self.tintColor;
        labelDate.backgroundColor = [UIColor clearColor];
        
        [_labelsDates addObject:labelDate];
        [_scrollViewDates addSubview:labelDate];
    }
    
    _scrollViewDates.contentSize = CGSizeMake(_scrollViewDates.frame.size.width, (kHooDatePickerScrollViewItemHeight * _dates.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorDates {
    
    if (_scrollViewDates) {
        [_scrollViewDates removeFromSuperview];
        _scrollViewDates = nil;
    }
    if (_lineDatesTop) {
        [_lineDatesTop removeFromSuperview];
        _lineDatesTop = nil;
    }
    if (_lineDatesBottom) {
        [_lineDatesBottom removeFromSuperview];
        _lineDatesBottom = nil;
    }
}

#pragma mark - Build Selector Hours

- (void)buildSelectorHoursOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Hours :
    _scrollViewHours = [[UIScrollView alloc] initWithFrame:CGRectMake(x, kHooDatePickerHeaderHeight + kHooDatePickerHeaderBottomMargin, width, self.frame.size.height - kHooDatePickerHeaderHeight - kHooDatePickerHeaderBottomMargin)];
    _scrollViewHours.tag = ScrollViewTagValue_HOURS;
    _scrollViewHours.delegate = self;
    _scrollViewHours.backgroundColor = kHooDatePickerScrolViewBackgroundColor;
    _scrollViewHours.showsHorizontalScrollIndicator = NO;
    _scrollViewHours.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollViewHours];
    
    _lineHoursTop = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewHours.frame.origin.x + kHooDatePickerLineMargin, _scrollViewHours.frame.origin.y + (_scrollViewHours.frame.size.height / 2) - (kHooDatePickerScrollViewItemHeight / 2), width - (2 * kHooDatePickerLineMargin), kHooDatePickerLineWidth)];
    _lineHoursTop.backgroundColor = self.highlightColor;
    [self addSubview:_lineHoursTop];
    
    _lineHoursBottom = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewHours.frame.origin.x + kHooDatePickerLineMargin, _scrollViewHours.frame.origin.y + (_scrollViewHours.frame.size.height / 2) + (kHooDatePickerScrollViewItemHeight / 2), width - (2 * kHooDatePickerLineMargin), kHooDatePickerLineWidth)];
    _lineHoursBottom.backgroundColor = self.highlightColor;
    [self addSubview:_lineHoursBottom];
    
    // Update ScrollView Data
    [self buildSelectorLabelsHours];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureHoursCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scrollViewHours addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsHours {
    
    CGFloat offsetContentScrollView = (_scrollViewHours.frame.size.height - kHooDatePickerScrollViewItemHeight) / 2.0;
    
    if (_labelsHours && _labelsHours.count > 0) {
        for (UILabel *label in _labelsHours) {
            [label removeFromSuperview];
        }
    }
    
    _labelsHours = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.hours.count; i++) {
        
        NSString *hour = (NSString*)[self.hours objectAtIndex:i];
        
        UILabel *labelHour = [[UILabel alloc] initWithFrame:CGRectMake(0, (i * kHooDatePickerScrollViewItemHeight) + offsetContentScrollView, _scrollViewHours.frame.size.width, kHooDatePickerScrollViewItemHeight)];
        labelHour.text = hour;
        labelHour.font = kHooDatePickerLabelFont;
        labelHour.textAlignment = NSTextAlignmentCenter;
        labelHour.textColor = self.tintColor;
        labelHour.backgroundColor = [UIColor clearColor];
        
        [_labelsHours addObject:labelHour];
        [_scrollViewHours addSubview:labelHour];
    }
    
    _scrollViewHours.contentSize = CGSizeMake(_scrollViewHours.frame.size.width, (kHooDatePickerScrollViewItemHeight * self.hours.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorHours {
    
    if (_scrollViewHours) {
        [_scrollViewHours removeFromSuperview];
        _scrollViewHours = nil;
    }
    if (_lineHoursTop) {
        [_lineHoursTop removeFromSuperview];
        _lineHoursTop = nil;
    }
    if (_lineHoursBottom) {
        [_lineHoursBottom removeFromSuperview];
        _lineHoursBottom = nil;
    }
}

#pragma mark - Build Selector Minutes

- (void)buildSelectorMinutesOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Minutes :
    _scrollViewMinutes = [[UIScrollView alloc] initWithFrame:CGRectMake(x, kHooDatePickerHeaderHeight + kHooDatePickerHeaderBottomMargin, width, self.frame.size.height - kHooDatePickerHeaderHeight - kHooDatePickerHeaderBottomMargin)];
    _scrollViewMinutes.tag = ScrollViewTagValue_MINUTES;
    _scrollViewMinutes.delegate = self;
    _scrollViewMinutes.backgroundColor = kHooDatePickerScrolViewBackgroundColor;
    _scrollViewMinutes.showsHorizontalScrollIndicator = NO;
    _scrollViewMinutes.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollViewMinutes];
    
    _lineMinutesTop = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewMinutes.frame.origin.x + kHooDatePickerLineMargin, _scrollViewMinutes.frame.origin.y + (_scrollViewMinutes.frame.size.height / 2) - (kHooDatePickerScrollViewItemHeight / 2), width - (2 * kHooDatePickerLineMargin), kHooDatePickerLineWidth)];
    _lineMinutesTop.backgroundColor = self.highlightColor;
    [self addSubview:_lineMinutesTop];
    
    _lineMinutesBottom = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewMinutes.frame.origin.x + kHooDatePickerLineMargin, _scrollViewMinutes.frame.origin.y + (_scrollViewMinutes.frame.size.height / 2) + (kHooDatePickerScrollViewItemHeight / 2), width - (2 * kHooDatePickerLineMargin), kHooDatePickerLineWidth)];
    _lineMinutesBottom.backgroundColor = self.highlightColor;
    [self addSubview:_lineMinutesBottom];
    
    // Update ScrollView Data
    [self buildSelectorLabelsMinutes];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureMinutesCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scrollViewMinutes addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsMinutes {
    
    CGFloat offsetContentScrollView = (_scrollViewMinutes.frame.size.height - kHooDatePickerScrollViewItemHeight) / 2.0;
    
    if (_labelsMinutes && _labelsMinutes.count > 0) {
        for (UILabel *label in _labelsMinutes) {
            [label removeFromSuperview];
        }
    }
    
    _labelsMinutes = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.minutes.count; i++) {
        
        NSString *minute = (NSString*)[self.minutes objectAtIndex:i];
        
        UILabel *labelMinute = [[UILabel alloc] initWithFrame:CGRectMake(0, (i * kHooDatePickerScrollViewItemHeight) + offsetContentScrollView, _scrollViewMinutes.frame.size.width, kHooDatePickerScrollViewItemHeight)];
        labelMinute.text = minute;
        labelMinute.font = kHooDatePickerLabelFont;
        labelMinute.textAlignment = NSTextAlignmentCenter;
        labelMinute.textColor = self.tintColor;
        labelMinute.backgroundColor = [UIColor clearColor];
        
        [_labelsMinutes addObject:labelMinute];
        [_scrollViewMinutes addSubview:labelMinute];
    }
    
    _scrollViewMinutes.contentSize = CGSizeMake(_scrollViewMinutes.frame.size.width, (kHooDatePickerScrollViewItemHeight * self.minutes.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorMinutes {
    
    if (_scrollViewMinutes) {
        [_scrollViewMinutes removeFromSuperview];
        _scrollViewMinutes = nil;
    }
    if (_lineMinutesTop) {
        [_lineMinutesTop removeFromSuperview];
        _lineMinutesTop = nil;
    }
    if (_lineMinutesBottom) {
        [_lineMinutesBottom removeFromSuperview];
        _lineMinutesBottom = nil;
    }
}

#pragma mark - Build Selector Seconds

- (void)buildSelectorSecondsOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Seconds :
    _scrollViewSeconds = [[UIScrollView alloc] initWithFrame:CGRectMake(x, kHooDatePickerHeaderHeight + kHooDatePickerHeaderBottomMargin, width, self.frame.size.height - kHooDatePickerHeaderHeight - kHooDatePickerHeaderBottomMargin)];
    _scrollViewSeconds.tag = ScrollViewTagValue_SECONDS;
    _scrollViewSeconds.delegate = self;
    _scrollViewSeconds.backgroundColor = kHooDatePickerScrolViewBackgroundColor;
    _scrollViewSeconds.showsHorizontalScrollIndicator = NO;
    _scrollViewSeconds.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollViewSeconds];
    
    _lineSecondsTop = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewSeconds.frame.origin.x + kHooDatePickerLineMargin, _scrollViewSeconds.frame.origin.y + (_scrollViewSeconds.frame.size.height / 2) - (kHooDatePickerScrollViewItemHeight / 2), width - (2 * kHooDatePickerLineMargin), kHooDatePickerLineWidth)];
    _lineSecondsTop.backgroundColor = self.highlightColor;
    [self addSubview:_lineSecondsTop];
    
    _lineSecondsBottom = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewSeconds.frame.origin.x + kHooDatePickerLineMargin, _scrollViewSeconds.frame.origin.y + (_scrollViewSeconds.frame.size.height / 2) + (kHooDatePickerScrollViewItemHeight / 2), width - (2 * kHooDatePickerLineMargin), kHooDatePickerLineWidth)];
    _lineSecondsBottom.backgroundColor = self.highlightColor;
    [self addSubview:_lineSecondsBottom];
    
    // Update ScrollView Data
    [self buildSelectorLabelsSeconds];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureSecondsCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scrollViewSeconds addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsSeconds {
    
    CGFloat offsetContentScrollView = (_scrollViewSeconds.frame.size.height - kHooDatePickerScrollViewItemHeight) / 2.0;
    
    if (_labelsSeconds && _labelsSeconds.count > 0) {
        for (UILabel *label in _labelsSeconds) {
            [label removeFromSuperview];
        }
    }
    
    _labelsSeconds = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.seconds.count; i++) {
        
        NSString *second = (NSString*)[self.seconds objectAtIndex:i];
        
        UILabel *labelSecond = [[UILabel alloc] initWithFrame:CGRectMake(0, (i * kHooDatePickerScrollViewItemHeight) + offsetContentScrollView, _scrollViewSeconds.frame.size.width, kHooDatePickerScrollViewItemHeight)];
        labelSecond.text = second;
        labelSecond.font = kHooDatePickerLabelFont;
        labelSecond.textAlignment = NSTextAlignmentCenter;
        labelSecond.textColor = self.tintColor;
        labelSecond.backgroundColor = [UIColor clearColor];
        
        [_labelsSeconds addObject:labelSecond];
        [_scrollViewSeconds addSubview:labelSecond];
    }
    
    _scrollViewSeconds.contentSize = CGSizeMake(_scrollViewSeconds.frame.size.width, (kHooDatePickerScrollViewItemHeight * self.seconds.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorSeconds {
    
    if (_scrollViewSeconds) {
        [_scrollViewSeconds removeFromSuperview];
        _scrollViewSeconds = nil;
    }
    if (_lineSecondsTop) {
        [_lineSecondsTop removeFromSuperview];
        _lineSecondsTop = nil;
    }
    if (_lineSecondsBottom) {
        [_lineSecondsBottom removeFromSuperview];
        _lineSecondsBottom = nil;
    }
}

#pragma mark - Actions

- (void)actionButtonCancel:(UIButton *)sender {
    
    [self dismiss];
    
    if ([self.delegate respondsToSelector:@selector(datePicker:didCancel:)]) {
        [self.delegate datePicker:self didCancel:sender];
    }
}

- (void)actionButtonValid:(UIButton *)sender {
    
    [self dismiss];
    
    if ([self.delegate respondsToSelector:@selector(datePicker:didSelectedDate:)]) {
        [self.delegate datePicker:self didSelectedDate:[self getDate]];
    }
}

#pragma mark - Show and Dismiss

-(void)show {
    
    if (!_superView) return;
    
    if (self.hidden == YES) {
        self.hidden = NO;
    }
    
    if (_isInitialized == NO) {
        self.frame = CGRectMake(self.frame.origin.x, _superView.frame.size.height, self.frame.size.width, self.frame.size.height);
        _isInitialized = YES;
    }
    
    [self.superView insertSubview:self.dimBackgroundView belowSubview:self];
    
    if (self.datePickerMode == HooDatePickerModeDate || self.datePickerMode == HooDatePickerModeDateAndTime) {
        
        int indexDays = [self getIndexForScrollViewPosition:_scrollViewDays];
        [self highlightLabelInArray:_labelsDays atIndex:indexDays];
        
        int indexMonths = [self getIndexForScrollViewPosition:_scrollViewMonths];
        [self highlightLabelInArray:_labelsMonths atIndex:indexMonths];
        
        int indexYears = [self getIndexForScrollViewPosition:_scrollViewYears];
        [self highlightLabelInArray:_labelsYears atIndex:indexYears];
    }
    
    if (self.datePickerMode == HooDatePickerModeTime || self.datePickerMode == HooDatePickerModeDateAndTime) {
        
        int indexHours = [self getIndexForScrollViewPosition:_scrollViewHours];
        [self highlightLabelInArray:_labelsHours atIndex:indexHours];
        
        int indexMinutes = [self getIndexForScrollViewPosition:_scrollViewMinutes];
        [self highlightLabelInArray:_labelsMinutes atIndex:indexMinutes];
        
        int indexSeconds = [self getIndexForScrollViewPosition:_scrollViewSeconds];
        [self highlightLabelInArray:_labelsSeconds atIndex:indexSeconds];
    }
    
    if (self.datePickerMode == HooDatePickerModeYearAndMonth) {
        int indexMonths = [self getIndexForScrollViewPosition:_scrollViewMonths];
        [self highlightLabelInArray:_labelsMonths atIndex:indexMonths];
        
        int indexYears = [self getIndexForScrollViewPosition:_scrollViewYears];
        [self highlightLabelInArray:_labelsYears atIndex:indexYears];
    }
    
    [UIView animateWithDuration:kHooDatePickerAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(self.frame.origin.x, _superView.frame.size.height - kHooDatePickerHeight, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        _isOpen = YES;
        
    }];
}

-(void)dismiss {
    
    if (!_superView) return;
    [UIView animateWithDuration:kHooDatePickerAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(self.frame.origin.x, _superView.frame.size.height, self.frame.size.width, self.frame.size.height);
        self.dimBackgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        _isOpen = NO;
        [self.dimBackgroundView removeFromSuperview];
        self.dimBackgroundView = nil;
    }];
}

#pragma mark - DatePicker Mode

- (void)setDatePickerMode:(HooDatePickerMode)mode {
    _datePickerMode = mode;
    [self setupControl];
}

#pragma mark - Collections

- (NSMutableArray*)getYears {
    
    NSMutableArray *years = [[NSMutableArray alloc] init];
    
    NSInteger yearMin = 0;
    
    if (self.minimumDate) {
        NSDateComponents* componentsMin = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.minimumDate];
        yearMin = [componentsMin year];
    } else {
        yearMin = _minYear;
    }
    
    NSInteger yearMax = 0;
    NSDateComponents* componentsMax = nil;
    
    if (self.maximumDate) {
        componentsMax = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.maximumDate];
        yearMax = [componentsMax year];
    } else {
        componentsMax = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
        yearMax = [componentsMax year];
    }
    
    for (NSInteger i = yearMin; i <= yearMax; i++) {
        
        [years addObject:[NSString stringWithFormat:@"%ld\u5e74", (long)i]];
    }
    
    return years;
}

- (NSMutableArray*)getDates {
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    
    if (self.minimumDate && self.maximumDate) {
        NSInteger days = [self.minimumDate daysBetween:self.maximumDate];
        for (NSInteger i = 0; i < days; i++) {
            NSDate *date = [self.minimumDate dateByAddingDays:i];
            if ([date daysBetween: self.maximumDate] >= 0) {
                [dates addObject:date];
            }
        }
    } else {
        
        NSDateComponents* currentComponents = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
        NSInteger currentYear = [currentComponents year];
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setCalendar:self.calendar];
        [dateComponents setTimeZone:self.timeZone];
        [dateComponents setDay:1];
        [dateComponents setMonth:1];
        [dateComponents setHour:0];
        [dateComponents setMinute:0];
        [dateComponents setSecond:0];
        [dateComponents setYear:currentYear];
        
        NSDateComponents *maxComponents = [[NSDateComponents alloc] init];
        [maxComponents setCalendar:self.calendar];
        [maxComponents setTimeZone:self.timeZone];
        [maxComponents setDay:1];
        [maxComponents setMonth:1];
        [maxComponents setHour:0];
        [maxComponents setMinute:0];
        [maxComponents setSecond:0];
        [maxComponents setYear:currentYear + 1];
        
        NSDate *yearMin = [dateComponents date];
        NSDate *yearMax = [maxComponents date];
        
        NSInteger timestampMin = [yearMin timeIntervalSince1970];
        NSInteger timestampMax = [yearMax timeIntervalSince1970];
        
        while (timestampMin < timestampMax) {
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestampMin];
            
            [dates addObject:date];
            
            timestampMin += 1 * 24 * 60 * 60;
        }
    }
    
    return dates;
}

- (NSMutableArray*)getDaysInMonth:(NSDate*)date {
    
    if (date == nil) date = [NSDate date];
    
    NSRange daysRange = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    NSMutableArray *days = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= daysRange.length; i++) {
        
        [days addObject:[NSString stringWithFormat:@"%d%@", i, @"日"]];
    }
    
    return days;
}

#pragma mark - UIScrollView Delegate

- (void)singleTapGestureDaysCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    if (touchY < (_lineDaysTop.frame.origin.y)) {
        
        if (_selectedDay > 1) {
            _selectedDay -= 1;
            [self setScrollView:_scrollViewDays atIndex:(_selectedDay - 1) animated:YES];
        }
        
    } else if (touchY > (_lineDaysBottom.frame.origin.y)) {
        
        if (_selectedDay < _days.count) {
            _selectedDay += 1;
            [self setScrollView:_scrollViewDays atIndex:(_selectedDay - 1) animated:YES];
        }
    }
}

- (void)singleTapGestureMonthsCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    if (touchY < (_lineMonthsTop.frame.origin.y)) {
        
        if (_selectedMonth > 1) {
            _selectedMonth -= 1;
            [self setScrollView:_scrollViewMonths atIndex:(_selectedMonth - 1) animated:YES];
        }
        
    } else if (touchY > (_lineMonthsBottom.frame.origin.y)) {
        
        if (_selectedMonth < self.months.count) {
            _selectedMonth += 1;
            [self setScrollView:_scrollViewMonths atIndex:(_selectedMonth - 1) animated:YES];
        }
    }
}

- (void)singleTapGestureYearsCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    NSInteger minYear = _minYear;
    
    if (touchY < (_lineYearsTop.frame.origin.y)) {
        
        if (_selectedYear > minYear) {
            _selectedYear -= 1;
            [self setScrollView:_scrollViewYears atIndex:(_selectedYear - minYear) animated:YES];
        }
        
    } else if (touchY > (_lineYearsBottom.frame.origin.y)) {
        
        if (_selectedYear < (_years.count + (minYear - 1))) {
            _selectedYear += 1;
            [self setScrollView:_scrollViewYears atIndex:(_selectedYear - minYear) animated:YES];
        }
    }
}


- (void)singleTapGestureDatesCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    if (touchY < (_lineDatesTop.frame.origin.y)) {
        
        if (_selectedDate > 0) {
            _selectedDate -= 1;
            [self setScrollView:_scrollViewDates atIndex:_selectedDate animated:YES];
        }
        
    } else if (touchY > (_lineDatesBottom.frame.origin.y)) {
        
        if (_selectedDate < _dates.count - 1) {
            _selectedDate += 1;
            [self setScrollView:_scrollViewDates atIndex:_selectedDate animated:YES];
        }
    }
}

- (void)singleTapGestureHoursCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    if (touchY < (_lineHoursTop.frame.origin.y)) {
        
        if (_selectedHour > 0) {
            _selectedHour -= 1;
            [self setScrollView:_scrollViewHours atIndex:_selectedHour animated:YES];
        }
        
    } else if (touchY > (_lineHoursBottom.frame.origin.y)) {
        
        if (_selectedHour < self.hours.count - 1) {
            _selectedHour += 1;
            [self setScrollView:_scrollViewHours atIndex:_selectedHour animated:YES];
        }
    }
}

- (void)singleTapGestureMinutesCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    if (touchY < (_lineMinutesTop.frame.origin.y)) {
        
        if (_selectedMinute > 0) {
            _selectedMinute -= 1;
            [self setScrollView:_scrollViewMinutes atIndex:_selectedMinute animated:YES];
        }
        
    } else if (touchY > (_lineMinutesBottom.frame.origin.y)) {
        
        if (_selectedMinute < self.minutes.count - 1) {
            _selectedMinute += 1;
            [self setScrollView:_scrollViewMinutes atIndex:_selectedMinute animated:YES];
        }
    }
}

- (void)singleTapGestureSecondsCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    if (touchY < (_lineSecondsTop.frame.origin.y)) {
        
        if (_selectedSecond > 0) {
            _selectedSecond -= 1;
            [self setScrollView:_scrollViewSeconds atIndex:_selectedSecond animated:YES];
        }
        
    } else if (touchY > (_lineSecondsBottom.frame.origin.y)) {
        
        if (_selectedSecond < self.seconds.count - 1) {
            _selectedSecond += 1;
            [self setScrollView:_scrollViewSeconds atIndex:_selectedSecond animated:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int index = [self getIndexForScrollViewPosition:scrollView];
    
    [self updateSelectedDateAtIndex:index forScrollView:scrollView];
    
    if (scrollView.tag == ScrollViewTagValue_DAYS) {
        [self highlightLabelInArray:_labelsDays atIndex:index];
    } else if (scrollView.tag == ScrollViewTagValue_MONTHS) {
        [self highlightLabelInArray:_labelsMonths atIndex:index];
    } else if (scrollView.tag == ScrollViewTagValue_YEARS) {
        [self highlightLabelInArray:_labelsYears atIndex:index];
    } else if (scrollView.tag == ScrollViewTagValue_HOURS) {
        [self highlightLabelInArray:_labelsHours atIndex:index];
    } else if (scrollView.tag == ScrollViewTagValue_MINUTES) {
        [self highlightLabelInArray:_labelsMinutes atIndex:index];
    } else if (scrollView.tag == ScrollViewTagValue_SECONDS) {
        [self highlightLabelInArray:_labelsSeconds atIndex:index];
    } else if (scrollView.tag == ScrollViewTagValue_DATES) {
        [self highlightLabelInArray:_labelsDates atIndex:index];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    int index = [self getIndexForScrollViewPosition:scrollView];
    
    [self updateSelectedDateAtIndex:index forScrollView:scrollView];
    
    [self setScrollView:scrollView atIndex:index animated:YES];
    
    NSDate *selectedDate = [self getDate];
    if (self.datePickerMode != HooDatePickerModeDateAndTime && self.datePickerMode != HooDatePickerModeTime) {
        if ([selectedDate compare:self.minimumDate] == NSOrderedAscending) {
            [self setDate:self.minimumDate animated:YES];
        }
        
        if ([selectedDate compare:self.maximumDate] == NSOrderedDescending) {
            [self setDate:self.maximumDate animated:YES];
        }
    }
    if ([self.delegate respondsToSelector:@selector(datePicker:dateDidChange:)]) {
        [self.delegate datePicker:self dateDidChange:selectedDate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int index = [self getIndexForScrollViewPosition:scrollView];
    
    [self updateSelectedDateAtIndex:index forScrollView:scrollView];
    
    [self setScrollView:scrollView atIndex:index animated:YES];
    
    NSDate *selectedDate = [self getDate];
    if (self.datePickerMode != HooDatePickerModeDateAndTime && self.datePickerMode != HooDatePickerModeTime) {
        if ([selectedDate compare:self.minimumDate] == NSOrderedAscending) {
            [self setDate:self.minimumDate animated:YES];
            return;
        }
        
        if ([selectedDate compare:self.maximumDate] == NSOrderedDescending) {
            [self setDate:self.maximumDate animated:YES];
            return;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(datePicker:dateDidChange:)]) {
        [self.delegate datePicker:self dateDidChange:selectedDate];
    }
}

- (void)updateSelectedDateAtIndex:(int)index forScrollView:(UIScrollView*)scrollView {
    
    if (scrollView.tag == ScrollViewTagValue_DAYS) {
        _selectedDay = index + 1; // 1 to 31
    } else if (scrollView.tag == ScrollViewTagValue_MONTHS) {
        
        _selectedMonth = index + 1; // 1 to 12
        
        // Updates days :
        [self updateNumberOfDays];
        
    } else if (scrollView.tag == ScrollViewTagValue_YEARS) {
        
        _selectedYear = _minYear + index;
        
        // Updates days :
        [self updateNumberOfDays];
        
    } else if (scrollView.tag == ScrollViewTagValue_HOURS) {
        _selectedHour = index; // 0 to 23
    } else if (scrollView.tag == ScrollViewTagValue_MINUTES) {
        _selectedMinute = index; // 0 to 59
    } else if (scrollView.tag == ScrollViewTagValue_SECONDS) {
        _selectedSecond = index; // 0 to 59
    } else if (scrollView.tag == ScrollViewTagValue_DATES) {
        _selectedDate = index;
    }
}

- (void)updateNumberOfDays {
    
    // Updates days :
    NSDate *date = [self convertToDateDay:1 month:_selectedMonth year:_selectedYear hours:_selectedHour minutes:_selectedMinute seconds:_selectedSecond];
    
    if (!date) return;
    
    NSMutableArray *newDays = [self getDaysInMonth:date];
    
    if (newDays.count != _days.count) {
        
        _days = newDays;
        
        [self buildSelectorLabelsDays];
        
        if (_selectedDay > _days.count) {
            _selectedDay = _days.count;
        }
        
        [self highlightLabelInArray:_labelsDays atIndex:_selectedDay - 1];
    }
}

- (int)getIndexForScrollViewPosition:(UIScrollView *)scrollView {
    
    CGFloat offsetContentScrollView = (scrollView.frame.size.height - kHooDatePickerScrollViewItemHeight) / 2.0;
    CGFloat offetY = scrollView.contentOffset.y;
    CGFloat index = floorf((offetY + offsetContentScrollView) / kHooDatePickerScrollViewItemHeight);
    index = (index - 1);
    return index;
}

- (void)setScrollView:(UIScrollView*)scrollView atIndex:(NSInteger)index animated:(BOOL)animated {
    
    if (!scrollView) return;
    
    if (animated) {
        [UIView beginAnimations:@"ScrollViewAnimation" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:kHooDatePickerAnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    }
    
    scrollView.contentOffset = CGPointMake(0.0, (index * kHooDatePickerScrollViewItemHeight));
    
    if (animated) {
        [UIView commitAnimations];
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(datePicker:dateDidChange:)]) {
        [self.delegate datePicker:self dateDidChange:[self getDate]];
    }
}

- (void)highlightLabelInArray:(NSMutableArray*)labels atIndex:(NSInteger)index {
    if (!labels) return;
    if (index > labels.count) return;
    if (index < 0) return;
    
    for (int i = 0; i < labels.count; i++) {
        UILabel *label = (UILabel *)[labels objectAtIndex:i];
        if (i != index) {
            label.textColor = self.tintColor;
            label.font = kHooDatePickerLabelFont;
        } else {
            label.textColor = self.highlightColor;
            label.font = kHooDatePickerLabelSelectedFont;
        }
    }
}

#pragma mark - Date

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    
    if (!date) return;
    NSDateComponents* components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    
    _selectedDay = [components day];
    _selectedMonth = [components month];
    _selectedYear = [components year];
    _selectedHour = [components hour];
    /**
     *  only show mininute 00 10 20 ~ 50 in hotel tour edit order for flight pick up
     */
    if (self.datePickerMode != HooDatePickerModeDateAndTime) {
        _selectedMinute = [components minute];
    }
    _selectedSecond = [components second];
    
    if (self.datePickerMode == HooDatePickerModeDateAndTime) {
        if (self.minimumDate) {
            [self  setScrollView:_scrollViewDates atIndex:[date daysBetween:self.minimumDate] - 1 animated:animated];
        } else {
            [self setScrollView:_scrollViewDates atIndex:(_selectedDay - 1) animated:animated];
        }
        
    }
    
    if (self.datePickerMode == HooDatePickerModeDate) {
        [self setScrollView:_scrollViewYears atIndex:(_selectedYear - _minYear) animated:animated];
        [self setScrollView:_scrollViewMonths atIndex:(_selectedMonth - 1) animated:animated];
        [self setScrollView:_scrollViewDays atIndex:(_selectedDay - 1) animated:animated];
        
        
    }
    
    if (self.datePickerMode == HooDatePickerModeTime || self.datePickerMode == HooDatePickerModeDateAndTime) {
        [self setScrollView:_scrollViewHours atIndex:_selectedHour animated:animated];
        [self setScrollView:_scrollViewMinutes atIndex:_selectedMinute animated:animated];
        [self setScrollView:_scrollViewSeconds atIndex:_selectedSecond animated:animated];
    }
    
    if (self.datePickerMode == HooDatePickerModeYearAndMonth) {
        [self setScrollView:_scrollViewMonths atIndex:(_selectedMonth - 1) animated:animated];
        [self setScrollView:_scrollViewYears atIndex:(_selectedYear - _minYear) animated:animated];
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(datePicker:dateDidChange:)]) {
        [self.delegate datePicker:self dateDidChange:[self getDate]];
    }
}

- (NSDate*)convertToDateDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds {
    
    NSMutableString *dateString = [[NSMutableString alloc] init];
    
    NSDateFormatter *dateFormatter = self.dateFormatter;
    if (self.timeZone) [dateFormatter setTimeZone:self.timeZone];
    [dateFormatter setLocale:self.locale];
    
    // Date Mode :
    if (self.datePickerMode == HooDatePickerModeDate) {
        
        if (day < 10) {
            [dateString appendFormat:@"0%ld-", (long)day];
        } else {
            [dateString appendFormat:@"%ld-", (long)day];
        }
        
        if (month < 10) {
            [dateString appendFormat:@"0%ld-", (long)month];
        } else {
            [dateString appendFormat:@"%ld-", (long)month];
        }
        
        [dateString appendFormat:@"%ld", (long)year];
        
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }
    
    // Time Mode :
    if (self.datePickerMode == HooDatePickerModeTime) {
        
        NSDateComponents* components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
        
        NSInteger nowDay = [components day];
        NSInteger nowMonth = [components month];
        NSInteger nowYear = [components year];
        
        if (nowDay < 10) {
            [dateString appendFormat:@"0%ld-", (long)nowDay];
        } else {
            [dateString appendFormat:@"%ld-", (long)nowDay];
        }
        
        if (nowMonth < 10) {
            [dateString appendFormat:@"0%ld-", (long)nowMonth];
        } else {
            [dateString appendFormat:@"%ld-", (long)nowMonth];
        }
        
        [dateString appendFormat:@"%ld", (long)nowYear];
        
        if (hours < 10) {
            [dateString appendFormat:@" 0%ld:", (long)hours];
        } else {
            [dateString appendFormat:@" %ld:", (long)hours];
        }
        
        if (minutes < 10) {
            [dateString appendFormat:@"0%ld:", (long)minutes];
        } else {
            [dateString appendFormat:@"%ld:", (long)minutes];
        }
        
        if (seconds < 10) {
            [dateString appendFormat:@"0%ld", (long)seconds];
        } else {
            [dateString appendFormat:@"%ld", (long)seconds];
        }
        
        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    }
    
    // Date and Time Mode :
    if (self.datePickerMode == HooDatePickerModeDateAndTime) {
        
        if (day < 10) {
            [dateString appendFormat:@"0%ld-", (long)day];
        } else {
            [dateString appendFormat:@"%ld-", (long)day];
        }
        
        if (month < 10) {
            [dateString appendFormat:@"0%ld-", (long)month];
        } else {
            [dateString appendFormat:@"%ld-", (long)month];
        }
        
        [dateString appendFormat:@"%ld", (long)year];
        
        if (hours < 10) {
            [dateString appendFormat:@" 0%ld:", (long)hours];
        } else {
            [dateString appendFormat:@" %ld:", (long)hours];
        }
        
        if (minutes < 10) {
            [dateString appendFormat:@"0%ld:", (long)minutes];
        } else {
            [dateString appendFormat:@"%ld:", (long)minutes];
        }
        
        [dateString appendString:@"00"];
        
        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    }
    
    if (self.datePickerMode == HooDatePickerModeYearAndMonth) {
        
        if (month < 10) {
            [dateString appendFormat:@"0%ld-", (long)month];
        } else {
            [dateString appendFormat:@"%ld-", (long)month];
        }
        
        [dateString appendFormat:@"%ld", (long)year];
        
        [dateFormatter setDateFormat:@"MM-yyyy"];
    }
    
    return [dateFormatter dateFromString:dateString];
}

- (NSDate*)convertToDate:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds {
    
    NSDate *date = [self.minimumDate dateByAddingDays:days];
    
    NSMutableString *dateString = [[NSMutableString alloc] initWithString:[date stringForFormat:@"dd-MM-yyyy"]];
    
    NSDateFormatter *dateFormatter = self.dateFormatter;
    if (self.timeZone) [dateFormatter setTimeZone:self.timeZone];
    [dateFormatter setLocale:self.locale];
    
    
    if (hours < 10) {
        [dateString appendFormat:@" 0%ld:", (long)hours];
    } else {
        [dateString appendFormat:@" %ld:", (long)hours];
    }
    /**
     *  only show mininute 00 10 20 ~ 50 in hotel tour edit order for flight pick up
     */
    
    if (!minutes) {
        [dateString appendFormat:@"0%ld:", (long)minutes];
    } else {
        [dateString appendFormat:@"%ld:", (long)minutes * 10];
    }
    
    [dateString appendString:@"00"];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    return [dateFormatter dateFromString:dateString];
}

- (NSDate*)getDate {
    if (self.datePickerMode == HooDatePickerModeDateAndTime) {
        return [self convertToDate:_selectedDate hours:_selectedHour minutes:_selectedMinute seconds:_selectedSecond];
    }
    return [self convertToDateDay:_selectedDay month:_selectedMonth year:_selectedYear hours:_selectedHour minutes:_selectedMinute seconds:_selectedSecond];
}

#pragma mark - Getters and Setters

- (UIView *)dimBackgroundView {
    if(!_dimBackgroundView) {
        _dimBackgroundView = [[UIView alloc] initWithFrame:self.superView.bounds];
        [_dimBackgroundView setTranslatesAutoresizingMaskIntoConstraints:YES];
        _dimBackgroundView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_dimBackgroundView addGestureRecognizer:tap];
    }
    return _dimBackgroundView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, kHooDatePickerHeaderHeight)];
        // Button Cancel
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(kHooDatePickerPadding, 0.0, kHooDatePickerButtonHeaderWidth, kHooDatePickerHeaderHeight)];
        [cancelButton setTitle:kCancelButtonItemTitle forState:UIControlStateNormal];
        [cancelButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(actionButtonCancel:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:cancelButton];
        
        // Button confirm
        UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - kHooDatePickerButtonHeaderWidth - kHooDatePickerPadding, 0.0, kHooDatePickerButtonHeaderWidth, kHooDatePickerHeaderHeight)];
        [sureButton setTitle:kSureButtonItemTitle forState:UIControlStateNormal];
        [sureButton setTitleColor:self.highlightColor forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(actionButtonValid:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:sureButton];
        
        // Label Title
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelButton.frame) + kHooDatePickerPadding, 0.0, self.frame.size.width - ((kHooDatePickerButtonHeaderWidth + kHooDatePickerPadding * 2) * 2 ), kHooDatePickerHeaderHeight)];
        _titleLabel.text = self.title;
        _titleLabel.font = kHooDatePickerTitleFont;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = self.tintColor;
        [_headerView addSubview:_titleLabel];
    }
    return _headerView;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
        _dateFormatter = dateFormatter;
    }
    _dateFormatter.dateFormat = kDateFormatYYYYMMDD;
    return _dateFormatter;
}

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _calendar.timeZone = self.timeZone;
        _calendar.locale = self.locale;
    }
    return _calendar;
}

- (NSMutableArray *)months {
    NSMutableArray *months = [[NSMutableArray alloc] init];
    for (int monthNumber = 1; monthNumber <= 12; monthNumber++) {
        NSString *dateString = [NSString stringWithFormat: @"%d", monthNumber];
        NSDateFormatter* dateFormatter = self.dateFormatter;
        if (self.timeZone) [dateFormatter setTimeZone:self.timeZone];
        [dateFormatter setLocale:self.locale];
        [dateFormatter setDateFormat:@"MM"];
        NSDate* myDate = [dateFormatter dateFromString:dateString];
        
        NSDateFormatter *formatter = self.dateFormatter;
        if (self.timeZone) [dateFormatter setTimeZone:self.timeZone];
        [dateFormatter setLocale:self.locale];
        [formatter setDateFormat:@"MMM"];
        NSString *stringFromDate = [formatter stringFromDate:myDate];
        
        [months addObject:stringFromDate];
    }
    _months = months;
    return _months;
}

- (NSMutableArray*)hours {
    if (!_hours) {
        NSMutableArray *hours = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 24; i++) {
            if (i < 10) {
                [hours addObject:[NSString stringWithFormat:@"0%d%@", i, @"时"]];
            } else {
                [hours addObject:[NSString stringWithFormat:@"%d%@", i, @"时"]];
            }
        }
        _hours = hours;
    }
    return _hours;
}

- (NSMutableArray*)minutes {
    if (!_minutes) {
        NSMutableArray *minutes = [[NSMutableArray alloc] init];
        /**
         *  only show mininute 00 10 20 ~ 50 in hotel tour edit order for flight pick up
         */
        for (int i = 0; i < 6; i++) {
            if (!i) {
                [minutes addObject:[NSString stringWithFormat:@"%d0%@", i, @"分"]];
            } else {
                [minutes addObject:[NSString stringWithFormat:@"%d%@", i * 10, @"分"]];
            }
            
        }
        _minutes = minutes;
    }
    return _minutes;
}

- (NSMutableArray*)seconds {
    if (!_seconds) {
        
        NSMutableArray *seconds = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 60; i++) {
            if (i < 10) {
                [seconds addObject:[NSString stringWithFormat:@"0%d", i]];
            } else {
                [seconds addObject:[NSString stringWithFormat:@"%d", i]];
            }
        }
        _seconds = seconds;
    }
    return _seconds;
}
- (NSTimeZone *)timeZone {
    if (!_timeZone) {
        _timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    }
    return _timeZone;
}

- (NSLocale *)locale {
    if (!_locale) {
        _locale = [NSLocale currentLocale];
    }
    return _locale;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self setupControl];
}

- (void)setHighlightColor:(UIColor *)highlightColor {
    _highlightColor = highlightColor;
    [self setupControl];
}

- (void)setMinimumDate:(NSDate*)date {
    _minimumDate = date;
    NSDateComponents* componentsMin = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_minimumDate];
    NSInteger yearMin = [componentsMin year];
    _minYear = yearMin;
    [self setupControl];
}

- (void)setMaximumDate:(NSDate*)date {
    _maximumDate = date;
    [self setupControl];
}


@end
