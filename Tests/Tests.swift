import XCTest
import BlankSlate

// MARK: - 终端测试命令教程
//
// 以下命令均在项目根目录下执行，使用 BlankSlate.xcworkspace。
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 1. 执行全部测试用例
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//   xcodebuild test \
//     -workspace BlankSlate.xcworkspace \
//     -scheme "Example iOS" \
//     -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
//     CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 2. 仅执行某个测试类（例如 UITableViewBlankSlateTests）
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//   xcodebuild test \
//     -workspace BlankSlate.xcworkspace \
//     -scheme "Example iOS" \
//     -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
//     -only-testing:"Example Tests/UITableViewBlankSlateTests" \
//     CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 3. 仅执行某个测试方法（例如 testReloadShowsBlankSlateWithDataSource）
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//   xcodebuild test \
//     -workspace BlankSlate.xcworkspace \
//     -scheme "Example iOS" \
//     -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
//     -only-testing:"Example Tests/UITableViewBlankSlateTests/testReloadShowsBlankSlateWithDataSource" \
//     CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 4. 同时执行多个测试类或方法（用多个 -only-testing 参数）
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//   xcodebuild test \
//     -workspace BlankSlate.xcworkspace \
//     -scheme "Example iOS" \
//     -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
//     -only-testing:"Example Tests/UITableViewBlankSlateTests" \
//     -only-testing:"Example Tests/UICollectionViewBlankSlateTests" \
//     CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 5. 跳过某些测试（执行除指定之外的全部测试）
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//   xcodebuild test \
//     -workspace BlankSlate.xcworkspace \
//     -scheme "Example iOS" \
//     -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
//     -skip-testing:"Example Tests/UIViewBlankSlateTests" \
//     CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 6. 使用 swift test（仅适用于 SPM 测试目标，需 macOS host 环境）
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//   # 全部测试
//   swift test --filter BlankSlateTests
//
//   # 单个测试方法
//   swift test --filter BlankSlateTests.UITableViewBlankSlateTests/testReloadShowsBlankSlateWithDataSource
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 7. 生成代码覆盖率报告
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//   xcodebuild test \
//     -workspace BlankSlate.xcworkspace \
//     -scheme "Example iOS" \
//     -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
//     -enableCodeCoverage YES \
//     -resultBundlePath TestResults.xcresult \
//     CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
//
//   # 查看覆盖率摘要
//   xcrun xccov view --report TestResults.xcresult
//
//   # 查看某个文件的逐行覆盖率
//   xcrun xccov view --file Sources/BlankSlate.swift TestResults.xcresult
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 提示：
//   • 将 "iPhone 17 Pro" 替换为你本机可用的模拟器名称
//     （运行 `xcrun simctl list devices available` 查看）
//   • 追加 `| xcbeautify` 或 `| xcpretty` 美化输出（需提前安装）
//   • 追加 `-quiet` 减少冗余日志
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// MARK: - Test Helpers

@MainActor
fileprivate class MockDataSource: BlankSlate.DataSource {
    var imageToReturn: UIImage?
    var imageAlphaToReturn: CGFloat = 1.0
    var imageTintColorToReturn: UIColor?
    var titleToReturn: NSAttributedString?
    var detailToReturn: NSAttributedString?
    var buttonTitleToReturn: NSAttributedString?
    var buttonImageToReturn: UIImage?
    var customViewToReturn: UIView?
    var backgroundColorToReturn: UIColor?
    var fadeInDurationToReturn: TimeInterval = 0.0
    var alignmentToReturn: BlankSlate.Alignment = .center()
    var layoutToReturn: BlankSlate.Layout = .init()
    var configureButtonCalled = false

    func image(forBlankSlate view: UIView) -> UIImage? { imageToReturn }
    func imageAlpha(forBlankSlate view: UIView) -> CGFloat { imageAlphaToReturn }
    func imageTintColor(forBlankSlate view: UIView) -> UIColor? { imageTintColorToReturn }
    func title(forBlankSlate view: UIView) -> NSAttributedString? { titleToReturn }
    func detail(forBlankSlate view: UIView) -> NSAttributedString? { detailToReturn }
    func buttonTitle(forBlankSlate view: UIView, for state: UIControl.State) -> NSAttributedString? { buttonTitleToReturn }
    func buttonImage(forBlankSlate view: UIView, for state: UIControl.State) -> UIImage? { buttonImageToReturn }
    func customView(forBlankSlate view: UIView) -> UIView? { customViewToReturn }
    func backgroundColor(forBlankSlate view: UIView) -> UIColor? { backgroundColorToReturn }
    func fadeInDuration(forBlankSlate view: UIView) -> TimeInterval { fadeInDurationToReturn }
    func alignment(forBlankSlate view: UIView) -> BlankSlate.Alignment { alignmentToReturn }
    func layout(forBlankSlate view: UIView, for element: BlankSlate.Element) -> BlankSlate.Layout { layoutToReturn }
    func blankSlate(_ view: UIView, configure button: UIButton) { configureButtonCalled = true }
}

@MainActor
fileprivate class MockDelegate: BlankSlate.Delegate {
    var shouldDisplay = true
    var shouldForceDisplay = false
    var shouldAllowTouch = true
    var shouldAllowScroll = false
    var shouldAllowScrollAfterDisappear = true
    var shouldInsertAtBack = true

    var willAppearCalled = false
    var didAppearCalled = false
    var willDisappearCalled = false
    var didDisappearCalled = false
    var didTapViewCalled = false
    var didTapButtonCalled = false
    var tappedView: UIView?
    var tappedButton: UIButton?

    func blankSlateShouldDisplay(_ view: UIView) -> Bool { shouldDisplay }
    func blankSlateShouldBeForcedToDisplay(_ view: UIView) -> Bool { shouldForceDisplay }
    func blankSlateShouldAllowTouch(_ view: UIView) -> Bool { shouldAllowTouch }
    func blankSlateShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { shouldAllowScroll }
    func shouldAllowScrollAfterBlankSlateDisappear(_ scrollView: UIScrollView) -> Bool { shouldAllowScrollAfterDisappear }
    func blankSlateShouldBeInsertedAtBack(_ view: UIView) -> Bool { shouldInsertAtBack }

    func blankSlateWillAppear(_ view: UIView) { willAppearCalled = true }
    func blankSlateDidAppear(_ view: UIView) { didAppearCalled = true }
    func blankSlateWillDisappear(_ view: UIView) { willDisappearCalled = true }
    func blankSlateDidDisappear(_ view: UIView) { didDisappearCalled = true }
    func blankSlate(_ view: UIView, didTapView sender: UIView) {
        didTapViewCalled = true
        tappedView = sender
    }
    func blankSlate(_ view: UIView, didTapButton sender: UIButton) {
        didTapButtonCalled = true
        tappedButton = sender
    }
}

fileprivate class EmptyTableViewDataSource: NSObject, UITableViewDataSource {
    var numberOfRows = 0
    var numberOfSections = 1

    func numberOfSections(in tableView: UITableView) -> Int { numberOfSections }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { numberOfRows }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

// Minimal data source without numberOfSections implementation
fileprivate class MinimalTableViewDataSource: NSObject, UITableViewDataSource {
    var numberOfRows = 0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { numberOfRows }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

fileprivate class MinimalCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var numberOfItems = 0
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { numberOfItems }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
}

// Mock delegate that also conforms to UIGestureRecognizerDelegate
@MainActor
fileprivate class GestureRecognizerMockDelegate: NSObject, BlankSlate.Delegate, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// ScrollView that is its own BlankSlate.Delegate (for self-delegate edge case)
@MainActor
fileprivate class ScrollViewSelfDelegate: UIScrollView, BlankSlate.Delegate {}

fileprivate class EmptyCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var numberOfItems = 0
    var numberOfSections = 1

    func numberOfSections(in collectionView: UICollectionView) -> Int { numberOfSections }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { numberOfItems }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
}

// MARK: - Model Tests

class ModelTests: XCTestCase {
    func testDataLoadStatusCases() {
        let loading = BlankSlate.DataLoadStatus.loading
        let success = BlankSlate.DataLoadStatus.success
        let failure = BlankSlate.DataLoadStatus.failure

        // Verify enum cases exist and are distinct
        XCTAssertFalse(isEqual(loading, success))
        XCTAssertFalse(isEqual(success, failure))
    }

