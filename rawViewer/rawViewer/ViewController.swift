//
//  ViewController.swift
//  rawViewer
//
//  Created by Tobias Prisching on 04.10.23.
//

import Cocoa

class ViewController: NSViewController
{
    var fileController = FileController();
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        print("viewDidLoad done");
    }

    override var representedObject: Any?
    {
        didSet
        {
            // Update the view, if already loaded.
        }
    }

}

    
