ASHorizontalScrollView
=================================

App store style horizontal scroll view

It acts similar to apps sliding behaviours in App store. There are both Objective-C and Swift version available and they perform exactly the same function, please find whichever you like.

![](https://dl.dropboxusercontent.com/u/91675323/thumbookr1.gif)  ![](https://dl.dropboxusercontent.com/u/91675323/thumbookr2.gif)

Please note that the gif is not from the sample project.

Please note that from now on, the objective-C source won't be updated anymore as I have been using Swift for all my works totally.

### Installation
Install using one of the following options:

1. Download the source from "Source" folder and drag into your project.
2. Using [CocoaPods](http://cocoapods.org)

    Swift
    ```ruby
    pod 'ASHorizontalScrollView', '~> 1.4'
    ```

    Objective-C
    ```ruby
    pod 'ASHorizontalScrollViewForObjectiveC', '~> 1.3'
    ```

3. Using [Carthage](https://github.com/Carthage/Carthage)

    Swift
    ```shell
    github "terenceLuffy/AppStoreStyleHorizontalScrollView" ~> 1.4
    ```

### How to use it?
Please check in [here](http://terenceluffy.github.io/how-to-use-ASHorizontalScrollView/)

### Versions:
1.0: Initial release

1.1: Change to adapt iOS 9 and Swift 2.1

1.2: Change C style code to Swift 3 compatible code, fix removeItemAtIndex last index crash bug

1.3: Supoort Swift 3 and XCode 8, add support to nib file

1.4: Add custom width when judging whether to scroll to next item; add support to all Apple devices screen size, now you can specified different mini margin, mini appear width and left margin for all sorts of screen sizes. 

### iOS Supported Version
It is developed based on UIScrollView and its delegate methods, so it is completely compatible to most iOS versions. But the Swift version requires 8.0 or above.

### Authorization
The MIT License (MIT)
Copyright (C) 2014-2016 WEIWEI CHEN

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Support
Having bugs? Please send me an email.