    func testElementCases() {
        let allCases = BlankSlate.Element.allCases
        XCTAssertEqual(allCases.count, 5)
        XCTAssertTrue(allCases.contains(.image))
        XCTAssertTrue(allCases.contains(.title))
        XCTAssertTrue(allCases.contains(.detail))
        XCTAssertTrue(allCases.contains(.button))
        XCTAssertTrue(allCases.contains(.custom))
    }

    func testLayoutDefaultValues() {
        let layout = BlankSlate.Layout()
        XCTAssertEqual(layout.edgeInsets.top, 11)
        XCTAssertEqual(layout.edgeInsets.left, 16)
        XCTAssertEqual(layout.edgeInsets.bottom, 11)
        XCTAssertEqual(layout.edgeInsets.right, 16)
        XCTAssertNil(layout.height)
    }

    func testLayoutCustomValues() {
        let insets = UIEdgeInsets(top: 5, left: 10, bottom: 15, right: 20)
        let layout = BlankSlate.Layout(edgeInsets: insets, height: 44)
        XCTAssertEqual(layout.edgeInsets, insets)
        XCTAssertEqual(layout.height, 44)
    }

    func testLayoutWithMutator() {
        var layout = BlankSlate.Layout()
        layout.with { $0.height = 100 }
        XCTAssertEqual(layout.height, 100)
    }

    func testAlignmentCenter() {
        let alignment = BlankSlate.Alignment.center(.init(x: 10, y: 20))
        if case let .center(offset) = alignment {
            XCTAssertEqual(offset.x, 10)
            XCTAssertEqual(offset.y, 20)
        } else {
            XCTFail("Expected center alignment")
        }
    }

    func testAlignmentTop() {
        let alignment = BlankSlate.Alignment.top(.init(x: 5, y: 15))
        if case let .top(offset) = alignment {
            XCTAssertEqual(offset.x, 5)
            XCTAssertEqual(offset.y, 15)
        } else {
            XCTFail("Expected top alignment")
        }
    }

    func testAlignmentBottom() {
        let alignment = BlankSlate.Alignment.bottom()
        if case let .bottom(offset) = alignment {
            XCTAssertEqual(offset, .zero)
        } else {
            XCTFail("Expected bottom alignment")
        }
    }

    func testCGPointOffset() {
        let point = CGPoint.offset(y: 20, x: 10)
        XCTAssertEqual(point.x, 10)
        XCTAssertEqual(point.y, 20)
    }

    func testCGPointOffsetDefaultX() {
        let point = CGPoint.offset(y: 30)
        XCTAssertEqual(point.x, 0)
        XCTAssertEqual(point.y, 30)
    }

    private func isEqual(_ lhs: BlankSlate.DataLoadStatus, _ rhs: BlankSlate.DataLoadStatus) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.success, .success), (.failure, .failure): return true
        default: return false
        }
    }
}

// MARK: - DataSource Default Implementation Tests

@MainActor
class DataSourceDefaultTests: XCTestCase {
    private class MinimalDataSource: BlankSlate.DataSource {}

    func testDefaultValues() {
        let ds = MinimalDataSource()
        let view = UIView()

        XCTAssertNil(ds.image(forBlankSlate: view))
        XCTAssertEqual(ds.imageAlpha(forBlankSlate: view), 1.0)
        XCTAssertNil(ds.imageTintColor(forBlankSlate: view))
        XCTAssertNil(ds.imageAnimation(forBlankSlate: view))
        XCTAssertNil(ds.title(forBlankSlate: view))
        XCTAssertNil(ds.detail(forBlankSlate: view))
        XCTAssertNil(ds.buttonTitle(forBlankSlate: view, for: .normal))
        XCTAssertNil(ds.buttonBackgroundImage(forBlankSlate: view, for: .normal))
        XCTAssertNil(ds.buttonImage(forBlankSlate: view, for: .normal))
        XCTAssertNil(ds.customView(forBlankSlate: view))
        XCTAssertEqual(ds.backgroundColor(forBlankSlate: view), .clear)
        XCTAssertNil(ds.backgroundGradient(forBlankSlate: view))
        XCTAssertEqual(ds.fadeInDuration(forBlankSlate: view), 0.0)
    }

    func testDefaultAlignment() {
        let ds = MinimalDataSource()
        let view = UIView()
        let alignment = ds.alignment(forBlankSlate: view)
        if case let .center(offset) = alignment {
            XCTAssertEqual(offset, .zero)
        } else {
            XCTFail("Expected center alignment with zero offset")
        }
    }

    func testDefaultLayout() {
        let ds = MinimalDataSource()
        let view = UIView()
        let layout = ds.layout(forBlankSlate: view, for: .title)
        XCTAssertEqual(layout.edgeInsets.top, 11)
        XCTAssertNil(layout.height)
    }
}

// MARK: - Delegate Default Implementation Tests

@MainActor
class DelegateDefaultTests: XCTestCase {
    private class MinimalDelegate: BlankSlate.Delegate {}

    func testDefaultValues() {
        let d = MinimalDelegate()
        let view = UIView()
        let scrollView = UIScrollView()

        XCTAssertFalse(d.blankSlateShouldBeForcedToDisplay(view))
        XCTAssertTrue(d.blankSlateShouldDisplay(view))
        XCTAssertTrue(d.blankSlateShouldBeInsertedAtBack(view))
        XCTAssertTrue(d.blankSlateShouldAllowTouch(view))
        XCTAssertFalse(d.blankSlateShouldAllowScroll(scrollView))
        XCTAssertTrue(d.shouldAllowScrollAfterBlankSlateDisappear(scrollView))
    }
}

// MARK: - Extension Pattern Tests

@MainActor
class ExtensionPatternTests: XCTestCase {
    func testUIViewHasBsExtension() {
        let view = UIView()
        XCTAssertNil(view.bs.dataSource)
        XCTAssertNil(view.bs.delegate)
    }

    func testUITableViewHasBsExtension() {
        let tableView = UITableView()
        XCTAssertNil(tableView.bs.dataSource)
        XCTAssertNil(tableView.bs.delegate)
    }

    func testUICollectionViewHasBsExtension() {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        XCTAssertNil(collectionView.bs.dataSource)
        XCTAssertNil(collectionView.bs.delegate)
    }

    func testDataLoadStatus() {
        let view = UIView()
        XCTAssertNil(view.bs.dataLoadStatus)

        view.bs.dataLoadStatus = .loading
        XCTAssertNotNil(view.bs.dataLoadStatus)

        view.bs.dataLoadStatus = nil
        XCTAssertNil(view.bs.dataLoadStatus)
    }

    func testIsVisibleDefault() {
        let view = UIView()
        XCTAssertFalse(view.bs.isVisible)
    }

    func testBlankSlateViewDefault() {
        let view = UIView()
        XCTAssertNil(view.bs.view)
    }
}

// MARK: - UIView BlankSlate Integration Tests

@MainActor
class UIViewBlankSlateTests: XCTestCase {
    var view: UIView!
    fileprivate var dataSource: MockDataSource!
    fileprivate var delegate: MockDelegate!

    override func setUp() {
        super.setUp()
        view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        dataSource = MockDataSource()
        delegate = MockDelegate()
    }

    override func tearDown() {
        view.bs.dataSource = nil
        view.bs.delegate = nil
        view = nil
        dataSource = nil
        delegate = nil
        super.tearDown()
    }

    func testSetDataSource() {
        view.bs.dataSource = dataSource
        XCTAssertNotNil(view.bs.dataSource)
        XCTAssertTrue(view.bs.dataSource === dataSource)
    }

    func testSetDelegate() {
        view.bs.delegate = delegate
        XCTAssertNotNil(view.bs.delegate)
        XCTAssertTrue(view.bs.delegate === delegate)
    }

    func testSetDataSourceAndDelegate() {
        let combined = CombinedMock()
        view.bs.setDataSourceAndDelegate(combined)
        XCTAssertNotNil(view.bs.dataSource)
        XCTAssertNotNil(view.bs.delegate)
    }

    func testDataSourceIsWeaklyHeld() {
        var ds: MockDataSource? = MockDataSource()
        view.bs.dataSource = ds
        XCTAssertNotNil(view.bs.dataSource)

        ds = nil
        XCTAssertNil(view.bs.dataSource)
    }

    func testDelegateIsWeaklyHeld() {
        var d: MockDelegate? = MockDelegate()
        view.bs.delegate = d
        XCTAssertNotNil(view.bs.delegate)

        d = nil
        XCTAssertNil(view.bs.delegate)
    }

