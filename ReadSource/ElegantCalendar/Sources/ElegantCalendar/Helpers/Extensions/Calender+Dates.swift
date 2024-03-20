// Kevin Li - 7:28 PM - 6/10/20

import SwiftUI

extension Calendar {

    /// COM: 
    /// 首先，创建一个 DateComponents 对象 components。
    /// 将 components 的 day 属性设置为 1，表示向给定日期的后一天。
    /// 将 components 的 second 属性设置为 -1，表示向前推一秒，即从第二天的零时零分零秒回溯一秒，即得到当天的最后一刻。
    /// 调用 self.date(byAdding:to:) 方法，将 components 添加到给定日期的起始时刻，即获取当天的最后一刻时间。
    /// 返回计算得到的时间
    func endOfDay(for date: Date) -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return self.date(byAdding: components, to: startOfDay(for: date))!
    }

    func isDate(_ date1: Date, equalTo date2: Date, toGranularities components: Set<Calendar.Component>) -> Bool {
        /// COM: reduce函数，into初始值
        components.reduce(into: true) { isEqual, component in
            isEqual = isEqual && isDate(date1, equalTo: date2, toGranularity: component)
        }
    }

    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.month, .year], from: date)
        return self.date(from: components)!
    }

    func startOfYear(for date: Date) -> Date {
        let components = dateComponents([.year], from: date)
        return self.date(from: components)!
    }

}

extension Calendar {

    func generateDates(inside interval: DateInterval,
                       matching components: DateComponents) -> [Date] {
       var dates: [Date] = []
       dates.append(interval.start)

       enumerateDates(
           startingAfter: interval.start,
           matching: components,
           matchingPolicy: .nextTime) { date, _, stop in
           if let date = date {
               if date < interval.end {
                   dates.append(date)
               } else {
                   stop = true
               }
           }
       }

       return dates
    }

}
