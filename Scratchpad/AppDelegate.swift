//
//  AppDelegate.swift
//  Scratchpad
//
//  Created by Matthew Miner on 2016-08-15.
//  Copyright © 2016 Matthew Miner. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)

    private lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.behavior = .Transient
        popover.contentViewController = self.popoverViewController
        return popover
    }()

    private lazy var popoverViewController: NSViewController? = {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateControllerWithIdentifier("scratchpad") as? NSViewController
    }()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = statusItem.button {
            button.action = #selector(toggleScratchpad)
            button.target = self

            let image = NSImage(named: "StatusItemIcon")
            image?.template = true
            button.image = image
        }
    }

    func toggleScratchpad() {
        guard let button = statusItem.button else {
            return
        }

        if popover.shown {
            popover.performClose(self)
        } else {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: .MinY)
        }
    }
}