    func testReloadShowsBlankSlateWithTitle() {
        dataSource.titleToReturn = NSAttributedString(string: "No Data")
        view.bs.dataSource = dataSource
        view.bs.delegate = delegate
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
        XCTAssertNotNil(view.bs.view)
        XCTAssertTrue(delegate.willAppearCalled)
        XCTAssertTrue(delegate.didAppearCalled)
    }

    func testReloadShowsBlankSlateWithImage() {
        dataSource.imageToReturn = UIImage()
        view.bs.dataSource = dataSource
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
    }

    func testReloadShowsCustomView() {
        let customView = UIView()
        dataSource.customViewToReturn = customView
        view.bs.dataSource = dataSource
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
    }

    func testDismiss() {
        dataSource.titleToReturn = NSAttributedString(string: "Empty")
        view.bs.dataSource = dataSource
        view.bs.delegate = delegate
        view.bs.reloadBlankSlate()
        XCTAssertTrue(view.bs.isVisible)

        view.bs.dismiss()
        XCTAssertFalse(view.bs.isVisible)
        XCTAssertNil(view.bs.view)
        XCTAssertTrue(delegate.willDisappearCalled)
        XCTAssertTrue(delegate.didDisappearCalled)
    }

    func testShouldDisplayFalsePreventsShow() {
        dataSource.titleToReturn = NSAttributedString(string: "Empty")
        delegate.shouldDisplay = false
        view.bs.dataSource = dataSource
        view.bs.delegate = delegate
        view.bs.reloadBlankSlate()

        XCTAssertFalse(view.bs.isVisible)
    }

    func testForceDisplay() {
        dataSource.titleToReturn = NSAttributedString(string: "Forced")
        delegate.shouldForceDisplay = true
        view.bs.dataSource = dataSource
        view.bs.delegate = delegate
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
    }

    func testReloadWithDataLoadStatus() {
        dataSource.titleToReturn = NSAttributedString(string: "Loading...")
        view.bs.dataSource = dataSource
        view.bs.reload(with: .loading)

        XCTAssertTrue(view.bs.isVisible)
        if case .loading = view.bs.dataLoadStatus {
            // pass
        } else {
            XCTFail("Expected .loading status")
        }
    }

    func testSettingDataSourceToNilDismisses() {
        dataSource.titleToReturn = NSAttributedString(string: "Empty")
        view.bs.dataSource = dataSource
        view.bs.delegate = delegate
        view.bs.reloadBlankSlate()
        XCTAssertTrue(view.bs.isVisible)

        view.bs.dataSource = nil
        XCTAssertFalse(view.bs.isVisible)
        XCTAssertTrue(delegate.willDisappearCalled)
    }

    func testBackgroundColor() {
        dataSource.titleToReturn = NSAttributedString(string: "Test")
        dataSource.backgroundColorToReturn = .red
        view.bs.dataSource = dataSource
        view.bs.reloadBlankSlate()

        XCTAssertEqual(view.bs.view?.backgroundColor, .red)
    }
}

// MARK: - UITableView Integration Tests

@MainActor
class UITableViewBlankSlateTests: XCTestCase {
    var tableView: UITableView!
    fileprivate var tableDataSource: EmptyTableViewDataSource!
    fileprivate var blankSlateDataSource: MockDataSource!
    fileprivate var blankSlateDelegate: MockDelegate!

    override func setUp() {
        super.setUp()
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        tableDataSource = EmptyTableViewDataSource()
        blankSlateDataSource = MockDataSource()
        blankSlateDelegate = MockDelegate()

        tableView.dataSource = tableDataSource
        blankSlateDataSource.titleToReturn = NSAttributedString(string: "No Data")
    }

    override func tearDown() {
        tableView.bs.dataSource = nil
        tableView.bs.delegate = nil
        tableView = nil
        tableDataSource = nil
        blankSlateDataSource = nil
        blankSlateDelegate = nil
        super.tearDown()
    }

    func testShowsBlankSlateWhenEmpty() {
        tableDataSource.numberOfRows = 0
        tableView.bs.dataSource = blankSlateDataSource
        tableView.bs.delegate = blankSlateDelegate
        tableView.reloadData()

        XCTAssertTrue(tableView.bs.isVisible)
        XCTAssertTrue(blankSlateDelegate.willAppearCalled)
        XCTAssertTrue(blankSlateDelegate.didAppearCalled)
    }

    func testHidesBlankSlateWhenNotEmpty() {
        tableDataSource.numberOfRows = 5
        tableView.bs.dataSource = blankSlateDataSource
        tableView.bs.delegate = blankSlateDelegate
        tableView.reloadData()

        XCTAssertFalse(tableView.bs.isVisible)
    }

    func testTransitionFromEmptyToNonEmpty() {
        tableDataSource.numberOfRows = 0
        tableView.bs.dataSource = blankSlateDataSource
        tableView.bs.delegate = blankSlateDelegate
        tableView.reloadData()
        XCTAssertTrue(tableView.bs.isVisible)

        tableDataSource.numberOfRows = 3
        tableView.reloadData()
        XCTAssertFalse(tableView.bs.isVisible)
        XCTAssertTrue(blankSlateDelegate.willDisappearCalled)
        XCTAssertTrue(blankSlateDelegate.didDisappearCalled)
    }

    func testScrollDisabledWhenBlankSlateShown() {
        tableDataSource.numberOfRows = 0
        blankSlateDelegate.shouldAllowScroll = false
        tableView.bs.dataSource = blankSlateDataSource
        tableView.bs.delegate = blankSlateDelegate
        tableView.reloadData()

        XCTAssertFalse(tableView.isScrollEnabled)
    }

    func testScrollEnabledAfterBlankSlateDisappears() {
        tableDataSource.numberOfRows = 0
        blankSlateDelegate.shouldAllowScroll = false
        blankSlateDelegate.shouldAllowScrollAfterDisappear = true
        tableView.bs.dataSource = blankSlateDataSource
        tableView.bs.delegate = blankSlateDelegate
        tableView.reloadData()

        tableDataSource.numberOfRows = 1
        tableView.reloadData()

        XCTAssertTrue(tableView.isScrollEnabled)
    }

    func testMultipleSections() {
        tableDataSource.numberOfSections = 3
        tableDataSource.numberOfRows = 0
        tableView.bs.dataSource = blankSlateDataSource
        tableView.reloadData()

        XCTAssertTrue(tableView.bs.isVisible)
    }

    func testReloadMethod() {
        tableDataSource.numberOfRows = 0
        tableView.bs.dataSource = blankSlateDataSource
        tableView.bs.reload()

        XCTAssertTrue(tableView.bs.isVisible)
    }
}

// MARK: - UICollectionView Integration Tests

@MainActor
class UICollectionViewBlankSlateTests: XCTestCase {
    var collectionView: UICollectionView!
    fileprivate var collectionDataSource: EmptyCollectionViewDataSource!
    fileprivate var blankSlateDataSource: MockDataSource!

    override func setUp() {
        super.setUp()
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionDataSource = EmptyCollectionViewDataSource()
        blankSlateDataSource = MockDataSource()

        collectionView.dataSource = collectionDataSource
        blankSlateDataSource.titleToReturn = NSAttributedString(string: "No Items")
    }

    override func tearDown() {
        collectionView.bs.dataSource = nil
        collectionView = nil
        collectionDataSource = nil
        blankSlateDataSource = nil
        super.tearDown()
    }

    func testShowsBlankSlateWhenEmpty() {
        collectionDataSource.numberOfItems = 0
        collectionView.bs.dataSource = blankSlateDataSource
        collectionView.reloadData()

        XCTAssertTrue(collectionView.bs.isVisible)
    }

    func testHidesBlankSlateWhenNotEmpty() {
        collectionDataSource.numberOfItems = 10
        collectionView.bs.dataSource = blankSlateDataSource
        collectionView.reloadData()

        XCTAssertFalse(collectionView.bs.isVisible)
    }
}

// MARK: - UIScrollView Tests

@MainActor
class UIScrollViewBlankSlateTests: XCTestCase {
    func testScrollViewReload() {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Scroll Empty")
        scrollView.bs.dataSource = ds
        scrollView.bs.reloadBlankSlate()

        XCTAssertTrue(scrollView.bs.isVisible)
    }
}

// MARK: - Combined DataSource + Delegate

