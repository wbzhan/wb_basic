//
//  CountdownManager.swift
//  MarkerMall
//
//  Created by Mac on 18.6.20.
//倒计时

import UIKit
import RxCocoa
import RxSwift
public class CountdownManager {
    
    let disposed = DisposeBag()
    let countDownRelay = PublishRelay<String>()
    let snpcountdownRelay = PublishRelay<Array<Int>>()
    var secondStr : Int!
    var minuteStr : Int!
    var hourStr : Int!
    var dayStr : Int!
    var timer : Timer!
    
    var snpHour = 0
    var snpMinute = 0
    var snpSecond = 0
    var snpTimer: Timer!//限时抢购倒计时
    var callBack: CallBackClosure!
    
    static let sharedInstance = CountdownManager()
    private init() {
        
    }
    
    /// rx-swift倒计时
    /// - Parameters:
    ///   - second: 倒计时的秒数
    ///   - immediately: 是否立即开始，true 时将立即开始倒计时，false 时将在 1 秒之后开始倒计时
    ///   - duration: 倒计时的过程
    /// - Returns: 倒计时结束时的通知
    public func countDown(second: Int,
                   immediately: Bool = true,
                   duration: ((Int) -> Void)?) -> Single<Void> {
        guard second > 0 else {
            return Single<Void>.just(())
        }

        if immediately {
            duration?(second)
        }
        return Observable<Int>
            .interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map { second - (immediately ? ($0 + 1) : $0) }
            .take(second + (immediately ? 0 : 1))
            .do(onNext: { (index) in
                duration?(index)
            })
            .filter { return $0 == 0 }
            .map { _ in return () }
            .asSingle()
     }
    
    //通过倒计时获取秒数
    public func countDown(seconds: Int){
        
        if seconds <= 0{
            if timer != nil {
                timer.invalidate()
                timer = nil
            }
            self.countDownRelay.accept((""))
            return
        }
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        let nowDate = Date.init(timeIntervalSinceNow: 0)
        let fuDate = Date.init(timeIntervalSinceNow: TimeInterval(seconds))
        
        let calendar = Calendar.current
        let unit:Set<Calendar.Component> = [.day,.hour,.minute,.second,.nanosecond]
        let component:DateComponents = calendar.dateComponents(unit, from: nowDate , to:fuDate)
        
//        nanosecondStr = component.nanosecond
        secondStr = component.second
        minuteStr = component.minute
        hourStr = component.hour
        dayStr = component.day
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let str = self.timeAction()
            self.countDownRelay.accept((str))
        }
        RunLoop.main.add(self.timer!, forMode: .tracking)
    }
    ///倒计时
    public func timeAction()->String{
            secondStr = secondStr-1
            if secondStr == -1{
                secondStr = 59
                minuteStr = minuteStr - 1
                if minuteStr == -1 {
                    minuteStr = 59
                    hourStr = hourStr - 1
                    if hourStr == -1 {
                        hourStr = 23
                        dayStr = dayStr - 1
                    }
                }
            }
//        }
        
        if  secondStr == 0 && minuteStr == 0 && hourStr == 0 && dayStr == 0 {

            timer.invalidate()
            timer = nil
            return ""
        }
        
        let dateStr = String(format: "%02d:%02d:%02d", hourStr ?? 0,minuteStr ?? 0,secondStr ?? 0)
        return "剩余\(dayStr ?? 0)天\(dateStr)"
    }
    

    
    public func snppedTimeAction(){
        snpSecond -= 1
        if snpSecond == -1 {
            snpSecond = 59
            snpMinute -= 1
            if snpMinute == -1 {
                snpMinute = 59
                snpHour -= 1
                if snpHour == -1 {
                    snpHour = 23
                }
            }
        }
        
        if snpSecond == 0 , snpMinute == 0 , snpHour == 0  {
            //倒计时清0，则重新倒计时
             NotificationCenter.default.post(name: .init(rawValue:"reloadSnappedData"), object: nil)
            snpTimer.invalidate()
            snpTimer = nil
        }
    }
}
