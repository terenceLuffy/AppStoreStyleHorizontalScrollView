Pod::Spec.new do |s|
  s.name         = "ASHorizontalScrollView"
  s.version      = "1.5.1"
  s.summary      = "App store style horizontal scroll view"
  s.description  = <<-DESC
                   It acts similar to apps sliding behaviours in App store. There are both Objective-C and Swift version available and they perform exactly the same function, please find whichever you like.
                   DESC
  s.homepage     = "https://github.com/terenceLuffy/AppStoreStyleHorizontalScrollView"
  s.license      = { :type => 'MIT', :text => <<-LICENSE
 * The MIT License (MIT)
 * Copyright (C) 2014-2017 WEIWEI CHEN
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    LICENSE
  }
  s.author       = { "Weiwei Chen" => "terenceluffy@gmail.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => 'https://github.com/terenceLuffy/AppStoreStyleHorizontalScrollView.git', :tag => "1.5.1"}
  s.source_files  = 'Sources/ASHorizontalScrollView.swift'
  s.frameworks = 'UIKit'
  s.requires_arc = true
end