@MainActor
fileprivate class CombinedMock: BlankSlate.DataSource, BlankSlate.Delegate {
    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Combined")
    }
}

// MARK: - Transition Model Tests

class TransitionTests: XCTestCase {
    func testTransitionNone() {
        let t = BlankSlate.Transition.none
        if case .none = t {} else { XCTFail("Expected .none") }
    }

    func testTransitionFadeIn() {
        let t = BlankSlate.Transition.fadeIn(duration: 0.3)
        if case let .fadeIn(duration) = t {
            XCTAssertEqual(duration, 0.3)
        } else { XCTFail("Expected .fadeIn") }
    }

    func testTransitionSlideUp() {
        let t = BlankSlate.Transition.slideUp(duration: 0.4)
        if case let .slideUp(duration) = t {
            XCTAssertEqual(duration, 0.4)
        } else { XCTFail("Expected .slideUp") }
    }

    func testTransitionSlideDown() {
        let t = BlankSlate.Transition.slideDown(duration: 0.5)
        if case let .slideDown(duration) = t {
            XCTAssertEqual(duration, 0.5)
        } else { XCTFail("Expected .slideDown") }
    }

    func testTransitionScale() {
        let t = BlankSlate.Transition.scale(duration: 0.35)
        if case let .scale(duration) = t {
            XCTAssertEqual(duration, 0.35)
        } else { XCTFail("Expected .scale") }
    }

    func testTransitionBounce() {
        let t = BlankSlate.Transition.bounce(duration: 0.6)
        if case let .bounce(duration) = t {
            XCTAssertEqual(duration, 0.6)
        } else { XCTFail("Expected .bounce") }
    }
}

// MARK: - Transition DataSource Tests

@MainActor
class TransitionDataSourceTests: XCTestCase {
    private class TransitionDataSource: BlankSlate.DataSource {
        var transitionToReturn: BlankSlate.Transition = .none
        func title(forBlankSlate view: UIView) -> NSAttributedString? { NSAttributedString(string: "Test") }
        func transition(forBlankSlate view: UIView) -> BlankSlate.Transition { transitionToReturn }
    }

    func testDefaultTransition() {
        class Minimal: BlankSlate.DataSource {}
        let ds = Minimal()
        let view = UIView()
        if case .none = ds.transition(forBlankSlate: view) {} else { XCTFail("Expected .none") }
    }

    func testTransitionAppliedOnFirstShow() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = TransitionDataSource()
        ds.transitionToReturn = .slideUp(duration: 0.3)
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
    }

    func testLegacyFadeInDurationCompatibility() {
        class LegacyDS: BlankSlate.DataSource {
            func title(forBlankSlate view: UIView) -> NSAttributedString? { NSAttributedString(string: "Legacy") }
            func fadeInDuration(forBlankSlate view: UIView) -> TimeInterval { 0.5 }
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = LegacyDS()
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
    }

    func testNewTransitionOverridesLegacy() {
        class BothDS: BlankSlate.DataSource {
            func title(forBlankSlate view: UIView) -> NSAttributedString? { NSAttributedString(string: "Both") }
            func fadeInDuration(forBlankSlate view: UIView) -> TimeInterval { 0.5 }
            func transition(forBlankSlate view: UIView) -> BlankSlate.Transition { .scale(duration: 0.3) }
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = BothDS()
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
    }

    func testAllTransitionTypesApply() {
        let transitions: [BlankSlate.Transition] = [
            .none, .fadeIn(duration: 0.2), .slideUp(duration: 0.2),
            .slideDown(duration: 0.2), .scale(duration: 0.2), .bounce(duration: 0.2)
        ]

        for transition in transitions {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
            let ds = TransitionDataSource()
            ds.transitionToReturn = transition
            view.bs.dataSource = ds
            view.bs.reloadBlankSlate()
            XCTAssertTrue(view.bs.isVisible)
            view.bs.dismiss()
        }
    }
}

// MARK: - StatusConfiguration Tests

@MainActor
class StatusConfigurationTests: XCTestCase {
    func testDefaultConfiguration() {
        let config = BlankSlate.StatusConfiguration()
        XCTAssertNotNil(config.loading.customView)
        XCTAssertNotNil(config.empty.title)
        XCTAssertNotNil(config.failure.title)
        XCTAssertNotNil(config.failure.detail)
        XCTAssertNotNil(config.failure.buttonTitle)
    }

    func testCustomConfiguration() {
        let config = BlankSlate.StatusConfiguration(
            loading: .init(title: NSAttributedString(string: "Loading...")),
            empty: .init(image: UIImage(), title: NSAttributedString(string: "Empty")),
            failure: .init(title: NSAttributedString(string: "Error"), buttonTitle: NSAttributedString(string: "Retry"))
        )
        XCTAssertNil(config.loading.customView)
        XCTAssertNotNil(config.loading.title)
        XCTAssertNotNil(config.empty.image)
        XCTAssertNotNil(config.failure.buttonTitle)
    }

    func testStateContentInit() {
        let content = BlankSlate.StateContent(
            image: UIImage(),
            title: NSAttributedString(string: "Title"),
            detail: NSAttributedString(string: "Detail"),
            buttonTitle: NSAttributedString(string: "Button"),
            customView: UIView()
        )
        XCTAssertNotNil(content.image)
        XCTAssertNotNil(content.title)
        XCTAssertNotNil(content.detail)
        XCTAssertNotNil(content.buttonTitle)
        XCTAssertNotNil(content.customView)
    }

    func testStateContentEmptyInit() {
        let content = BlankSlate.StateContent()
        XCTAssertNil(content.image)
        XCTAssertNil(content.title)
        XCTAssertNil(content.detail)
        XCTAssertNil(content.buttonTitle)
        XCTAssertNil(content.customView)
    }
}

// MARK: - StatusDrivenDataSource Tests

@MainActor
class StatusDrivenDataSourceTests: XCTestCase {
    func testInitSetsDataSource() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let tvDS = EmptyTableViewDataSource()
        tableView.dataSource = tvDS
        let sds = BlankSlate.StatusDrivenDataSource(view: tableView)
        _ = sds // keep alive

        XCTAssertNotNil(tableView.bs.dataSource)
        XCTAssertNotNil(tableView.bs.delegate)
    }

    func testLoadingShowsCustomView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let sds = BlankSlate.StatusDrivenDataSource(view: view)
        _ = sds // keep alive

        view.bs.reload(with: .loading)
        XCTAssertTrue(view.bs.isVisible)
    }

    func testEmptyShowsTitle() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let sds = BlankSlate.StatusDrivenDataSource(view: view)
        _ = sds

        view.bs.reload(with: .success)
        XCTAssertTrue(view.bs.isVisible)
    }

    func testFailureShowsTitleAndButton() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let sds = BlankSlate.StatusDrivenDataSource(view: view)
        _ = sds

        view.bs.reload(with: .failure)
        XCTAssertTrue(view.bs.isVisible)
    }

    func testOnRetryClosure() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let sds = BlankSlate.StatusDrivenDataSource(view: view)

        var retryCalled = false
        sds.onRetry = { retryCalled = true }

        view.bs.reload(with: .failure)

        // Simulate button tap via delegate method
        let button = UIButton()
        sds.blankSlate(view, didTapButton: button)
        XCTAssertTrue(retryCalled)
    }

    func testOnRetryAsyncClosure() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let sds = BlankSlate.StatusDrivenDataSource(view: view)

        let expectation = XCTestExpectation(description: "Async retry called")
        sds.onRetryAsync = {
            expectation.fulfill()
        }

        view.bs.reload(with: .failure)

        let button = UIButton()
        sds.blankSlate(view, didTapButton: button)
        wait(for: [expectation], timeout: 2.0)
    }

    func testOnTapViewClosure() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let sds = BlankSlate.StatusDrivenDataSource(view: view)

        var tapCalled = false
        sds.onTapView = { tapCalled = true }

        sds.blankSlate(view, didTapView: view)
        XCTAssertTrue(tapCalled)
    }

    func testTransitionProperty() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let sds = BlankSlate.StatusDrivenDataSource(view: view)
        sds.transition = .bounce(duration: 0.5)

        let result = sds.transition(forBlankSlate: view)
        if case let .bounce(duration) = result {
            XCTAssertEqual(duration, 0.5)
        } else {
            XCTFail("Expected .bounce")
        }
    }

    func testCustomConfigurationStates() {
        let config = BlankSlate.StatusConfiguration(
            loading: .init(title: NSAttributedString(string: "Wait...")),
            empty: .init(title: NSAttributedString(string: "Nothing here")),
            failure: .init(title: NSAttributedString(string: "Oops"))
        )
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let sds = BlankSlate.StatusDrivenDataSource(view: view, configuration: config)
        _ = sds

        // Loading
        view.bs.reload(with: .loading)
        XCTAssertTrue(view.bs.isVisible)

        // Success (empty)
        view.bs.reload(with: .success)
        XCTAssertTrue(view.bs.isVisible)

        // Failure
        view.bs.reload(with: .failure)
        XCTAssertTrue(view.bs.isVisible)
    }

    func testButtonTitleOnlyForNormalState() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let sds = BlankSlate.StatusDrivenDataSource(view: view)
        _ = sds

        view.bs.reload(with: .failure)
        // ButtonTitle should only be returned for .normal state
        XCTAssertNotNil(sds.buttonTitle(forBlankSlate: view, for: .normal))
        XCTAssertNil(sds.buttonTitle(forBlankSlate: view, for: .highlighted))
    }
}

