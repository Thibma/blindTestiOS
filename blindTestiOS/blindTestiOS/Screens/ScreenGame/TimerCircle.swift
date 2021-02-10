//
//  Timer.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 04/02/2021.
//

import Foundation
import UIKit

class TimerCircle {
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    let timeTotal: Double
    var timeLeft: TimeInterval
    var endTime: Date?
    var timeLabel =  UILabel()
    var timer = Timer()

    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    let uiView = UIView()
    
    init(timeTotal: Double) {
        self.timeTotal = timeTotal
        self.timeLeft = timeTotal
        
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: -30, y: 30), radius:
            25, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        bgShapeLayer.strokeColor = UIColor(named: "Primary")?.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 5
        uiView.layer.addSublayer(bgShapeLayer)
    
        timeLabel = UILabel(frame: CGRect(x: uiView.frame.midX-80 ,y: uiView.frame.midY+5, width: 100, height: 50))
        timeLabel.textAlignment = .center
        timeLabel.text = timeLeft.time
        timeLabel.font = UIFont(name: "KGRedHands", size: 20)
        timeLabel.textColor = UIColor(named: "Primary")
        uiView.addSubview(timeLabel)
    }
    
    func startAnimation() {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: -30 , y: 30), radius:
            25, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        timeLeftShapeLayer.strokeColor = UIColor.systemGreen.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 5
        uiView.layer.addSublayer(timeLeftShapeLayer)
    }

    func removeView() {
        uiView.removeFromSuperview()
    }
    
    func startTimer() {
        startAnimation()
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
        strokeIt.duration = timeLeft
        timeLeftShapeLayer.add(strokeIt, forKey: nil)
        endTime = Date().addingTimeInterval(timeLeft)
    }
    
    func pauseTimer() {
        timer.invalidate()
        let pause = timeLeftShapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        timeLeftShapeLayer.speed = 0.0
        timeLeftShapeLayer.timeOffset = pause
    }
    
    func resumeTimer() {
        let pausedTime = timeLeftShapeLayer.timeOffset
        timeLeftShapeLayer.speed = 1.0
        timeLeftShapeLayer.timeOffset = 0.0
        timeLeftShapeLayer.beginTime = 0.0
        
        let timeSincePause = timeLeftShapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        timeLeftShapeLayer.beginTime = timeSincePause
        
        endTime = Date().addingTimeInterval(timeLeft)
    }
    
}

extension TimeInterval {
    var time: String {
        return String("\(Int(ceil(truncatingRemainder(dividingBy: 60))))")
    }
}
extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
