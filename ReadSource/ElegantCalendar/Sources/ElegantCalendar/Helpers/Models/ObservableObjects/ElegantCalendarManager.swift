// Kevin Li - 5:25 PM - 6/10/20

import Combine
import ElegantPages
import SwiftUI

public class ElegantCalendarManager: ObservableObject {

    public var currentMonth: Date {
        monthlyManager.currentMonth
    }

    public var selectedDate: Date? {
        monthlyManager.selectedDate
    }

    public var isShowingYearView: Bool {
        pagesManager.currentPage == 0
    }

    @Published public var datasource: ElegantCalendarDataSource?
    @Published public var delegate: ElegantCalendarDelegate?

    public let configuration: CalendarConfiguration

    @Published public var yearlyManager: YearlyCalendarManager
    @Published public var monthlyManager: MonthlyCalendarManager

    let pagesManager: ElegantPagesManager

    private var anyCancellable = Set<AnyCancellable>()

    public init(configuration: CalendarConfiguration, initialMonth: Date? = nil) {
        self.configuration = configuration

        yearlyManager = YearlyCalendarManager(configuration: configuration,
                                              initialYear: initialMonth)
        monthlyManager = MonthlyCalendarManager(configuration: configuration,
                                                initialMonth: initialMonth)
        // TODO: 作用待定
        pagesManager = ElegantPagesManager(startingPage: 1,
                                           pageTurnType: .calendarEarlySwipe)

        yearlyManager.communicator = self
        monthlyManager.communicator = self

        $datasource
            .sink {
                self.monthlyManager.datasource = $0
                self.yearlyManager.datasource = $0
            }
        /// COM: .store(in: &anyCancellable) 方法的作用是将订阅的引用存储到一个集合中，以确保订阅持续存在，并在需要时可以取消订阅
            .store(in: &anyCancellable)

        $delegate
            .sink {
                self.monthlyManager.delegate = $0
                self.yearlyManager.delegate = $0
            }
            .store(in: &anyCancellable)

        /// COM: CombineLatest 会将多个 Publisher 的最新值进行合并，并在任何一个 Publisher 发出新值时触发闭包执行
        /// 当 yearlyManager.objectWillChange 或 monthlyManager.objectWillChange 中任意一个 Publisher 发出新的变化时，闭包将会被触发执行sink了的逻辑
        /// 闭包中执行 self.objectWillChange.send()，这里的 objectWillChange 是 ObservableObject 协议中定义的 objectWillChange Publisher。当对象的任何 @Published 属性发生变化时，都会调用这个 Publisher，以通知外界该对象的变化
        /// 因此，当 yearlyManager 或 monthlyManager 的任何属性发生变化时，都会触发闭包执行，并调用 self.objectWillChange.send()，从而发送一个整体的变化通知。
        /// 最后，通过 .store(in: &anyCancellable) 方法将订阅返回的 AnyCancellable 对象存储到 anyCancellable 集合中，以确保订阅持续存在，直到对象被释放或需要取消订阅
        Publishers.CombineLatest(yearlyManager.objectWillChange, monthlyManager.objectWillChange)
            .sink { _ in self.objectWillChange.send() }
            .store(in: &anyCancellable)
    }

    public func scrollToMonth(_ month: Date, animated: Bool = true) {
        monthlyManager.scrollToMonth(month, animated: animated)
    }

    public func scrollBackToToday(animated: Bool = true) {
        scrollToDay(Date(), animated: animated)
    }

    public func scrollToDay(_ day: Date, animated: Bool = true) {
        monthlyManager.scrollToDay(day, animated: animated)
    }

}

extension ElegantCalendarManager {

    // accounts for both when the user scrolls to the yearly calendar view and the
    // user presses the month text to scroll to the yearly calendar view
    func scrollToYearIfOnYearlyView(_ page: Int) {
        if page == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.yearlyManager.scrollToYear(self.currentMonth)
            }
        }
    }

}

extension ElegantCalendarManager: ElegantCalendarCommunicator {

    public func scrollToMonthAndShowMonthlyView(_ month: Date) {
        pagesManager.scroll(to: 1)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.scrollToMonth(month)
        }
    }

    public func showYearlyView() {
        pagesManager.scroll(to: 0)
    }

}

protocol ElegantCalendarDirectAccess {

    var parent: ElegantCalendarManager? { get }

}

extension ElegantCalendarDirectAccess {

    var datasource: ElegantCalendarDataSource? {
        parent?.datasource
    }

    var delegate: ElegantCalendarDelegate? {
        parent?.delegate
    }

}

private extension PageTurnType {

    static let calendarEarlySwipe: PageTurnType = .earlyCutoff(
        config: .init(scrollResistanceCutOff: 40,
                      pageTurnCutOff: 90,
                      pageTurnAnimation: .interactiveSpring(response: 0.35, dampingFraction: 0.86, blendDuration: 0.25)))

}
