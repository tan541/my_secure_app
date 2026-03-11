//
//  MySecurityAppApp.swift
//  MySecurityApp
//
//  Created by nguyen thanh tan on 10/3/26.
//

import SwiftUI

@main
struct MySecurityAppApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // We use Settings instead of WindowGroup to prevent a blank window
        // from popping up on launch.
        Settings {
            EmptyView()
        }
    }
}
