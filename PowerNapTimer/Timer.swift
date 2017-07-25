//
//  Timer.swift
//  PowerNapTimer
//
//  Created by James Pacheco on 4/12/16.
//  Copyright © 2016 James Pacheco. All rights reserved.
//

import UIKit

protocol TimerDelegate: class {
    func timerSecondTick()
    func timerCompleted()
    func timerStopped()
}

class MyTimer: NSObject {
    
    var timeRemaining: TimeInterval?
    var timer: Timer?
    
    var isOn: Bool {
        if timeRemaining != nil {
            return true
        } else {
            return false
        }
    }
    
    weak var delegate: TimerDelegate?
    
    func timeAsString() -> String {
        let timeRemaining = Int(self.timeRemaining ?? 20*60)
        let minutesLeft = timeRemaining / 60
        let secondsLeft = timeRemaining - (minutesLeft*60)
        return String(format: "%02d : %02d", arguments: [minutesLeft, secondsLeft])
    }

    fileprivate func secondTick() {
        guard let timeRemaining = timeRemaining else {return}
        if timeRemaining > 0 {
            self.timeRemaining = timeRemaining - 1
            delegate?.timerSecondTick()
            print(timeRemaining)
        } else {
            timer?.invalidate()
            delegate?.timerCompleted()
            self.timeRemaining = nil
        }
    }
    
    func startTimer(_ time: TimeInterval) {
        if !isOn {
            timeRemaining = time
            self.secondTick()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                self.secondTick()
            })
        }
    }
    
    func stopTimer() {
        if isOn {
            delegate?.timerStopped()
            // FIXME: - Why can't I just set this to nil here?
            timer?.invalidate()
            timeRemaining = nil
        }
    }
}