// MARK: - Retry Extension Tests

@MainActor
class RetryExtensionTests: XCTestCase {
    func testReloadWithRetry() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let sds = BlankSlate.StatusDrivenDataSource(view: view)
        _ = sds

        let expectation = XCTestExpectation(description: "Retry called")
        view.bs.reload(with: .failure) {
            expectation.fulfill()
        }

        XCTAssertTrue(view.bs.isVisible)
        // Trigger retry
        let button = UIButton()
        sds.blankSlate(view, didTapButton: button)
        wait(for: [expectation], timeout: 2.0)
    }
}

// MARK: - Accessibility Tests

@MainActor
class AccessibilityTests: XCTestCase {
    func testBlankSlateViewAccessibilityElements() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "No Data")
        ds.detailToReturn = NSAttributedString(string: "Check back later")
        ds.buttonTitleToReturn = NSAttributedString(string: "Retry")
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
        let blankSlateView = view.bs.view
        XCTAssertNotNil(blankSlateView)
        XCTAssertNotNil(blankSlateView?.accessibilityElements)
        XCTAssertFalse(blankSlateView?.accessibilityElements?.isEmpty ?? true)
    }

    func testBlankSlateViewWithImage() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.imageToReturn = UIImage()
        ds.titleToReturn = NSAttributedString(string: "Empty")
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
    }

    func testBlankSlateViewNotAccessibilityElement() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "No Data")
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        let blankSlateView = view.bs.view
        XCTAssertFalse(blankSlateView?.isAccessibilityElement ?? true)
    }
}

// MARK: - Background Gradient Tests

@MainActor
class BackgroundGradientTests: XCTestCase {
    private class GradientDataSource: BlankSlate.DataSource {
        func title(forBlankSlate view: UIView) -> NSAttributedString? { NSAttributedString(string: "Test") }
        func backgroundGradient(forBlankSlate view: UIView) -> CAGradientLayer? {
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
            return gradient
        }
    }

    func testGradientApplied() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = GradientDataSource()
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
        let hasGradient = view.bs.view?.layer.sublayers?.contains(where: { $0 is CAGradientLayer }) ?? false
        XCTAssertTrue(hasGradient)
    }

    func testGradientReplacedOnReload() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = GradientDataSource()
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()
        view.bs.reloadBlankSlate()

        let gradientCount = view.bs.view?.layer.sublayers?.filter({ $0 is CAGradientLayer }).count ?? 0
        XCTAssertEqual(gradientCount, 1)
    }
}

// MARK: - Additional Edge Case Tests

@MainActor
class EdgeCaseTests: XCTestCase {
    func testInsertAtBackWhenMultipleSubviews() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        view.addSubview(UIView())
        view.addSubview(UIView())

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Back")
        let delegate = MockDelegate()
        delegate.shouldInsertAtBack = true
        view.bs.dataSource = ds
        view.bs.delegate = delegate
        view.bs.reloadBlankSlate()

        // BlankSlate view should be at index 0
        XCTAssertTrue(view.bs.isVisible)
        XCTAssertEqual(view.subviews.first, view.bs.view)
    }

    func testInsertAtFrontWhenDelegateReturnsFalse() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        view.addSubview(UIView())
        view.addSubview(UIView())

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Front")
        let delegate = MockDelegate()
        delegate.shouldInsertAtBack = false
        view.bs.dataSource = ds
        view.bs.delegate = delegate
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
        XCTAssertEqual(view.subviews.last, view.bs.view)
    }

    func testImageTintColor() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.imageToReturn = UIImage()
        ds.imageTintColorToReturn = .red
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
    }

    func testButtonImageInsteadOfTitle() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.buttonImageToReturn = UIImage()
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
    }

    func testCustomViewLayout() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.customViewToReturn = UIView()
        ds.layoutToReturn = BlankSlate.Layout(edgeInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), height: 100)
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
    }

    func testImageAlpha() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.imageToReturn = UIImage()
        ds.imageAlphaToReturn = 0.5
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
    }

    func testReloadBlankSlateMethod() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Test")
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()
        XCTAssertTrue(view.bs.isVisible)

        // Reload again with different status
        view.bs.reloadBlankSlate(with: .failure)
        XCTAssertTrue(view.bs.isVisible)
        if case .failure = view.bs.dataLoadStatus {} else { XCTFail("Expected .failure") }
    }

    func testConfigureButtonCallback() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.buttonTitleToReturn = NSAttributedString(string: "Tap Me")
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(ds.configureButtonCalled)
    }

    func testUserInteractionDisabled() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "No Touch")
        let delegate = MockDelegate()
        delegate.shouldAllowTouch = false
        view.bs.dataSource = ds
        view.bs.delegate = delegate
        view.bs.reloadBlankSlate()

        XCTAssertFalse(view.bs.view?.isUserInteractionEnabled ?? true)
    }

    func testTopAlignment() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Top")
        ds.alignmentToReturn = .top(CGPoint(x: 0, y: 20))
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
    }

    func testBottomAlignment() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Bottom")
        ds.alignmentToReturn = .bottom(CGPoint(x: 0, y: 20))
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
    }

    func testImageAnimationThenNoAnimation() {
        // First show with animation, then reload without - should remove animation
        class AnimDS: BlankSlate.DataSource {
            var showAnimation = true
            func image(forBlankSlate view: UIView) -> UIImage? { UIImage() }
            func title(forBlankSlate view: UIView) -> NSAttributedString? { NSAttributedString(string: "Anim") }
            func imageAnimation(forBlankSlate view: UIView) -> CAAnimation? {
                guard showAnimation else { return nil }
                let anim = CABasicAnimation(keyPath: "opacity")
                anim.toValue = 0.5
                anim.duration = 1
                return anim
            }
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = AnimDS()
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()
        XCTAssertTrue(view.bs.isVisible)

        // Reload without animation - covers the removeAnimation branch
        ds.showAnimation = false
        view.bs.reloadBlankSlate()
        XCTAssertTrue(view.bs.isVisible)
    }

    func testCustomViewWithHitTest() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.addSubview(view)
        window.makeKeyAndVisible()

        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let ds = MockDataSource()
        ds.customViewToReturn = customView
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        guard let blankSlateView = view.bs.view else { return XCTFail() }
        blankSlateView.layoutIfNeeded()

        // Hit test on the custom view area
        let center = CGPoint(x: blankSlateView.bounds.midX, y: blankSlateView.bounds.midY)
        let hit = blankSlateView.hitTest(center, with: nil)
        // Should return the custom view or content view
        XCTAssertNotNil(hit)
    }

    func testElementsWithHeight() {
        // Test non-custom elements with explicit height in layout
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Title")
        ds.detailToReturn = NSAttributedString(string: "Detail")
        ds.layoutToReturn = BlankSlate.Layout(height: 50)
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
    }

    func testGestureRecognizerShouldBeginWithNonSelfView() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.addSubview(view)
        window.makeKeyAndVisible()

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "NonSelf")
        let delegate = MockDelegate()
        view.bs.dataSource = ds
        view.bs.delegate = delegate
        view.bs.reloadBlankSlate()

        guard let blankSlateView = view.bs.view else { return XCTFail() }
        // Create a gesture recognizer attached to a different view
        let otherView = UIView()
        let gesture = UITapGestureRecognizer()
        otherView.addGestureRecognizer(gesture)
        // Call gestureRecognizerShouldBegin with a gesture whose view != self
        let result = blankSlateView.gestureRecognizerShouldBegin(gesture)
        XCTAssertTrue(result) // Should fall through to super
    }

    func testScrollViewDelegateSelfAsBlankSlateDelegate() {
        // Test the path where the delegate IS a UIScrollView equal to self
        // This is the edge case in makeBlankSlateView's shouldRecognizeSimultaneously closure
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let scrollView = ScrollViewSelfDelegate(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.addSubview(scrollView)
        window.makeKeyAndVisible()

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "SelfDelegate")
        scrollView.bs.dataSource = ds
        scrollView.bs.delegate = scrollView
        scrollView.bs.reloadBlankSlate()

        guard let blankSlateView = scrollView.bs.view,
              let gestureDelegate = blankSlateView as? UIGestureRecognizerDelegate else { return XCTFail() }
        // Use non-tap gestures to trigger the shouldRecognizeSimultaneously closure
        let gesture1 = UIPanGestureRecognizer()
        let gesture2 = UIPanGestureRecognizer()
        blankSlateView.addGestureRecognizer(gesture1)
        let result = gestureDelegate.gestureRecognizer?(gesture1, shouldRecognizeSimultaneouslyWith: gesture2)
        // Should return false because delegate is self (the scrollView)
        XCTAssertEqual(result, false)
    }
}

