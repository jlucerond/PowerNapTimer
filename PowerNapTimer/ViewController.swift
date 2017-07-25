//
//  ViewController.swift
//  PowerNapTimer
//
//  Created by James Pacheco on 4/12/16.
//  Copyright © 2016 James Pacheco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    let myTimer = MyTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTimer.delegate = self
        setView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createAnAlert()
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
        } else {
            myTimer.startTimer(20*60.0)
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
        setView()
    }
}

// MARK: - UIAlertController Methods
extension ViewController {
    func createAnAlert() {
        let alert = UIAlertController(title: "Wake up",
                                      message: "Get outta bed",
                                      preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Cancel",
                                          style: .cancel){ (_) in
                                            print("hit cancel")}
        
        let destructiveAction = UIAlertAction(title: "Destructive",
                                              style: .destructive){ (_) in
                                                print("hit destructive")}
        
        let defaultAction = UIAlertAction(title: "Default",
                                          style: .default){ (_) in
                                            print("hit default")}
        
        alert.addAction(dismissAction)
        alert.addAction(destructiveAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
}

