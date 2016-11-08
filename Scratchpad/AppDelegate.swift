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

    private lazy var preferencesWindowController: NSWindowController? = self.storyboard.instantiateController(withIdentifier: "preferences") as? NSWindowController
    private lazy var scratchpadWindowController: NSWindowController? = self.storyboard.instantiateController(withIdentifier: "scratchpad") as? NSWindowController
    private lazy var storyboard = NSStoryboard(name: "Main", bundle: nil)

    private var scratchpadVisible: Bool {
        return scratchpadWindowController?.window?.isVisible == true
    }

    private var showDockIconContext = 0

    func applicationWillFinishLaunching(_ notification: Notification) {
        UserDefaults.standard.register(defaults: [
            DefaultsKey.showDockIcon.rawValue: NSOnState,
            DefaultsKey.textSize.rawValue: TextSize.defaultSize.rawValue,
        ])

        UserDefaults.standard.addObserver(
            self,
            forKeyPath: DefaultsKey.showDockIcon.rawValue,
            options: [.initial, .new],
            context: &showDockIconContext
        )

        MASShortcutBinder.shared().bindShortcut(
            withDefaultsKey: DefaultsKey.shortcut.rawValue,
            toAction: toggleScratchpad
        )
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        let showDockIcon = UserDefaults.standard.integer(forKey: DefaultsKey.showDockIcon.rawValue)

        switch showDockIcon {
        case NSOffState:
            openPreferences(self)
        case NSOnState:
            showScratchpad()
        default:
            break
        }

        return true
    }

    func applicationWillTerminate(_ notification: Notification) {
        UserDefaults.standard.removeObserver(
            self,
            forKeyPath: DefaultsKey.showDockIcon.rawValue,
            context: &showDockIconContext
        )
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if context == &showDockIconContext {
            let showDockIcon = (change?[.newKey] as? Int) ?? NSOnState

            switch showDockIcon {
            case NSOffState:
                DockIcon.hide()
            case NSOnState:
                DockIcon.show()
            default:
                break
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
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
