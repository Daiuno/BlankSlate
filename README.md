# BlankSlate

[![Swift](https://img.shields.io/badge/Swift-5.9_|_6.0-orange?style=flat-square)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS_tvOS_visionOS-yellowgreen?style=flat-square)](https://developer.apple.com/platforms/)
[![CocoaPods](https://img.shields.io/cocoapods/v/BlankSlate.svg?style=flat)](https://cocoapods.org/pods/BlankSlate)
[![SPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager)
[![Carthage](https://img.shields.io/badge/Carthage-supported-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/BlankSlate.svg?style=flat)](https://github.com/liam-i/BlankSlate/blob/main/LICENSE)
<!-- [![Doc](https://img.shields.io/badge/Swift-Doc-DE5C43.svg?style=flat)](https://liam-i.github.io/BlankSlate/main/documentation/blankslate) -->

BlankSlate is a drop-in UIView extension for showing empty datasets whenever the view has no content to display.

## ScreenShots

[![](https://raw.githubusercontent.com/wiki/liam-i/BlankSlate/Screenshots/1-small.png)](https://raw.githubusercontent.com/wiki/liam-i/BlankSlate/Screenshots/1.png)
[![](https://raw.githubusercontent.com/wiki/liam-i/BlankSlate/Screenshots/2-small.png)](https://raw.githubusercontent.com/wiki/liam-i/BlankSlate/Screenshots/2.png)
[![](https://raw.githubusercontent.com/wiki/liam-i/BlankSlate/Screenshots/3-small.png)](https://raw.githubusercontent.com/wiki/liam-i/BlankSlate/Screenshots/3.png)
[![](https://raw.githubusercontent.com/wiki/liam-i/BlankSlate/Screenshots/4-small.png)](https://raw.githubusercontent.com/wiki/liam-i/BlankSlate/Screenshots/4.png)
[![](https://raw.githubusercontent.com/wiki/liam-i/BlankSlate/Screenshots/5-small.png)](https://raw.githubusercontent.com/wiki/liam-i/BlankSlate/Screenshots/5.png)
[![](https://raw.githubusercontent.com/wiki/liam-i/BlankSlate/Screenshots/6-small.png)](https://raw.githubusercontent.com/wiki/liam-i/BlankSlate/Screenshots/6.png)

## Requirements

* iOS 13.0+
* tvOS 13.0+
* visionOS 1.0+
* Xcode 15.0+
* Swift 5.9+

## Installation

### Swift Package Manager

#### ...using `swift build`

If you are using the [Swift Package Manager](https://www.swift.org/documentation/package-manager), add a dependency to your `Package.swift` file and import the BlankSlate library into the desired targets:

```swift
dependencies: [
    .package(url: "https://github.com/liam-i/BlankSlate.git", from: "0.7.1")
],
targets: [
    .target(
        name: "MyTarget", dependencies: [
            .product(name: "BlankSlate", package: "BlankSlate")
        ])
]
```

#### ...using Xcode

If you are using Xcode, then you should:

* File > Add Package Dependencies...
* Add `https://github.com/liam-i/BlankSlate.git`
* Select "Up to Next Minor" with "0.7.1"

> [!TIP]
> For detailed tutorials, see: [Apple Docs](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)

#### CocoaPods

If you're using [CocoaPods](https://cocoapods.org), add this to your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
# Or use CDN source
# source 'https://cdn.cocoapods.org/'
platform :ios, '13.0'
use_frameworks!

target 'MyApp' do
  pod 'BlankSlate', '~> 0.7.1'
end
```

And run `pod install`.

> [!IMPORTANT]  
> CocoaPods 1.13.0 or newer is required.

### Carthage

If you're using [Carthage](https://github.com/Carthage/Carthage), add this to your `Cartfile`:

```ruby
github "liam-i/BlankSlate" ~> 0.7.1
```

And run `carthage update --platform iOS --use-xcframeworks`.

## Usage

### Basic Setup

Conform to `BlankSlate.DataSource` to provide empty state content, then assign it to your view:

```swift
import BlankSlate

class MyViewController: UITableViewController, BlankSlate.DataSource, BlankSlate.Delegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.bs.setDataSourceAndDelegate(self)
    }

    // MARK: - BlankSlate.DataSource

    func image(forBlankSlate view: UIView) -> UIImage? {
        UIImage(named: "empty_placeholder")
    }

    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "No Data", attributes: [
            .font: UIFont.systemFont(ofSize: 20, weight: .medium),
            .foregroundColor: UIColor.secondaryLabel
        ])
    }

    func buttonTitle(forBlankSlate view: UIView, for state: UIControl.State) -> NSAttributedString? {
        guard state == .normal else { return nil }
        return NSAttributedString(string: "Reload", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.systemBlue
        ])
    }

    // MARK: - BlankSlate.Delegate

    func blankSlate(_ view: UIView, didTapButton sender: UIButton) {
        // Handle retry
        loadData()
    }
}
```

The empty dataset displays automatically by observing `reloadData()` calls — no manual reload needed for `UITableView` and `UICollectionView`.

### Status-Driven (Zero Configuration)

For common loading/empty/error patterns, use the built-in `StatusDrivenDataSource`:

```swift
let statusDS = BlankSlate.StatusDrivenDataSource(view: tableView)
statusDS.onRetry = { [weak self] in self?.loadData() }

// Trigger state changes:
tableView.bs.reload(with: .loading)   // Shows spinner
tableView.bs.reload(with: .success)   // Shows "No Data" if table is empty
tableView.bs.reload(with: .failure)   // Shows error + retry button
```

### Plain UIView / UIScrollView

For non-table/collection views, call `reload()` manually:

```swift
let scrollView = UIScrollView()
scrollView.bs.dataSource = self
scrollView.bs.reload()           // Evaluate and show/hide blank slate
scrollView.bs.dismiss()          // Manually remove blank slate
```

### SwiftUI

```swift
import BlankSlate

List(items) { item in
    ItemRow(item: item)
}
.blankSlate(isEmpty: items.isEmpty, title: "No Items", detail: "Pull to refresh")
```

### Transition Animations

```swift
func transition(forBlankSlate view: UIView) -> BlankSlate.Transition {
    .fadeIn(duration: 0.3)    // or .slideUp, .slideDown, .scale, .bounce
}
```

### Custom Layout & Alignment

```swift
func alignment(forBlankSlate view: UIView) -> BlankSlate.Alignment {
    .center(.offset(y: -50))  // 50pt above center
}

func layout(forBlankSlate view: UIView, for element: BlankSlate.Element) -> BlankSlate.Layout {
    .init(edgeInsets: UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16))
}
```

For the complete API reference, see the source documentation in `Sources/DataSource.swift` and `Sources/Delegate.swift`.

## Example

To run the example project, first clone the repo, then `cd` to the root directory and run `pod install`. Then open BlankSlate.xcworkspace in Xcode.

## Credits and thanks

* Thanks a lot to [Ignacio Romero Zurbuchen](https://github.com/dzenbot) for building [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet) - all ideas in here and many implementation details were provided by his library.

## License

BlankSlate is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
