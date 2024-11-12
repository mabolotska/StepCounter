import SwiftUI

enum HealthKitAuthorizationStatus {
    case notDetermined
    case authorized
}


struct StepCounterView: View {
    @StateObject private var viewModel = StepCounterViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            switch viewModel.authorizationStatus {
            case .notDetermined:
                Text("Fetching your step count...")
                    .font(.headline)
            case .authorized:
                Text("Step Counter")
                    .font(.largeTitle)
                    .padding(.top)
                
                Text("Date: \(viewModel.currentDate, formatter: DateFormatter.shortDate)")
                    .font(.title2)
                
                HStack {
                    previousDayButton()
                    
                    CircularProgressView(
                        progress: viewModel.progress,
                        stepCount: Int(viewModel.stepCount),
                        hasError: viewModel.stepFetchError  // Pass error state
                    )
                    .frame(width: 200, height: 200)
                    .padding()
                    
                    nextDayButton()
                }
            }
        }
        .onAppear {
            viewModel.fetchSteps(for: viewModel.currentDate)
        }
    }
    
    func previousDayButton() -> some View {
        Button(action: viewModel.goToPreviousDay) {
            Image(systemName: "chevron.left")
                .font(.title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }
    
    func nextDayButton() -> some View {
        Button(action: viewModel.goToNextDay) {
            Image(systemName: "chevron.right")
                .font(.title)
                .padding()
                .background(viewModel.isToday ? Color.gray : Color.green)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
        .disabled(viewModel.isToday)  // Disable when viewing today
    }
}

extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}
