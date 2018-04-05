//
//  NavigationProtocols.swift
//  WingIt
//
//  Created by Eli Labes on 5/04/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

/*
    Used to ensure required data is provided to the controller when navigation to different pages.
    The protocols for different states align with required items in Navigation Service
 */

//MARK: Navigation Protocols
//==============================================================================

public protocol PLoginState {
    var isUpdatingMode: Bool! { get }
}

public protocol PDetailedClassView {
    var lessonData: Lesson! { get }
}
