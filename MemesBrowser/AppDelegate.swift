//
//  AppDelegate.swift
//  MemesBrowser
//
//  Created by Tomasz Szulc on 30/03/2017.
//  Copyright © 2017 Tomasz Szulc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        configureMemesBackend()
        observeHTTPCodes()
        return true
    }
}

extension AppDelegate: WebServiceNotificationCenterDelegate {
    
    private func configureMemesBackend() {
        MemesBackend.shared = MemesBackend(defaults: NSUserDefaults())
        
        // Setup cache storage
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        let url = NSURL(fileURLWithPath: path).URLByAppendingPathComponent("CachedWebService-cache", isDirectory: true)!
        print("Cache stored in \(url).")
        CacheStorage.shared = CacheStorage(baseUrl: url)
    }
    
    private func observeHTTPCodes() {
        WebServiceNotificationCenter.shared.addObserver(self, code: 404)
        
        // You can listen e.g. for 401 and logout the user or whatever.
//        WebServiceNotificationCenter.shared.addObserver(self, code: 401)
    }
    
    func webServiceDidReceiveErrorCode(code: Int) {
        print("AppDelegate: WebService did receive HTTP \(code).")
    }
}

