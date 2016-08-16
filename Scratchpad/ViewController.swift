//
//  ViewController.swift
//  Scratchpad
//
//  Created by Matthew Miner on 2016-08-15.
//  Copyright © 2016 Matthew Miner. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var textView: NSTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.textColor = NSColor.textColor()
    }
}
