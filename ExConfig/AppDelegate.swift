//
//  AppDelegate.swift
//  ExConfig
//
//  Created by 김종권 on 2023/04/09.
//

import UIKit
import FirebaseCore
import FirebaseRemoteConfig

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase 연동
        FirebaseApp.configure()
        
        // singleton을 얻어서 세팅
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        
        // fetchInterval 설정: https://firebase.google.com/docs/remote-config/get-started?platform=ios&hl=ko#throttling
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        // remote config를 가져올 수 없을때 사용
        let defaultValue = ["MyKey": "this is defualt value"]
        remoteConfig.setDefaults(defaultValue as [String : NSObject])
        
        // 1. fetch (firebase 캐싱 - activate 메소드에서 changed 값을 내려줄수 있는 원리)
        remoteConfig.fetch() { (status, error) -> Void in
            if status == .success {
                
                // 2. activate (컨피그 값 가져오기)
                remoteConfig.activate() { (changed, error) in
                    print(changed, error)
                    let resultValue = remoteConfig["MyKey"].stringValue
                    print("resultValue=", resultValue)
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
        
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
