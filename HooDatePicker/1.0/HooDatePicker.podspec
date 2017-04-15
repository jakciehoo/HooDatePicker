Pod::Spec.new do |s|
  s.name             = "HooDatePicker"
  s.version          = "1.0"
  s.summary          = "一个非常漂亮的日期选择空间The open source for a beautiful date picker."
  s.homepage         = "https://github.com/jakciehoo/HooDatePicker.git"
  s.license          = 'Code is MIT, then custom font licenses.'
  s.author           = { "jackiehoo" => "niat05ethjh1112@163.com" }
  s.source           = { :git => "https://github.com/jakciehoo/HooDatePicker.git", :tag => s.version }
  s.social_media_url = 'http://jackiehoo.com/'
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'HooDatePickerDeomo/HooDatePicker/*{h,m}'

  s.frameworks = 'UIKit'
  s.module_name = 'HooDatePicker'
end
