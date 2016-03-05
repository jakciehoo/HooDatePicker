# `HooDatePicker introduction`
自定义日期选择控件。苹果原生的UIDatePicker无法实现只提供年月选择，而HooDatePicker增加了年月显示，并提供了扁平化和样式美化。也更加符合中国人的时间习惯。

A customized DatePicker. which can show only Years and months.the UIDatePicker don't achive this. and HooDatePicker looks much more beautiful than UIDatePicker.I hope you can like it.

# `picure:`
======================
![](https://github.com/jakciehoo/HooDatePicker/blob/master/HooDatePickerDeomo/Simulator%20Screen%20Shot%20Mar%206%2C%202016%2C%203.04.09%20AM.png)

![](https://github.com/jakciehoo/HooDatePicker/blob/master/HooDatePickerDeomo/Simulator%20Screen%20Shot%20Mar%206%2C%202016%2C%203.04.30%20AM.png)

# `How To Use:`
```java  
HooDatePicker *datePicker = [[HooDatePicker alloc] initWithSuperView:self.view];
datePicker.delegate = self;
datePicker.datePickerMode = HooDatePickerModeYearAndMonth;
[datePicker show];
```   
  
For more detail, you can download this project and see demo code in it.

Enjoy it!!
