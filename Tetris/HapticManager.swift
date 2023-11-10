//
//  HapticManager.swift
//  Tetris
//
//  Created by Out East on 03.11.2023.
//

import Foundation
import UIKit
import CoreHaptics

/// для акитивации различных вибраций и тактильных ощущений на устройстве
struct HapticManager {
    private static var engine: CHHapticEngine?
    private init() {
        
    }
    private static var isPrepared = false
    /// это функция подготовки класса к работе с haptic, которые были созданы пользоваетлем
    /// чтобы класс работал корректно, нужно запустить эту функцию в initial View Controller, чтобы
    /// класс настроил все, что ему нужно, до того, как пользователь сожет задействовать пользовательские haptic
    public static func prepare() {
        guard !self.isPrepared else {
            return
        }
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        do {
            HapticManager.engine = try CHHapticEngine()
            try HapticManager.engine?.start()
        } catch {
            print("ERROR - \(error.localizedDescription)")
        }
        
        HapticManager.engine?.stoppedHandler = { reason in
            print("ENGINE STOPPED - \(reason)")
            do {
                try HapticManager.engine?.start()
            } catch {
                print("FAILED TO RESTART - \(error.localizedDescription)")
            }
        }
        
        
        HapticManager.engine?.resetHandler = {
            print("Trying to reset")
            
            do {
                try HapticManager.engine?.start()
            } catch {
                print("FAILED TO RESTART - \(error.localizedDescription)")
            }
            
        }
        self.isPrepared = true
    }
    public static func loseHaptic() {
        DispatchQueue.main.async {
            // мы не должны проделывать дальнейшие действия, если устройство не может производить вибрации
            guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
                return
            }
            
            // описание вибрации
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
            
            // действие
            let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0.0, duration: 1.0)
            
            do {
                let pattern = try CHHapticPattern(events: [event], parameters: [])
                let player = try HapticManager.engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0.0)
            } catch {
                print("FAILED TO PLAY HAPTIC - \(error.localizedDescription)")
            }
        }
    }
    
    public static func winHaptic() {
        DispatchQueue.main.async {
            // мы не должны проделывать дальнейшие действия, если устройство не может производить вибрации
            guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
                return
            }
            
            // описание вибрации
            let startIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.65)
            let startSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
            
            // действие
            let startEvent = CHHapticEvent(eventType: .hapticContinuous, parameters: [startIntensity, startSharpness], relativeTime: 0.0, duration: 0.2)
            
            
            let endIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            let endSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
            
            let endEvent = CHHapticEvent(eventType: .hapticContinuous, parameters: [endIntensity, endSharpness], relativeTime: 0.22, duration: 0.75)
            
            
            do {
                let startPattern = try CHHapticPattern(events: [startEvent], parameters: [])
                let startPlayer = try HapticManager.engine?.makePlayer(with: startPattern)
                try startPlayer?.start(atTime: 0.0)
                
                let endPattern = try CHHapticPattern(events: [endEvent], parameters: [])
                let endPlayer = try HapticManager.engine?.makePlayer(with: endPattern)
                try endPlayer?.start(atTime: 0.0)
            } catch {
                print("FAILED TO PLAY HAPTIC - \(error.localizedDescription)")
            }
        }
    }
    
    // все вибрации должны проигрываться из главного потока
    /// обычно используется тогда, когда пользователь изменил какое-то значение в игре
    public static func selectionVibrate() {
        DispatchQueue.main.async {
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.prepare()
            selectionFeedbackGenerator.selectionChanged()
        }
    }
    /// обычно используется тогда, когда нужно пометить оповещение для полльзователя
    public static func notificationVibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
            notificationFeedbackGenerator.prepare()
            notificationFeedbackGenerator.notificationOccurred(type)
        }
    }
    /// обычно используется при физической симуляции(столкновении каких-либо объектов)
    /// или при нажатии на кнопку (я так буду делать)
    public static func collisionVibrate(with style: UIImpactFeedbackGenerator.FeedbackStyle,_ intensity: CGFloat) {
        DispatchQueue.main.async {
            let collisionFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
            collisionFeedbackGenerator.prepare()
            
            collisionFeedbackGenerator.impactOccurred(intensity: intensity)
        }
        
    }
}

