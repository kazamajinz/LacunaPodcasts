//
//  AppDelegate.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-06-28.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            
            let standard = UINavigationBarAppearance()
            standard.configureWithOpaqueBackground()
            standard.backgroundColor = UIColor.appColor(.midnight)
            standard.shadowColor = .clear
            standard.shadowImage = UIImage()
            
            standard.titleTextAttributes = [.foregroundColor: UIColor.white]
            standard.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            standard.titleTextAttributes = [.foregroundColor: UIColor.white]
            
            let plainButton = UIBarButtonItemAppearance(style: .plain)
            plainButton.normal.titleTextAttributes = [.foregroundColor: UIColor.appColor(.highlight) ?? UIColor.white]
            standard.buttonAppearance = plainButton
            
            let doneButton = UIBarButtonItemAppearance(style: .done)
            doneButton.normal.titleTextAttributes = [.foregroundColor: UIColor.appColor(.highlight) ?? UIColor.white]
            standard.doneButtonAppearance = doneButton
            
            UINavigationBar.appearance().standardAppearance = standard
            UINavigationBar.appearance().scrollEdgeAppearance = standard
            UINavigationBar.appearance().prefersLargeTitles = false
            UINavigationBar.appearance().tintColor = UIColor.appColor(.highlight)
            
        }
        
        // MARK: - SearchBar

        UISearchBar.appearance().tintColor = UIColor.appColor(.highlight)
        UISearchTextField.appearance().tintColor = UIColor.appColor(.highlight)
        UISearchTextField.appearance().keyboardAppearance = UIKeyboardAppearance.darkgi
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

