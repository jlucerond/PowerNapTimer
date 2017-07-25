//
//  ViewController.swift
//  PowerNapTimer
//
//  Created by James Pacheco on 4/12/16.
//  Copyright © 2016 James Pacheco. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    fileprivate let userNotificationIdentifier = "timerNotification"
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    let myTimer = MyTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTimer.delegate = self
        setView()
    }
    
    func setView() {
        updateTimerLabel()
        // If timer is running, start button title should say "Cancel". If timer is not running, title should say "Start nap"
        if myTimer.isOn {
            startButton.setTitle("Cancel", for: UIControlState())
        } else {
            startButton.setTitle("Start nap", for: UIControlState())
        }
    }
    
    func updateTimerLabel() {
        timerLabel.text = myTimer.timeAsString()
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if myTimer.isOn {
            myTimer.stopTimer()
            cancelLocalNotification()
        } else {
            myTimer.startTimer(5)
            scheduleLocalNotification()
        }
        setView()
    }
}

// MARK: - Timer Delegate Protocol Methods
extension ViewController: TimerDelegate {
    func timerSecondTick() {
        updateTimerLabel()
    }
    
    func timerCompleted() {
        setView()
        createAnAlert()
    }
    
    func timerStopped() {
        cancelLocalNotification()
        setView()
    }
}

// MARK: - UIAlertController Methods
extension ViewController {
    func createAnAlert() {
        let alert = UIAlertController(title: "Wake up",
                                      message: "Get outta bed",
                                      preferredStyle: .alert)
        
        alert.addTextField{ (textField) in
            textField.placeholder = "Snooze for a few more minutes..."
            textField.keyboardType = .numberPad
        }
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel){ (_) in
            print("timer dismissed")}
        
        let defaultAction = UIAlertAction(title: "Snooze", style: .default){ (_) in
            guard let timeText = alert.textFields?.first?.text,
                let time = TimeInterval(timeText) else { return }
            
            self.myTimer.startTimer(time)
            self.setView()
            
            print("snooze hit")
            
        }
        
        alert.addAction(dismissAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UserNotifications
extension ViewController {
    func scheduleLocalNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Wake up!"
        notificationContent.body = "Time to get up"
        
        guard let timeRemaining = myTimer.timeRemaining else { return }
        let fireDate = Date(timeInterval: timeRemaining, since: Date())
        
        let dateComponents = Calendar.current.dateComponents([.minute, .day], from: fireDate)
        
        let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: userNotificationIdentifier, content: notificationContent, trigger: dateTrigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to add notification request. \(error.localizedDescription)")
            }
        }
    }
    
    func cancelLocalNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [userNotificationIdentifier])
    }
}
