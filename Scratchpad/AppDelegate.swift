//
//  AppDelegate.swift
//  Scratchpad
//
//  Created by Matthew Miner on 2016-08-15.
//  Copyright © 2016 Matthew Miner. All rights reserved.
//

import Cocoa
import MASShortcut

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)

    private lazy var eventMonitor: EventMonitor = EventMonitor(
        mask: [.LeftMouseDownMask, .RightMouseUpMask],
        handler: { _ in self.hidePopover() }
    )

    private lazy var menu: NSMenu = {
        let menu = NSMenu()
        menu.addItemWithTitle("Preferences…", action: #selector(openPreferences), keyEquivalent: "")
        menu.addItemWithTitle("Quit Scratchpad", action: #selector(NSApp.terminate(_:)), keyEquivalent: "")
        return menu
    }()

    private lazy var preferencesWindowController: NSWindowController? = {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateControllerWithIdentifier("preferences") as? NSWindowController
    }()

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

    func applicationWillFinishLaunching(notification: NSNotification) {
        NSUserDefaults.standardUserDefaults().registerDefaults([
            DefaultsKeys.textSize.rawValue: TextSize.defaultSize.rawValue,
        ])

        MASShortcutBinder.sharedBinder().bindShortcutWithDefaultsKey(
            DefaultsKeys.shortcut.rawValue,
            toAction: togglePopover
        )
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = statusItem.button {
            button.action = #selector(handleStatusItemClick(_:))
            button.image = NSImage(named: "StatusItemIcon")
            button.image?.template = true
            button.target = self

            // Support right clicking.
            let mask: NSEventMask = [.LeftMouseUpMask, .RightMouseUpMask]
            button.sendActionOn(Int(mask.rawValue))
        }
    }

    func handleStatusItemClick(sender: NSStatusBarButton) {
        guard let currentEvent = NSApp.currentEvent else {
            return
        }

        switch currentEvent.type {
        case .LeftMouseUp where currentEvent.modifierFlags.contains(.ControlKeyMask),
             .RightMouseUp:
            // TODO: replace this deprecated method with alternative
            statusItem.popUpStatusItemMenu(menu)

        case .LeftMouseUp:
            togglePopover()

        default:
            break
        }
    }

    func openPreferences() {
        guard let preferencesWindowController = preferencesWindowController else {
            return
        }

        preferencesWindowController.showWindow(self)
        preferencesWindowController.window?.makeKeyAndOrderFront(self)
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

    private func togglePopover() {
        if popover.shown {
            hidePopover()
        } else {
            showPopover()
        }
    }
}