// MARK: - Delegate Default Implementation Tests

@MainActor
class DelegateDefaultCallTests: XCTestCase {
    private class MinimalDelegate: BlankSlate.Delegate {}

    func testDefaultDidTapView() {
        let d = MinimalDelegate()
        let view = UIView()
        // Should not crash
        d.blankSlate(view, didTapView: view)
    }

    func testDefaultDidTapButton() {
        let d = MinimalDelegate()
        let view = UIView()
        let button = UIButton()
        d.blankSlate(view, didTapButton: button)
    }

    func testDefaultWillDisappear() {
        let d = MinimalDelegate()
        d.blankSlateWillDisappear(UIView())
    }

    func testDefaultDidDisappear() {
        let d = MinimalDelegate()
        d.blankSlateDidDisappear(UIView())
    }
}

// MARK: - Tap Handling Tests

@MainActor
class TapHandlingTests: XCTestCase {
    func testButtonTapCallsDelegate() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.addSubview(tableView)
        window.makeKeyAndVisible()

        let tvDS = EmptyTableViewDataSource()
        tableView.dataSource = tvDS
        let ds = MockDataSource()
        ds.buttonTitleToReturn = NSAttributedString(string: "Tap Me")
        let delegate = MockDelegate()
        tableView.bs.dataSource = ds
        tableView.bs.delegate = delegate
        tableView.reloadData()

        XCTAssertTrue(tableView.bs.isVisible)
        // Find button in blank slate view and invoke target-action directly
        if let blankSlateView = tableView.bs.view {
            let buttons = findAllSubviews(of: blankSlateView, type: UIButton.self)
            XCTAssertFalse(buttons.isEmpty)
            if let button = buttons.first {
                for target in button.allTargets {
                    guard let actions = button.actions(forTarget: target, forControlEvent: .touchUpInside) else { continue }
                    for action in actions {
                        (target as NSObject).perform(Selector(action), with: button)
                    }
                }
                XCTAssertTrue(delegate.didTapButtonCalled)
            }
        }
    }

    func testContentViewTapCallsDelegate() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.addSubview(view)
        window.makeKeyAndVisible()

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Tap Test")
        let delegate = MockDelegate()
        view.bs.dataSource = ds
        view.bs.delegate = delegate
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
        if let blankSlateView = view.bs.view {
            // Find the tap gesture recognizer and invoke its action directly
            if let tapGesture = blankSlateView.gestureRecognizers?.first(where: { $0 is UITapGestureRecognizer }) as? UITapGestureRecognizer {
                // Invoke the target's action selector directly
                blankSlateView.perform(NSSelectorFromString("didTapContentView:"), with: tapGesture)
                XCTAssertTrue(delegate.didTapViewCalled)
            }
        }
    }

    private func findAllSubviews<T: UIView>(of view: UIView, type: T.Type) -> [T] {
        var result: [T] = []
        for subview in view.subviews {
            if let typed = subview as? T { result.append(typed) }
            result.append(contentsOf: findAllSubviews(of: subview, type: type))
        }
        return result
    }
}

// MARK: - HitTest Tests

@MainActor
class HitTestTests: XCTestCase {
    func testHitTestOnButton() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.addSubview(view)
        window.makeKeyAndVisible()

        let ds = MockDataSource()
        ds.buttonTitleToReturn = NSAttributedString(string: "Hit Me")
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        guard let blankSlateView = view.bs.view else { return XCTFail("No blank slate view") }
        blankSlateView.layoutIfNeeded()

        // Find button and test hit test
        let buttons = findAllSubviews(of: blankSlateView, type: UIButton.self)
        if let button = buttons.first, button.frame.width > 0 {
            let center = button.convert(CGPoint(x: button.bounds.midX, y: button.bounds.midY), to: blankSlateView)
            let hit = blankSlateView.hitTest(center, with: nil)
            XCTAssertTrue(hit is UIButton)
        }
    }

    func testHitTestOnEmptyAreaReturnsNil() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.addSubview(view)

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Hit Test")
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        guard let blankSlateView = view.bs.view else { return XCTFail("No blank slate view") }
        blankSlateView.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        blankSlateView.layoutIfNeeded()

        // Hit test at a corner (likely no control there)
        let hit = blankSlateView.hitTest(CGPoint(x: 1, y: 1), with: nil)
        // Should be nil (pass through) since it's not a button or content view
        XCTAssertNil(hit)
    }

    private func findAllSubviews<T: UIView>(of view: UIView, type: T.Type) -> [T] {
        var result: [T] = []
        for subview in view.subviews {
            if let typed = subview as? T { result.append(typed) }
            result.append(contentsOf: findAllSubviews(of: subview, type: type))
        }
        return result
    }
}

// MARK: - Gesture Recognizer Tests

@MainActor
class GestureRecognizerTests: XCTestCase {
    func testGestureRecognizerShouldBeginWithDelegate() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Gesture")
        let delegate = MockDelegate()
        delegate.shouldAllowTouch = false
        view.bs.dataSource = ds
        view.bs.delegate = delegate
        view.bs.reloadBlankSlate()

