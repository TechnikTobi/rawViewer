//
//  AppDelegate.swift
//  rawViewer
//
//  Created by Tobias Prisching on 04.10.23.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBAction func menuFileOpen(_ sender: NSMenuItem)
    {
        if let window = NSApp.keyWindow
        {
            
            
            
            /*
            if let controller = window.contentViewController
            {
                (window_controller.contentViewController as! ViewController).fileController.openFile();
            }
             */
            
        }
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

