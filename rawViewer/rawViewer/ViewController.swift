//
//  ViewController.swift
//  rawViewer
//
//  Created by Tobias Prisching on 04.10.23.
//

import Cocoa

class ViewController: NSViewController, Observer {
    
    @IBOutlet weak var imageView: NSImageView!
    
    var fileController = FileController();
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        // Set up to observe the file controller (e.g. new image needs to be displayed)
        self.fileController.publisher.insert(self);
        
        // Add a local function for additional key handling
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown, handler: keyDownEvent)
    }
    
    override var representedObject: Any? {
        didSet
        {
            // Update the view, if already loaded.
        }
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
            self.imageView.isEnabled = true;
            let image = (NSApplication.shared.delegate as! AppDelegate).cacheController.getImage(url: url);
            
            if image == nil
            {
                print("AHA!")
            }
            
            if (image!.isValid)
            {
                print("geil")
            }
            else
            {
                print("no?")
            }
            
            self.imageView.image = image
            print("huh?")
        }
        else
        {
            print("PANIC!")
        }
    }
}

