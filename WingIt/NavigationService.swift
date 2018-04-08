//
//  NavigationService.swift
//  WingIt
//
//  Created by Eli Labes on 5/04/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

import Foundation

public class NavigationService {
    
    private static let STORYBOARD: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    public static func displayLogin(isUpdatingMode: Bool = false) -> UIViewController {
        let vc: LoginViewController = self.STORYBOARD.instantiateViewController(withIdentifier: AppStates.LOGIN_STATE) as! LoginViewController
        vc.isUpdatingMode = isUpdatingMode
        return vc
    }
    
    public static func displayDetailedClassView(lessonData: Lesson!) -> UIViewController {
        let vc: DetailView = self.STORYBOARD.instantiateViewController(withIdentifier: AppStates.DETAIL_CLASS_VIEW) as! DetailView
        vc.lessonData = lessonData
        return vc
    }
}


