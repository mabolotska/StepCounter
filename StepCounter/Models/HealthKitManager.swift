
import SwiftUI
import HealthKit

class HealthKitManager {
    private var healthStore: HKHealthStore?
    let healthType = HKQuantityType(.stepCount)
    
    init() {
        healthStore = HKHealthStore()
    }
    
    func requestStepCountAuthorization() async -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else {
            return false
        }
        do {
            try await healthStore?.requestAuthorization(toShare: [], read: [healthType])
            return healthStore?.authorizationStatus(for: healthType) == .sharingAuthorized
        } catch {
            print("*** Error requesting HealthKit authorization: \(error.localizedDescription)")
            return false
        }
    }
    
    func getStepCount(for date: Date, completion: @escaping (Double, Error?) -> Void) {
        
        guard let stepCountType = HKSampleType.quantityType(forIdentifier: .stepCount) else { return }
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        
        let endOfDay = Calendar.current.date(byAdding: components, to: startOfDay)
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: endOfDay,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            if let result = result, let sum = result.sumQuantity() {
                let count = sum.doubleValue(for: HKUnit.count())
                completion(count, nil)
            } else {
                completion(0.0, error)
            }
        }
        healthStore?.execute(query)
    }
}
