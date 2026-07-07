import SwiftUI

/// warm hotel-lobby espresso with a brass-key accent
enum Theme {
    static let background = Color(red: 0.122, green: 0.086, blue: 0.078)
    static let accent = Color(red: 0.78, green: 0.541, blue: 0.243)
    static let ink = Color(red: 0.969, green: 0.937, blue: 0.894)
    static let cardBackground = Color(red: 0.192, green: 0.157, blue: 0.149)
    static let secondaryInk = Color(red: 0.812, green: 0.78, blue: 0.737)

    static let titleFont = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let headingFont = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)

    static let cornerRadius: CGFloat = 18
}

extension View {
    func themedBackground() -> some View {
        self.background(Theme.background.ignoresSafeArea())
    }
}
