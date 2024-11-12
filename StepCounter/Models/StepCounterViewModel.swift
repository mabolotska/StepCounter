import SwiftUI
import HealthKit

class StepCounterViewModel: ObservableObject {
    @Published var stepCount: Double = 0.0
    @Published var currentDate: Date = Date()
    private let healthKitManager = HealthKitManager()
    private let targetStepCount: Double = 15000
    @Published var authorizationStatus: HealthKitAuthorizationStatus = .notDetermined
    @Published var stepFetchError: Bool = false  // Track fetch error
    
    var progress: Double {
        min(stepCount / targetStepCount, 1.0) // Cap progress at 1.0 (100%)
    }
    
    init() {
        Task {
            await requestAuthorization()
        }
    }
    
    func requestAuthorization() async {
        let granted = await healthKitManager.requestStepCountAuthorization()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.authorizationStatus = .authorized
            if granted {
                Task {
                    self.fetchSteps(for: self.currentDate)
                }
            } else {
                print("Authorization failed")
            }
        }
    }
    
    func fetchSteps(for date: Date) {
        healthKitManager.getStepCount(for: date) { [weak self] steps, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    self.stepFetchError = true  // Set error state
                    print("Error fetching steps: \(error.localizedDescription)")
                } else {
                    self.stepFetchError = false  // Clear error state
                    self.stepCount = steps
                }
            }
        }
    }
    
    func goToPreviousDay() {
        currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? Date()
        fetchSteps(for: currentDate)
    }
    
    func goToNextDay() {
        // Temporarily move to the next day
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
        
        // Only update if the new date is not today
        if !Calendar.current.isDateInToday(nextDate) {
            currentDate = nextDate
            fetchSteps(for: currentDate)
        } else {
            // If the new date is today, just set currentDate to today
            currentDate = Date()
            fetchSteps(for: currentDate)
        }
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(currentDate)
    }
}
