//
//  AppDelegate.swift
//  WxArticle
//
//  Created by tutujiaw on 15/11/16.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isFinished = false

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        WXApi.registerApp("wx1013aed50e437b80")
        
        NSThread.detachNewThreadSelector("runOnNewThread", toTarget: self, withObject: nil)
        while !isFinished {
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
        }
        return true
    }
    
    func runOnNewThread() {
        let curId = max(NSUserDefaults.standardUserDefaults().integerForKey("curId"), 0)
        let request = GoodArticleRequest(typeId: curId, key: "", page: 1)
        Alamofire.request(.GET, request.url).responseJSON {
            response in
            if response.result.isSuccess {
                if let value = response.result.value {
                    Data.sharedManager.goodArticle.setData(value)
                }
            }
            self.performSelectorOnMainThread("onFinished", withObject: nil, waitUntilDone: false)
        }
    }

    func onFinished() {
        isFinished = true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

