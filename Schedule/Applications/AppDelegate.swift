//
//  AppDelegate.swift
//  Schedule
//
//  Created by Ignat Urbanovich on 18.12.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainController()
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
        
        
        return true
    }

    
    
}

extension Date {

    func isBefore(_ date: Date = Date()) -> Bool {

        let calendar = Calendar.current

        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let selfComponents = calendar.dateComponents([.year, .month, .day], from: self)

        return calendar.date(from: selfComponents)! < calendar.date(from: dateComponents)!
    }
    
    
    func isEqual(_ date: Date = Date()) -> Bool {

        let calendar = Calendar.current

        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let selfComponents = calendar.dateComponents([.year, .month, .day], from: self)

        return calendar.date(from: selfComponents)! == calendar.date(from: dateComponents)!
    }
}