        XCTAssertFalse(view.bs.view?.isUserInteractionEnabled ?? true)
    }

    func testSimultaneousGestureRecognition() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let tvDS = EmptyTableViewDataSource()
        tableView.dataSource = tvDS
        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Gesture")
        tableView.bs.dataSource = ds
        tableView.bs.delegate = MockDelegate()
        tableView.reloadData()

        XCTAssertTrue(tableView.bs.isVisible)
    }

    func testGestureRecognizerShouldBeginViaBlankSlateView() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.addSubview(view)
        window.makeKeyAndVisible()

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "GestureBegin")
        let delegate = MockDelegate()
        delegate.shouldAllowTouch = true
        view.bs.dataSource = ds
        view.bs.delegate = delegate
        view.bs.reloadBlankSlate()

        guard let blankSlateView = view.bs.view else { return XCTFail() }
        // Find tap gesture on blank slate view
        if let tapGesture = blankSlateView.gestureRecognizers?.first(where: { $0 is UITapGestureRecognizer }) {
            let shouldBegin = blankSlateView.gestureRecognizerShouldBegin(tapGesture)
            XCTAssertTrue(shouldBegin)
        }
    }

    func testGestureRecognizerShouldBeginReturnsFalse() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.addSubview(view)
        window.makeKeyAndVisible()

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "GestureBlock")
        let delegate = MockDelegate()
        delegate.shouldAllowTouch = false
        view.bs.dataSource = ds
        view.bs.delegate = delegate
        view.bs.reloadBlankSlate()

        guard let blankSlateView = view.bs.view else { return XCTFail() }
        if let tapGesture = blankSlateView.gestureRecognizers?.first(where: { $0 is UITapGestureRecognizer }) {
            let shouldBegin = blankSlateView.gestureRecognizerShouldBegin(tapGesture)
            XCTAssertFalse(shouldBegin)
        }
    }

    func testSimultaneousGestureRecognitionOnBlankSlateView() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.addSubview(tableView)
        window.makeKeyAndVisible()

        let tvDS = EmptyTableViewDataSource()
        tableView.dataSource = tvDS
        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Simultaneous")
        let delegate = MockDelegate()
        tableView.bs.dataSource = ds
        tableView.bs.delegate = delegate
        tableView.reloadData()

        guard let blankSlateView = tableView.bs.view else { return XCTFail() }
        if let tapGesture = blankSlateView.gestureRecognizers?.first(where: { $0 is UITapGestureRecognizer }),
           let gestureDelegate = blankSlateView as? UIGestureRecognizerDelegate {
            // Test with the tap gesture (hits the early return path)
            let otherGesture = UITapGestureRecognizer()
            let result = gestureDelegate.gestureRecognizer?(tapGesture, shouldRecognizeSimultaneouslyWith: otherGesture)
            XCTAssertEqual(result, true)

            // Test with two non-tap gestures (hits the shouldRecognizeSimultaneously closure path)
            let gesture1 = UIPanGestureRecognizer()
            let gesture2 = UIPanGestureRecognizer()
            blankSlateView.addGestureRecognizer(gesture1)
            let result2 = gestureDelegate.gestureRecognizer?(gesture1, shouldRecognizeSimultaneouslyWith: gesture2)
            XCTAssertNotNil(result2)
        }
    }

    func testSimultaneousGestureWithGestureRecognizerDelegate() {
        // Test with a delegate that conforms to UIGestureRecognizerDelegate
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.addSubview(tableView)
        window.makeKeyAndVisible()

        let tvDS = EmptyTableViewDataSource()
        tableView.dataSource = tvDS
        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "GRDelegate")
        let delegate = GestureRecognizerMockDelegate()
        tableView.bs.dataSource = ds
        tableView.bs.delegate = delegate
        tableView.reloadData()

        guard let blankSlateView = tableView.bs.view else { return XCTFail() }
        if let gestureDelegate = blankSlateView as? UIGestureRecognizerDelegate {
            // Use non-tap gestures to enter the shouldRecognizeSimultaneously closure
            let gesture1 = UIPanGestureRecognizer()
            let gesture2 = UIPanGestureRecognizer()
            blankSlateView.addGestureRecognizer(gesture1)
            let result = gestureDelegate.gestureRecognizer?(gesture1, shouldRecognizeSimultaneouslyWith: gesture2)
            XCTAssertEqual(result, true)
        }
    }
}

// MARK: - ScrollView Frame Sync Tests

@MainActor
class ScrollViewFrameSyncTests: XCTestCase {
    func testBlankSlateInScrollViewSyncsFrame() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.addSubview(scrollView)
        window.makeKeyAndVisible()

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Sync")
        scrollView.bs.dataSource = ds
        scrollView.bs.reloadBlankSlate()

        XCTAssertTrue(scrollView.bs.isVisible)
        guard let blankSlateView = scrollView.bs.view else { return XCTFail() }
        // Trigger layout
        scrollView.layoutIfNeeded()
        // View should have a non-zero frame
        XCTAssertGreaterThan(blankSlateView.frame.width, 0)
    }

    func testNonScrollViewParentFrame() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.addSubview(view)
        window.makeKeyAndVisible()

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "NoScroll")
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
        guard let blankSlateView = view.bs.view else { return XCTFail() }
        view.layoutIfNeeded()
        XCTAssertGreaterThan(blankSlateView.frame.width, 0)
    }

    func testTableViewWithContentInsetSyncsFrame() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.addSubview(tableView)
        window.makeKeyAndVisible()
        tableView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)

        let tvDS = EmptyTableViewDataSource()
        tableView.dataSource = tvDS
        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Inset")
        tableView.bs.dataSource = ds
        tableView.reloadData()

        XCTAssertTrue(tableView.bs.isVisible)
    }
}

// MARK: - CollectionView ItemsCount Tests

@MainActor
class CollectionViewItemsCountTests: XCTestCase {
    func testMultipleSectionsInCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        let cvDS = EmptyCollectionViewDataSource()
        cvDS.numberOfSections = 3
        cvDS.numberOfItems = 0
        cv.dataSource = cvDS

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Multi Section")
        cv.bs.dataSource = ds
        cv.reloadData()

        XCTAssertTrue(cv.bs.isVisible)
    }

    func testMinimalTableViewDataSourceWithoutNumberOfSections() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let tvDS = MinimalTableViewDataSource()
        tvDS.numberOfRows = 0
        tableView.dataSource = tvDS

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Minimal")
        tableView.bs.dataSource = ds
        tableView.reloadData()

        XCTAssertTrue(tableView.bs.isVisible)
    }

    func testMinimalCollectionViewDataSourceWithoutNumberOfSections() {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        let cvDS = MinimalCollectionViewDataSource()
        cvDS.numberOfItems = 0
        cv.dataSource = cvDS

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Minimal CV")
        cv.bs.dataSource = ds
        cv.reloadData()

        XCTAssertTrue(cv.bs.isVisible)
    }
}

// MARK: - Force Display Tests

@MainActor
class ForceDisplayTests: XCTestCase {
    func testForceDisplayEvenWithItems() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let tvDS = EmptyTableViewDataSource()
        tvDS.numberOfRows = 5
        tableView.dataSource = tvDS

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Forced")
        let delegate = MockDelegate()
        delegate.shouldForceDisplay = true

        tableView.bs.dataSource = ds
        tableView.bs.delegate = delegate
        tableView.reloadData()

        XCTAssertTrue(tableView.bs.isVisible)
    }

    func testShouldDisplayFalseHides() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let tvDS = EmptyTableViewDataSource()
        tvDS.numberOfRows = 0
        tableView.dataSource = tvDS

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Hidden")
        let delegate = MockDelegate()
        delegate.shouldDisplay = false

        tableView.bs.dataSource = ds
        tableView.bs.delegate = delegate
        tableView.reloadData()

        XCTAssertFalse(tableView.bs.isVisible)
    }

    func testForceDisplayThenDismissWhenNoLongerForced() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let tvDS = EmptyTableViewDataSource()
        tvDS.numberOfRows = 5
        tableView.dataSource = tvDS

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Forced")
        let delegate = MockDelegate()
        delegate.shouldForceDisplay = true

        tableView.bs.dataSource = ds
        tableView.bs.delegate = delegate
        tableView.reloadData()
        XCTAssertTrue(tableView.bs.isVisible)

        // Now items exist and force display is off -> dismiss
        delegate.shouldForceDisplay = false
        tableView.reloadData()
        XCTAssertFalse(tableView.bs.isVisible)
        XCTAssertTrue(delegate.willDisappearCalled)
        XCTAssertTrue(delegate.didDisappearCalled)
    }

    func testDismissWhenDataSourceRemoved() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let tvDS = EmptyTableViewDataSource()
        tvDS.numberOfRows = 0
        tableView.dataSource = tvDS

        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Remove DS")
        tableView.bs.dataSource = ds
        tableView.reloadData()
        XCTAssertTrue(tableView.bs.isVisible)

        // Remove dataSource -> dismiss
        tableView.bs.dataSource = nil
        tableView.reloadData()
        XCTAssertFalse(tableView.bs.isVisible)
    }
}

// MARK: - Image Animation Tests

@MainActor
class ImageAnimationTests: XCTestCase {
    private class AnimatedDataSource: BlankSlate.DataSource {
        func image(forBlankSlate view: UIView) -> UIImage? { UIImage() }
        func title(forBlankSlate view: UIView) -> NSAttributedString? { NSAttributedString(string: "Animated") }
        func imageAnimation(forBlankSlate view: UIView) -> CAAnimation? {
            let anim = CABasicAnimation(keyPath: "transform.rotation")
            anim.toValue = Double.pi * 2
            anim.duration = 1.0
            anim.repeatCount = .infinity
            return anim
        }
    }

    func testImageAnimationApplied() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = AnimatedDataSource()
        view.bs.dataSource = ds
        view.bs.reloadBlankSlate()

        XCTAssertTrue(view.bs.isVisible)
    }
}

// MARK: - SwiftUI Tests

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 14.0, tvOS 14.0, *)
class SwiftUITests: XCTestCase {
    private func renderView<V: SwiftUI.View>(_ view: V) {
        let hostingController = UIHostingController(rootView: view)
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        hostingController.view.setNeedsLayout()
        hostingController.view.layoutIfNeeded()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
    }

