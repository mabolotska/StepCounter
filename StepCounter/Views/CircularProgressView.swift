import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let lineWidth: CGFloat = 20
    let stepCount: Int
    let hasError: Bool  // parameter to check for error
    
    private var formattedStepCount: Double {
        hasError ? 0 : Double(stepCount)
    }
    
    // Dynamic color that darkens based on progress
    private var progressColor: Color {
        Color.pink.opacity(0.3 + progress * 0.7)  
    }
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(
                    Color.gray.opacity(0.3),
                    lineWidth: lineWidth
                )
            
            // Progress Circle with dynamic color
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    progressColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            
            
            Text(hasError ? "No data" : "\(stepCount) steps")
                .fontWeight(.bold)
                .foregroundColor(Color.green)
                .multilineTextAlignment(.center)
        }
    }
}



#Preview {
    CircularProgressView(progress: 0.5, stepCount: 100, hasError: false)
}
