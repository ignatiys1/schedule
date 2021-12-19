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
        
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainController()
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
        
        if lecturers.isEmpty {
            SetLecturersArray()
        }
        if groups.isEmpty {
            SetGroupsArray()
        }
        
        return true
    }

    
    
}
