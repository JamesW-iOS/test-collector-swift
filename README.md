# Buildkite Test Collector for Swift (Beta)

Official [Buildkite Test Analytics](https://buildkite.com/test-analytics) collector for Swift test frameworks ✨

⚒ **Supported test frameworks:** XCTest, and [more coming soon](https://github.com/buildkite/test-collector-swift/labels/test%20framework).

📦 **Supported CI systems:** Buildkite, GitHub Actions, CircleCI, and others via the `BUILDKITE_ANALYTICS_*` environment variables.

## 👉 Installing

### Step 1

[Create a test suite](https://buildkite.com/docs/test-analytics), and copy the API token that it gives you.


#### Swift Package Manager
 
To use the Buildkite Test Collector with a SwiftPM project, add this repository to the `Package.swift` manifest and add `BuildkiteTestCollector` to any test target requiring analytics:

```swift
let package = Package(
  name: "MyProject",
  dependencies: [
    .package(url: "https://github.com/buildkite/test-collector-swift", from: "0.1.1")
  ],
  targets: [
    .target(name: "MyProject"),
    .testTarget(
      name: "MyProjectTests",
      dependencies: [
        "MyProject",
        .product(name: "BuildkiteTestCollector", package: "test-collector-swift")
      ]
    )
  ]
)
```
 
### Step 2
Set the `BUILDKITE_ANALYTICS_TOKEN` secret on your CI to the API token from earlier.

### Step 3

Push your changes to a branch, and open a pull request. After a test run has been triggered, results will start appearing in your analytics dashboard. 

```bash
git checkout -b add-buildkite-test-analytics
git commit -am "Add Buildkite Test Analytics"
git push origin add-buildkite-test-analytics
```

## Mapping environment varibles

Because Xcode does not pass environment variables down to the test runner the following extra steps are required if testing iOS/macOS/watchOS apps. We need to manually specify environment variables to be passed to the test runner, this can be done in a number of ways.

### Using the provided `environment.plist` files

The easiest way is to use the `environment.plist` provided with this repository.

**Step 1**

In the EnvironmentFiles directory at the root of this repository are prefilled `.plist ` files for a number of popular CI providers. If your provider is one of the ones in the folder copy that file into the main app target for your project. Make sure to check 'copy items if needed' and that it is being added to your app target. If your provider is not listed use the `custom_environment.plist` file.

**Step 2**

Rename the file and remove the prefix, the file should now be named `environment.plist`.

**Step 3**

Go to the build settings for your main app target and change `Convert Copied Files` to `Yes`.

### If Using Schemes

If for whatever reason you are unable to use the `environment.plist` file method you may manually specify enviroment varibles to be passed to the test runner in the scheme editor.

**Step 1**

Select Edit Scheme in the scheme selector

**Step 2**

Go to the test section and uncheck 'Use the Run action's arguments and environment variables'

**Step 3**

In a separate editor(VSCode, Text Edit, etc) open the `environment.plist` file associated with your CI environment.

**Step 4**

For each of the key value pairs in the `.plist` add an entry in the 'Environment Variables' section of your scheme. For example if you were using Build Kite as your CI environment you would first add an entry with `BUILDKITE_ANALYTICS_TOKEN` as the 'Name' and `$BUILDKITE_ANALYTICS_TOKEN` as the 'Value'. Then one with `BUILDKITE_BUILD_ID` as the 'Name' and `$BUILDKITE_BUILD_ID` as the 'Value'. Repeat for every value in the `.plist` file.

### If using test Test Plans

If you are instead using Test Plans rather than test scheme's the process is similar.

**Step 1**

Open you test plan and go to the 'Shared Settings' section

**Step 2**

In a separate editor(VSCode, Text Edit, etc) open the `environment.plist` file associated with your CI environment.

**Step 3**

Open the 'Environment Variables' section in the test plan settings

**Step 4**

For each of the key value pairs in the `.plist` add an entry. For example if you were using Build Kite as your CI environment you would first add a row with `BUILDKITE_ANALYTICS_TOKEN` as the 'Name' and `$BUILDKITE_ANALYTICS_TOKEN` as the 'Value'. Then one with `BUILDKITE_BUILD_ID` as the 'Name' and `$BUILDKITE_BUILD_ID` as the 'Value'. Repeat for every value in the `.plist` file.
## 🔍 Debugging

To enable debugging output, set the `BUILDKITE_ANALYTICS_DEBUG_ENABLED` environment variable to `true`.

## 🔜 Roadmap

See the [GitHub 'enhancement' issues](https://github.com/buildkite/test-collector-swift/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement) for planned features. Pull requests are always welcome, and we’ll give you feedback and guidance if you choose to contribute 💚

## 👩‍💻 Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buildkite/test-collector-swift

## 📜 License

The package is available as open source under the terms of the [MIT License](https://github.com/buildkite/test-collector-swift/blob/main/LICENSE).
