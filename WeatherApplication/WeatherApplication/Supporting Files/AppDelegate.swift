//
//  AppDelegate.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/25/20.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let tintColor =  UIColor.lightGray
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        customizeAppearance()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    private func customizeAppearance() {
        window?.tintColor = tintColor
        UISearchBar.appearance().barTintColor = tintColor
        UINavigationBar.appearance().barTintColor = tintColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue):UIColor.white]
    }
}

