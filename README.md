# StepCounter

A simple SwiftUI app that displays daily step count statistics. This app allows users to view their step progress for a selected date, navigate between days, and displays a visual progress indicator of the user's daily step goal.

## Approach

The app is designed using SwiftUI with an MVVM architecture. It uses `HealthKit` to fetch step data asynchronously for a specific date. The app initializes by requesting HealthKit permissions, and upon successful authorization, retrieves the user's step count for the current date.

Key features include:
- **HealthKit Integration**: Handles authorization requests and fetches step count data for a given day.
- **Async/Await for Asynchronous Calls**: Uses Swift’s async/await to request HealthKit authorization, making the code simpler and avoiding callback nesting.
- **Progress Tracking**: A progress bar shows the user's progress towards a target daily step count.
- **Date Navigation**: Allows users to navigate between previous days while ensuring they don’t go past the current date.

### View Model (`StepCounterViewModel`)

The `StepCounterViewModel` class manages app logic, handling HealthKit interactions, updating the step count, and storing the selected date. The app uses two main functions to switch dates:
- `goToPreviousDay()`: Decrements the day by one and fetches the step count for that date.
- `goToNextDay()`: Increments the day by one, unless it’s today, to avoid future dates.

## Running the App

### Prerequisites
1. **HealthKit Authorization**: Ensure that HealthKit is enabled in the app's entitlements and the app is installed on a device (HealthKit is unavailable in the simulator).
2. **iOS Device with Step Count Data**: The app requires step data, which is only available on physical devices with the necessary sensors.

### Setup
1. Clone the repository or download the source code.
2. Open the project in Xcode.
3. Build and run the app on a physical iOS device.

The app will request HealthKit authorization on launch. Once granted, the app fetches and displays the step count for the current day. Use the navigation buttons to view step data for previous days.

## Challenges

- **HealthKit on Simulator**: HealthKit data isn't available in the iOS Simulator, so development requires testing on an actual device with step data.
- **Async/Await with HealthKit**: Combining HealthKit’s completion handlers with Swift's async/await required a careful approach to avoid threading issues, especially for UI updates.
- **Date Management**: Navigating dates, especially handling the next-day navigation without allowing future dates, needed custom logic to ensure the correct date was displayed without stepping into future days.

## Future Improvements

1. **Configurable Step Goal**: Allow users to set their target step count.
2. **Better Error Handling**: Improve error feedback with user-friendly messages in the UI.
3. **Weekly/Monthly Stats**: Expand the app to include broader time-frame statistics.

