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
    
    @Published var currentDirectory: URL? = nil;
    @Published var currentFile: URL? = nil;
    
    var currentDirectoryContents: [URL] = [];
    
    func openDirectory()
    {
        let openFilePanel = NSOpenPanel();
        
        // Configuring the open panel
        openFilePanel.canChooseDirectories    = true;
        openFilePanel.canChooseFiles          = true; // true;
        openFilePanel.allowsMultipleSelection = false;
        openFilePanel.styleMask               = .nonactivatingPanel;
        
        if openFilePanel.runModal() == .OK
        {
            if let newURL = openFilePanel.url
            {
                var is_directory: ObjCBool = false;
                
                // Checks if the URL points to something that exists and if it's a directory or not
                if !FileManager.default.fileExists(atPath: newURL.absoluteURL.path, isDirectory: &is_directory)
                {
                    return;
                }
                
                if !is_directory.boolValue
                {
                    self.currentDirectory = newURL.deletingPathExtension().deletingLastPathComponent();
                }
                else
                {
                    self.currentDirectory = newURL;
                }
                
                self.switchImage(next: true)
            }
            else
            {
                NSSound.beep()
                print("Could not get URL from open panel")
            }
        }
        else
        {
            NSSound.beep()
            print("openFilePanel is NOT OK")
        }
    }
    
    func scanDirectory()
    {
        if let scanResult = try? FileManager.default.contentsOfDirectory(atPath: (self.currentDirectory?.absoluteURL.path)!)
        {
            self.currentDirectoryContents.removeAll();
            
            for item in scanResult
            {
                let suffix = URL(fileURLWithPath: item).pathExtension;
                if suffix.lowercased() == "rw2" || suffix.lowercased() == "jpg"
                {
                    self.currentDirectoryContents.append(
                        URL(filePath: item, relativeTo: self.currentDirectory)
                    )
                }
            }
            
            self.currentDirectoryContents.sort(by:{ $0.absoluteString < $1.absoluteString })
        }
        else
        {
            NSSound.beep()
            print("Can't scan directory")
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
        self.scanDirectory();
        
        if let file = self.currentFile
        {
            if let currentIndex = self.currentDirectoryContents.firstIndex(of: file)
            {
                let newIndex = next ? min(currentIndex+1, self.currentDirectoryContents.count-1) : max(currentIndex-1, 0);
                
                // If the index changed, set the current file, otherwise do a beep and nothing else
                currentIndex != newIndex ? self.setCurrentFile(self.currentDirectoryContents[newIndex]) : NSSound.beep();
                
                // Nothing else to do in this case, so return
                return;
            }
        }
        
        // Either no current file or no current index, so just switch to the first image in the directory
        self.setCurrentFile(self.currentDirectoryContents.first);
    }
    
    // Sets the current file variable and notifies the observers
    func setCurrentFile(_ url: URL?)
    {
        self.currentFile = url;
        self.publisher.send();
    }
}
