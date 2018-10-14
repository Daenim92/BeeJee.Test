//
//  AppDelegate.swift
//  BeeJee
//
//  Created by Daenim on 10/14/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import PluggableApplicationDelegate

@UIApplicationMain
class AppDelegate: PluggableApplicationDelegate {

    override var services: [ApplicationService] {
        return [
            CoreDataManager.shared
        ]
    }

}

