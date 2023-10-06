//
//  FileController.swift
//  rawViewer
//
//  Created by Tobias Prisching on 04.10.23.
//

import Foundation
import Cocoa

class FileController: NSObject
{
    var publisher = Publisher();
    
    @Published var currentDirectory: NSURL? = nil;
    @Published var currentFile: NSURL? = nil;
    
    var currentDirectoryContents: [NSURL] = [];
    
    func openDirectory()
    {
        let openFilePanel = NSOpenPanel();
        
        // Configuring the open panel
        openFilePanel.canChooseDirectories    = true;
        openFilePanel.canChooseFiles          = false; // true;
        openFilePanel.allowsMultipleSelection = false;
        openFilePanel.styleMask               = .nonactivatingPanel;
        
        if openFilePanel.runModal() == .OK
        {
            if let newURL = openFilePanel.url
            {
                var is_directory: ObjCBool = false;
                
                // Checks if the URL points to something that exists and if it's a directory or not
                if !FileManager.default.fileExists(atPath: newURL.path(), isDirectory: &is_directory)
                {
                    return;
                }
                
                if !is_directory.boolValue
                {
                    currentDirectory = NSURL(string: newURL.deletingPathExtension().deletingLastPathComponent().path + "/");
                }
                
                self.publisher.send();
            }
            else
            {
                NSSound.beep()
                print("Could not get URL from open panel")
            }
        }
    }
    
    func scanDirectory()
    {
        if let scanResult = try? FileManager.default.contentsOfDirectory(atPath: (self.currentDirectory?.path!)!)
        {
            currentDirectoryContents.removeAll();
            
            for item in scanResult
            {
                let suffix = URL(fileURLWithPath: item).pathExtension;
                if suffix.lowercased() == "rw2"
                {
                    
                }
            }
            
            currentDirectoryContents.sort(by:{ $0.absoluteString! > $1.absoluteString! })
        }
    }
    
    func next()
    {
        self.switchImage(next: true);
    }
    
    func prev()
    {
        self.switchImage(next: false);
    }
    
    func switchImage(next: Bool)
    {
        if let file = self.currentFile
        {
            if let currentIndex = currentDirectoryContents.firstIndex(of: file)
            {
                let newIndex = next ? min(currentIndex+1, currentDirectoryContents.count-1) : max(currentIndex-1, 0);
                
                if currentIndex != newIndex
                {
                    self.currentFile = currentDirectoryContents[newIndex];
                    self.publisher.send();
                    return;
                }
            }
        }
        
        NSSound.beep()
    }
}
