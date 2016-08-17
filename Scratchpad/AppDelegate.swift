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

    private lazy var eventMonitor: EventMonitor = EventMonitor(
        mask: [.LeftMouseDownMask, .RightMouseUpMask],
        handler: { _ in self.hidePopover() }
    )

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
            button.action = #selector(togglePopover)
            button.image = NSImage(named: "StatusItemIcon")
            button.image?.template = true
            button.target = self
        }
    }

    func togglePopover() {
        if popover.shown {
            hidePopover()
        } else {
            showPopover()
        }
    }

    private func hidePopover() {
        popover.performClose(self)
        eventMonitor.stop()
    }

    private func showPopover() {
        guard let button = statusItem.button else {
            return
        }

        popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: .MinY)
        eventMonitor.start()
    }
}
