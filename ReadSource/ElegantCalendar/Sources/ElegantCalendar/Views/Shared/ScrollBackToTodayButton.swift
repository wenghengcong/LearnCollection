// Kevin Li - 7:14 PM - 6/14/20

import SwiftUI
import UIKit

struct ScrollBackToTodayButton: View {

    let scrollBackToToday: () -> Void
    let color: Color

    var body: some View {
        Button(action: scrollBackToToday) {
            Image(systemName: "arrow.uturn.backward")
                .renderingMode(.original)
                .resizable()
                .frame(width: 30, height: 25)
                .foregroundColor(color)
        }
        .animation(.easeInOut)
    }

}

struct ScrollBackToTodayButton_Previews: PreviewProvider {
    static var previews: some View {
        LightDarkThemePreview {
            ScrollBackToTodayButton(scrollBackToToday: {}, color: .purple)
        }
    }
}
