import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    
    private var pages: [(icon: String, title: String, description: String, color: Color)] {
        [
        (
            "atom",
            L10n.onboardingTitle1,
            L10n.onboardingDesc1,
            .blue
        ),
        (
            "function",
            L10n.onboardingTitle2,
            L10n.onboardingDesc2,
            .green
        ),
        (
            "arrow.left.arrow.right",
            L10n.onboardingTitle3,
            L10n.onboardingDesc3,
            .orange
        ),
        (
            "chart.line.uptrend.xyaxis",
            L10n.onboardingTitle4,
            L10n.onboardingDesc4,
            .purple
        ),
        (
            "tablecells",
            L10n.onboardingTitle5,
            L10n.onboardingDesc5,
            .red
        ),
        (
            "textformat.123",
            L10n.onboardingTitle6,
            L10n.onboardingDesc6,
            .teal
        ),
    ]
    }
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: pages[index].icon)
                            .font(.system(size: 80))
                            .foregroundColor(pages[index].color)
                            .padding(.bottom, 10)
                        
                        Text(pages[index].title)
                            .font(.title.weight(.bold))
                        
                        Text(pages[index].description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            Button {
                if currentPage < pages.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    hasSeenOnboarding = true
                }
            } label: {
                Text(currentPage < pages.count - 1 ? L10n.next : L10n.start)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .cornerRadius(14)
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            
            if currentPage < pages.count - 1 {
                Button(L10n.skip) {
                    hasSeenOnboarding = true
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 16)
            } else {
                Color.clear.frame(height: 36)
            }
        }
        .oledBackground()
    }
}
