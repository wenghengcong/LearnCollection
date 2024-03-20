// Kevin Li - 5:19 PM - 6/14/20

import SwiftUI

public protocol ElegantCalendarDataSource: MonthlyCalendarDataSource, YearlyCalendarDataSource { }

public protocol MonthlyCalendarDataSource {
    
    /// 日期背景
    /// - Parameter date: <#date description#>
    /// - Returns: <#description#>
    func calendar(backgroundColorOpacityForDate date: Date) -> Double
    
    /// 是否能选中
    /// - Parameter date: <#date description#>
    /// - Returns: <#description#>
    func calendar(canSelectDate date: Date) -> Bool
    
    /// 选中的视图
    /// - Parameters:
    ///   - date: <#date description#>
    ///   - size: <#size description#>
    /// - Returns: <#description#>
    func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView

}


public extension MonthlyCalendarDataSource {

    func calendar(backgroundColorOpacityForDate date: Date) -> Double { 1 }

    func calendar(canSelectDate date: Date) -> Bool { true }

    func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
        EmptyView().erased
    }

}

// TODO: Depending on future design choices, this may need some functions and properties
public protocol YearlyCalendarDataSource { }
