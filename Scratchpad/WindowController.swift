//
//  WindowController.swift
//  Scratchpad
//
//  Created by Matthew Miner on 2016-08-17.
//  Copyright © 2016 Matthew Miner. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()

        guard let window = window else {
            fatalError("Window expected to be non-nil by this time.")
        }

        window.titleVisibility = .Hidden
        window.titlebarAppearsTransparent = true
    }
}
