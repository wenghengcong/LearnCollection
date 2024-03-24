// Kevin Li - 6:10 PM - 7/14/20

import SwiftUI

public struct CalendarTheme: Equatable, Hashable {

    public let primary: Color
    public let titleColor: Color
    public let textColor: Color
    public let todayTextColor: Color
    public let todayBackgroundColor: Color

    public init(primary: Color, 
                titleColor: Color? = nil,
                textColor: Color? = nil,
                todayTextColor: Color? = nil,
                todayBackgroundColor: Color? = nil) {
        self.primary = primary

        if let titleColor = titleColor { self.titleColor = titleColor } else { self.titleColor = primary }
        if let textColor = textColor { self.textColor = textColor } else { self.textColor = .primary }
        if let todayTextColor = todayTextColor { self.todayTextColor = todayTextColor } else { self.todayTextColor = primary }
        if let todayBackgroundColor = todayBackgroundColor { self.todayBackgroundColor = todayBackgroundColor } else { self.todayBackgroundColor = .primary }
    }

}

public extension CalendarTheme {

    static let allThemes: [CalendarTheme] = [.brilliantViolet, .craftBrown, .fluorescentPink, .kiwiGreen, .mauvePurple, .orangeYellow, .red, .royalBlue]

    static let brilliantViolet = CalendarTheme(primary: .brilliantViolet)
    static let craftBrown = CalendarTheme(primary: .craftBrown)
    static let fluorescentPink = CalendarTheme(primary: .fluorescentPink)
    static let kiwiGreen = CalendarTheme(primary: .kiwiGreen)
    static let mauvePurple = CalendarTheme(primary: .mauvePurple)
    static let orangeYellow = CalendarTheme(primary: .orangeYellow)
    static let red = CalendarTheme(primary: .red)
    static let royalBlue = CalendarTheme(primary: .royalBlue)

}

extension CalendarTheme {

    static let `default`: CalendarTheme = .royalBlue

}

/// COM: 下面两个是实现environment变量的方法
/*
 private struct MyEnvironmentKey: EnvironmentKey {
     static let defaultValue: String = "Default value"
 }


 extension EnvironmentValues {
     var myCustomValue: String {
         get { self[MyEnvironmentKey.self] }
         set { self[MyEnvironmentKey.self] = newValue }
     }
 }


 extension View {
     func myCustomValue(_ myCustomValue: String) -> some View {
         environment(\.myCustomValue, myCustomValue)
     }
 }
 */
/// 第一步：继承EnvironmentKey，实现defaultValue
struct CalendarThemeKey: EnvironmentKey {

    static let defaultValue: CalendarTheme = .default

}

/// 第二步：在EnvironmentValues的extension中设置存取方法
extension EnvironmentValues {
    var calendarTheme: CalendarTheme {
        get { self[CalendarThemeKey.self] }
        set { self[CalendarThemeKey.self] = newValue }
    }
}

/// 第三步：使用
/// view.environment(\.calendarTheme, self.theme) or
/// @Environment(\.calendarTheme) var theme: CalendarTheme

private extension Color {

    static let brilliantViolet = Color("brilliantViolet")
    static let craftBrown = Color("craftBrown")
    static let fluorescentPink = Color("fluorescentPink")
    static let kiwiGreen = Color("kiwiGreen")
    static let mauvePurple = Color("mauvePurple")
    static let orangeYellow = Color("orangeYellow")
    static let red = Color("red")
    static let royalBlue = Color("royalBlue")

}
