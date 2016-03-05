//
//  ViewController.m
//  HooDatePickerDeomo
//
//  Created by hujianghua on 3/5/16.
//  Copyright © 2016 hujianghua. All rights reserved.
//

#import "ViewController.h"
#import "HooDatePicker.h"

@interface ViewController ()<HooDatePickerDelegate>
@property (nonatomic, strong) HooDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *labelDateSelected;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.datePicker = [[HooDatePicker alloc] initWithSuperView:self.view];
    self.datePicker.delegate = self;
    self.datePicker.datePickerMode = HooDatePickerModeDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSDate *maxDate = [dateFormatter dateFromString:@"01-01-2050 00:00:00"];
    NSDate *minDate = [dateFormatter dateFromString:@"01-01-2016 00:00:00"];

    [self.datePicker setDate:[NSDate date] animated:YES];
    self.datePicker.minimumDate = minDate;
    self.datePicker.maximumDate = maxDate;
}

- (IBAction)actionOpen:(id)sender {
    
    [self.datePicker show];
}

- (IBAction)actionClose:(id)sender {
    
    [self.datePicker dismiss];
}

- (IBAction)actionSetDate:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:@"07-12-1985 15:36:45"];
    
    if (self.datePicker.isOpen) {
        [self.datePicker setDate:date animated:YES];
    } else {
        [self.datePicker setDate:date animated:NO];
    }
}

#pragma mark - FlatDatePicker Delegate

- (void)datePicker:(HooDatePicker *)datePicker dateDidChange:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == HooDatePickerModeDate) {
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    } else if (datePicker.datePickerMode == HooDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else if (datePicker.datePickerMode == HooDatePickerModeYearAndMonth){
        [dateFormatter setDateFormat:@"MM/yy"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
        
    }
    
    NSString *value = [dateFormatter stringFromDate:date];
    
    self.labelDateSelected.text = value;
}

- (void)datePicker:(HooDatePicker *)datePicker clickedCancelButton:(UIButton *)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关闭日期选择" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)datePicker:(HooDatePicker *)datePicker clickedSureButton:(UIButton *)sender date:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == HooDatePickerModeDate) {
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    } else if (datePicker.datePickerMode == HooDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else if (datePicker.datePickerMode == HooDatePickerModeYearAndMonth){
        [dateFormatter setDateFormat:@"MM/yy"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    
    NSString *value = [dateFormatter stringFromDate:date];
    
    self.labelDateSelected.text = value;
    
    NSString *message = [NSString stringWithFormat:@"确定选择日期 : %@", value];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}
@end
