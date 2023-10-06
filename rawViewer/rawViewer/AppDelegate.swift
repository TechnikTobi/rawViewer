//
//  AppDelegate.swift
//  rawViewer
//
//  Created by Tobias Prisching on 04.10.23.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var cacheController = CacheController();
    
    @IBAction func menuFileOpen(_ sender: Any) {
        let viewController = NSApp.keyWindow?.contentViewController as! ViewController;
        viewController.fileController.openDirectory();
    }
    
    @IBAction func menuEditDelete(_ sender: Any) {
        let viewController = NSApp.keyWindow?.contentViewController as! ViewController;
        viewController.fileController.deleteCurrentFile();
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

