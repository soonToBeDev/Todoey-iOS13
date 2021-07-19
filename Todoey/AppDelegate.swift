//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
//Realm is used for single users, it stores all of the data locally on our device

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //        print(Realm.Configuration.defaultConfiguration.fileURL)
        //          This print statment locates our realm file on our MAC
        
        do {
            _ = try Realm()
        }
        catch {
            print("error occured \(error)")
        }
        
        // Lines 24 - 28 initialize realm as soon as the app launches and we have that wrapped in a {do try catch} block
        
        return true
    }
}
