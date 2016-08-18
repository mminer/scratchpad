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
        handler: { _ in self.hideScratchpad() }
    )

    private lazy var menu: NSMenu = {
        let menu = NSMenu()
        menu.addItemWithTitle("Preferences…", action: #selector(openPreferences), keyEquivalent: "")
        menu.addItemWithTitle("Quit Scratchpad", action: #selector(NSApp.terminate(_:)), keyEquivalent: "")
        return menu
    }()

    private lazy var preferencesWindowController: NSWindowController? = self.storyboard.instantiateControllerWithIdentifier("preferences") as? NSWindowController
    private lazy var scratchpadWindowController: NSWindowController? = self.storyboard.instantiateControllerWithIdentifier("scratchpad") as? NSWindowController
    private lazy var storyboard = NSStoryboard(name: "Main", bundle: nil)

    func applicationWillFinishLaunching(notification: NSNotification) {
        NSUserDefaults.standardUserDefaults().registerDefaults([
            DefaultsKeys.textSize.rawValue: TextSize.defaultSize.rawValue,
        ])

        MASShortcutBinder.sharedBinder().bindShortcutWithDefaultsKey(
            DefaultsKeys.shortcut.rawValue,
            toAction: toggleScratchpad
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
            toggleScratchpad()

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

    private func hideScratchpad() {
        eventMonitor.stop()
        scratchpadWindowController?.close()
        NSApp.hide(self)
    }

    private func showScratchpad() {
        eventMonitor.start()
        scratchpadWindowController?.showWindow(self)
        NSApp.activateIgnoringOtherApps(true)
    }

    private func toggleScratchpad() {
        if scratchpadWindowController?.window?.visible == true {
            hideScratchpad()
        } else {
            showScratchpad()
        }
    }
}