    func testStandardEmptyViewRendering() {
        renderView(BlankSlate.StandardEmptyView(
            image: Image(systemName: "tray"),
            title: "Empty",
            detail: "Nothing to show",
            buttonTitle: "Retry",
            onRetry: {}
        ))
    }

    func testStandardEmptyViewWithoutOptionals() {
        renderView(BlankSlate.StandardEmptyView(title: "No Data"))
    }

    func testEmptyStateViewShowingEmpty() {
        renderView(BlankSlate.EmptyStateView(isEmpty: true) {
            Text("Content")
        } empty: {
            Text("Empty State")
        })
    }

    func testEmptyStateViewShowingContent() {
        renderView(BlankSlate.EmptyStateView(isEmpty: false) {
            Text("Content")
        } empty: {
            Text("Empty State")
        })
    }

    func testViewModifierEmpty() {
        renderView(Text("Hello").blankSlate(isEmpty: true, title: "No Data"))
    }

    func testViewModifierNotEmpty() {
        renderView(Text("Hello").blankSlate(isEmpty: false, title: "No Data"))
    }

    func testViewModifierWithAllParams() {
        renderView(Text("Hello").blankSlate(
            isEmpty: true,
            image: Image(systemName: "star"),
            title: "No Favorites",
            detail: "Start adding favorites",
            buttonTitle: "Browse",
            onRetry: {}
        ))
    }

    func testCustomEmptyView() {
        renderView(Text("Hello").blankSlate(isEmpty: true) {
            VStack {
                Image(systemName: "tray")
                Text("Custom Empty")
            }
        })
    }

    func testStandardEmptyViewWithImageOnly() {
        renderView(BlankSlate.StandardEmptyView(
            image: Image(systemName: "photo"),
            title: "No Photos"
        ))
    }

    func testStandardEmptyViewWithDetailOnly() {
        renderView(BlankSlate.StandardEmptyView(
            title: "Empty",
            detail: "No items to display"
        ))
    }

    func testStandardEmptyViewWithButtonButNoRetry() {
        renderView(BlankSlate.StandardEmptyView(
            title: "Empty",
            buttonTitle: "Action"
        ))
    }
}
#endif

// MARK: - Performance Tests

/// Performance regression tests with CI-friendly baseline assertions.
///
/// Each test measures a hot path and asserts it completes within a generous threshold (3× measured baseline).
/// Baselines were established on iPhone 17 Pro Simulator (2026-05-31):
/// - Full reload (UITableView, 4 elements): ~0.56ms/call
/// - Full reload (UIView): ~0.53ms/call
/// - Dismiss + Reshow: ~0.29ms/call
/// - 50 sections itemsCount: ~0.31ms/call
/// - StatusDriven 3-state: ~0.22ms/call
/// - Gradient reload: ~0.12ms/call
@MainActor
class PerformanceTests: XCTestCase {
    /// Measures the full reload cycle: reloadData() → swizzled reloadBlankSlateIfNeeded() → view creation + constraints.
    /// Baseline: 0.56ms/call → Threshold: 2ms/call (100 calls < 200ms)
    func testPerformanceReloadBlankSlate_UITableView() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let tvDS = EmptyTableViewDataSource()
        tableView.dataSource = tvDS
        let ds = MockDataSource()
        ds.imageToReturn = UIImage()
        ds.titleToReturn = NSAttributedString(string: "Perf Title")
        ds.detailToReturn = NSAttributedString(string: "Perf Detail")
        ds.buttonTitleToReturn = NSAttributedString(string: "Retry")
        tableView.bs.dataSource = ds

        let start = CACurrentMediaTime()
        for _ in 0..<100 { tableView.reloadData() }
        let elapsed = CACurrentMediaTime() - start

        XCTAssertLessThan(elapsed, 0.200, "UITableView full reload regression: \(elapsed * 10)ms/call (baseline: 0.56ms)")
        measure {
            for _ in 0..<100 { tableView.reloadData() }
        }
    }

    /// Measures reloadBlankSlate on a plain UIView (no swizzle overhead).
    /// Baseline: 0.53ms/call → Threshold: 2ms/call (100 calls < 200ms)
    func testPerformanceReloadBlankSlate_UIView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.imageToReturn = UIImage()
        ds.titleToReturn = NSAttributedString(string: "Perf Title")
        ds.detailToReturn = NSAttributedString(string: "Perf Detail")
        ds.buttonTitleToReturn = NSAttributedString(string: "Retry")
        view.bs.dataSource = ds

        let start = CACurrentMediaTime()
        for _ in 0..<100 { view.bs.reloadBlankSlate() }
        let elapsed = CACurrentMediaTime() - start

        XCTAssertLessThan(elapsed, 0.200, "UIView full reload regression: \(elapsed * 10)ms/call (baseline: 0.53ms)")
        measure {
            for _ in 0..<100 { view.bs.reloadBlankSlate() }
        }
    }

    /// Measures dismiss + re-show cycle.
    /// Baseline: 0.29ms/call → Threshold: 1ms/call (100 cycles < 100ms)
    func testPerformanceDismissAndReshow() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Toggle")
        view.bs.dataSource = ds

        let start = CACurrentMediaTime()
        for _ in 0..<100 {
            view.bs.reloadBlankSlate()
            view.bs.dismiss()
        }
        let elapsed = CACurrentMediaTime() - start

        XCTAssertLessThan(elapsed, 0.100, "Dismiss+Reshow regression: \(elapsed * 5)ms/cycle (baseline: 0.29ms)")
        measure {
            for _ in 0..<100 {
                view.bs.reloadBlankSlate()
                view.bs.dismiss()
            }
        }
    }

    /// Measures itemsCount with many sections (50 sections × 0 items).
    /// Baseline: 0.31ms/call → Threshold: 1ms/call (100 calls < 100ms)
    func testPerformanceItemsCount_ManySections() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let tvDS = EmptyTableViewDataSource()
        tvDS.numberOfSections = 50
        tvDS.numberOfRows = 0
        tableView.dataSource = tvDS
        let ds = MockDataSource()
        ds.titleToReturn = NSAttributedString(string: "Many Sections")
        tableView.bs.dataSource = ds

        let start = CACurrentMediaTime()
        for _ in 0..<100 { tableView.reloadData() }
        let elapsed = CACurrentMediaTime() - start

        XCTAssertLessThan(elapsed, 0.100, "50-section itemsCount regression: \(elapsed * 10)ms/call (baseline: 0.31ms)")
        measure {
            for _ in 0..<100 { tableView.reloadData() }
        }
    }

    /// Measures StatusDrivenDataSource reload cycle (loading → failure → success).
    /// Baseline: 0.22ms/state → Threshold: 1ms/state (150 state changes < 150ms)
    func testPerformanceStatusDrivenReload() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let sds = BlankSlate.StatusDrivenDataSource(view: view)
        _ = sds

        let start = CACurrentMediaTime()
        for _ in 0..<50 {
            view.bs.reload(with: .loading)
            view.bs.reload(with: .failure)
            view.bs.reload(with: .success)
        }
        let elapsed = CACurrentMediaTime() - start

        XCTAssertLessThan(elapsed, 0.150, "StatusDriven regression: \(elapsed / 150 * 1000)ms/state (baseline: 0.22ms)")
        measure {
            for _ in 0..<50 {
                view.bs.reload(with: .loading)
                view.bs.reload(with: .failure)
                view.bs.reload(with: .success)
            }
        }
    }

    /// Measures gradient layer creation + removal cycle.
    /// Baseline: 0.12ms/call → Threshold: 0.5ms/call (100 calls < 50ms)
    func testPerformanceGradientReload() {
        class GradientDS: BlankSlate.DataSource {
            func title(forBlankSlate view: UIView) -> NSAttributedString? { NSAttributedString(string: "Gradient") }
            func backgroundGradient(forBlankSlate view: UIView) -> CAGradientLayer? {
                let g = CAGradientLayer()
                g.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
                return g
            }
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let ds = GradientDS()
        view.bs.dataSource = ds

        let start = CACurrentMediaTime()
        for _ in 0..<100 { view.bs.reloadBlankSlate() }
        let elapsed = CACurrentMediaTime() - start

        XCTAssertLessThan(elapsed, 0.050, "Gradient reload regression: \(elapsed * 10)ms/call (baseline: 0.12ms)")
        measure {
            for _ in 0..<100 { view.bs.reloadBlankSlate() }
        }
    }
}

