//
//  ViewController.swift
//  rawViewer
//
//  Created by Tobias Prisching on 04.10.23.
//

import Cocoa

class ViewController: NSViewController, Observer {
    
    // UI Variables
    @IBOutlet weak var imageView: NSImageView!
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    
    // Internal variables
    var fileController = FileController();
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        // Set up to observe the file controller (e.g. new image needs to be displayed)
        self.fileController.publisher.insert(self);
        
        // Add a local function for additional key handling
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown, handler: keyDownEvent)
    }
    
    override var representedObject: Any?
    {
        didSet { /* Update the view, if already loaded. */ }
    }
    
    // Above mentioned local function for key handling
    func keyDownEvent(event: NSEvent) -> NSEvent?
    {
        print(event.keyCode)
        if
            (event.keyCode == 123 || event.keyCode == 126) // Pfeil nach links/oben
        {
            self.fileController.prev();
        }
        else if
            (event.keyCode == 124 || event.keyCode == 125) // Pfeil nach rechts/unten
        {
            self.fileController.next();
        }
        else
        {
            return event
        }
        
        return nil;
    }
    
    func observerUpdate()
    {
        if let url = self.fileController.currentFile
        {
            print("hm")
            Task
            {
                self.imageView.image = await (NSApplication.shared.delegate as! AppDelegate).cacheController.getImage(url: url);
                self.progressIndicator.isHidden = true;
                self.progressIndicator.stopAnimation(nil);
            }
            
            self.imageView.window?.title = url.lastPathComponent;
            self.progressIndicator.isHidden = false;
            self.progressIndicator.startAnimation(nil);
        }
        else
        {
            print("PANIC")
        }
    }
}

