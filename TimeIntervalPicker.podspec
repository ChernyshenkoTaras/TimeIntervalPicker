Pod::Spec.new do |s|
  s.name             = 'TCTimeIntervalPicker'
  s.version          = '0.1.0'
  s.summary          = 'UIDatePicker-like picker in .countDownTimer mode with range selection support'

  s.description      = <<-DESC
    UIDatePicker-like picker in .countDownTimer mode what gives you ability to change max hours
                       DESC

  s.homepage         = 'https://github.com/ChernyshenkoTaras/TimeIntervalPicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Taras Chernyshenko' => 'taras.chernyshenko@gmail.com' }
  s.source           = { :git => 'https://github.com/ChernyshenkoTaras/TimeIntervalPicker.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/@t_chernyshenko'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TimeIntervalPicker/Classes/**/*'
end
