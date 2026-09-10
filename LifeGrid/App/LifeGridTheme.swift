import SwiftUI

/// Shared visual language for LifeGrid's calm, reflective experience.
enum LifeGridTheme {
    static let background = Color(red: 0.98, green: 0.95, blue: 0.90)
    static let surface = Color(red: 1.00, green: 0.99, blue: 0.97)
    static let peach = Color(red: 0.96, green: 0.58, blue: 0.42)
    static let peachSoft = Color(red: 0.99, green: 0.82, blue: 0.70)
    static let lavender = Color(red: 0.72, green: 0.67, blue: 0.88)
    static let lavenderSoft = Color(red: 0.91, green: 0.88, blue: 0.97)
    static let mint = Color(red: 0.55, green: 0.76, blue: 0.67)
    static let mintSoft = Color(red: 0.84, green: 0.92, blue: 0.87)
    static let ink = Color(red: 0.22, green: 0.20, blue: 0.24)
    static let secondaryInk = Color(red: 0.42, green: 0.39, blue: 0.44)
}

struct LifeGridCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(LifeGridTheme.surface, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(LifeGridTheme.ink.opacity(0.06), lineWidth: 1)
            }
            .shadow(color: LifeGridTheme.ink.opacity(0.05), radius: 14, y: 7)
    }
}

extension View {
    func lifeGridCard() -> some View {
        modifier(LifeGridCardModifier())
    }
}
