
### HooDatePicker 介绍（introduction）
==================================================
项目需要一个DatePicker,只显示年月，而且选中的时间高亮显示（苹果默认的只显示灰色），研究多个代码后，封装的一个性能比较高的自定义DatePicker。苹果原生的UIDatePicker无法实现只提供年月选择，而HooDatePicker增加了年月显示，并提供了扁平化和样式美化，也更加符合中国人的时间习惯。

A customized DatePicker. which can show only Years and months.the UIDatePicker don't achive this. and HooDatePicker looks much more beautiful than UIDatePicker.I hope you can like it.

Github address（Github下载地址）：https://github.com/jakciehoo/HooDatePicker
### 效果图展示（picure show）:
==================================================
`HooDatePickerModeDate Demo picture:`


![Simulator Screen Shot Mar 6, 2016, 3.04.09 AM.png](http://upload-images.jianshu.io/upload_images/1112722-99526bace022799d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`HooDatePickerModeYearAndMonth Demo picture`


![Simulator Screen Shot Mar 6, 2016, 3.04.30 AM.png](http://upload-images.jianshu.io/upload_images/1112722-134a88183835d837.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


# `如何使用How To Use:`
==================================================
```java  
HooDatePicker *datePicker = [[HooDatePicker alloc] initWithSuperView:self.view];
datePicker.delegate = self;
datePicker.datePickerMode = HooDatePickerModeYearAndMonth;
[datePicker show];
```   
### 更多用法More:
==================================================
1.设置其他属性
```java  
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSDate *maxDate = [dateFormatter dateFromString:@"01-01-2050 00:00:00"];
    NSDate *minDate = [dateFormatter dateFromString:@"01-01-2016 00:00:00"];
    [self.datePicker setDate:[NSDate date] animated:YES];//设置默认日期
    self.datePicker.minimumDate = minDate;//设置显示的最小日期
    self.datePicker.maximumDate = maxDate;//设置显示的最大日期
    [self.datePicker setTintColor:[UIColor redColor]];//设置主色
    [self.datePicker setHighlightColor:[UIColor yellowColor]];//设置高亮颜色
```
2.相关代理
```java  
@protocol HooDatePickerDelegate<NSObject>
@optional
- (void)datePicker:(HooDatePicker *)datePicker dateDidChange:(NSDate *)date;
- (void)datePicker:(HooDatePicker *)datePicker clickedCancelButton:(UIButton *)sender;
- (void)datePicker:(HooDatePicker *)datePicker clickedSureButton:(UIButton *)sender date:(NSDate*)date;
@end
```
For more detail, you can download this project and see demo code in it.

Enjoy it!!

欢迎关注我的微信公众号“丁丁的coding日记”，一起学习iOS开发技术

![qrcode_for_gh_a0330831fea6_430 (1).jpg](http://upload-images.jianshu.io/upload_images/1112722-cfce03ad624ff2c0.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
