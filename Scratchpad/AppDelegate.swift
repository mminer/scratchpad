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

    private let statusItem = NSStatusBar.system().statusItem(withLength: -1)

    private lazy var statusMenu: NSMenu = {
        let menu = NSMenu()

        menu.addItem(
            withTitle: "Preferences…",
            action: #selector(openPreferences),
            keyEquivalent: ""
        )

        menu.addItem(
            withTitle: "Quit Scratchpad",
            action: #selector(NSApp.terminate(_:)),
            keyEquivalent: ""
        )

        return menu
    }()

    private lazy var preferencesWindowController: NSWindowController? = self.storyboard.instantiateController(withIdentifier: "preferences") as? NSWindowController
    private lazy var scratchpadWindowController: NSWindowController? = self.storyboard.instantiateController(withIdentifier: "scratchpad") as? NSWindowController
    private lazy var storyboard = NSStoryboard(name: "Main", bundle: nil)

    private var scratchpadVisible: Bool {
        return scratchpadWindowController?.window?.isVisible == true
    }

    func applicationWillFinishLaunching(_ aNotification: Notification) {
        UserDefaults.standard.register(defaults: [
            DefaultsKey.textSize.rawValue: TextSize.defaultSize.rawValue,
        ])

        MASShortcutBinder.shared().bindShortcut(
            withDefaultsKey: DefaultsKey.shortcut.rawValue,
            toAction: toggleScratchpad
        )
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.action = #selector(handleStatusItemClick(_:))
            button.image = NSImage(named: "StatusItemIcon")
            button.image?.isTemplate = true
            button.target = self

            // Support right clicking.
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }

    func handleStatusItemClick(_ sender: NSStatusBarButton) {
        guard let currentEvent = NSApp.currentEvent else {
            return
        }

        switch currentEvent.type {
        case .leftMouseUp where currentEvent.modifierFlags.contains(.control), .rightMouseUp:
            // TODO: replace this deprecated method with alternative
            statusItem.popUpMenu(statusMenu)

        case .leftMouseUp:
            toggleScratchpad()

        default:
            break
        }
    }

    private func hideScratchpad() {
        scratchpadWindowController?.close()
        NSApp.hide(self)
    }

    private func showScratchpad() {
        scratchpadWindowController?.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func toggleScratchpad() {
        if scratchpadVisible {
            hideScratchpad()
        } else {
            showScratchpad()
        }
    }

    @IBAction func openPreferences(_ sender: AnyObject?) {
        guard let preferencesWindowController = preferencesWindowController else {
            return
        }

        if scratchpadVisible {
            scratchpadWindowController?.close()
        }

        NSApp.activate(ignoringOtherApps: true)
        preferencesWindowController.showWindow(self)
        preferencesWindowController.window?.makeKeyAndOrderFront(self)
    }
}
