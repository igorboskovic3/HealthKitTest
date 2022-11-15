# Health App Automated Testing Error Replicating Example

This repository demonstrates that the Health App on the iOS simulator instance running in a GitHub Action Runner environment does not display any content in the "Browse" section, making it impossible to test adding external HealthKit data such as EEG data in a UI test.

## Expected Behaviour

1. Download and install [Xcode 14.1](https://developer.apple.com/xcode/resources/)
2. [Reset the Simulator to get a completely clean instance](https://help.apple.com/simulator/mac/11.0/index.html?localePath=en.lproj#/devb4e6888f0)
3. [Run the UI Tests](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/05-running_tests.html) in this Repo by opening `TestApp.xcodeproj`.
4. The unit tests open the Health App and add Health Data using UI tests. You can observe the behavior in the iOS Simulator and see the Results in the Health App:
<p float="left">
  <img src="https://user-images.githubusercontent.com/28656495/201808827-f968a4b3-1bd8-4b8c-b468-b506247516fc.png" width="320" />
  <img src="https://user-images.githubusercontent.com/28656495/201808822-9b2215a5-c566-4158-9041-748ff2b3c64b.png" width="320" />
  <img src="https://user-images.githubusercontent.com/28656495/201808830-891a7580-0475-4ebe-9290-3125f3387b1e.png" width="320" />
</p>


## Observed Behaviour on GitHub Action Runners

- The GitHub Action Runners run the same UI tests using the GitHub Action found in `.github/workflows`: `build_and_test.yml`.
- The tests fail as the HealthKit's "Browse" tab does not include any content, e.g.,: https://github.com/CardinalKit/HealthKitTest/actions/runs/3466876834.
- The GitHub Action demonstrates this behavior as the UI tests create a screenshot on save and saves it in a `.xcresult` package.
- You can download the results bundle as an artifact created by the UI test and observe its behavior in Xcode by opening the `TestAppUITests.xcresult`. 
- The following screenshot taken from the https://github.com/CardinalKit/HealthKitTest/actions/runs/3466876834 GitHub Action's `.xcresult` file from the GitHub Action run demonstrates this behavior:
<p float="left">
  <img src="https://user-images.githubusercontent.com/28656495/201814203-a0ae3c23-fe67-4d72-aeaa-8c15022f67ea.jpg" width="320" />
</p>
