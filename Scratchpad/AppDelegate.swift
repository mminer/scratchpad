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

    private lazy var preferencesWindowController: NSWindowController? = self.storyboard.instantiateController(withIdentifier: .preferences) as? NSWindowController
    private lazy var scratchpadWindowController: NSWindowController? = self.storyboard.instantiateController(withIdentifier: .scratchpad) as? NSWindowController
    private lazy var storyboard = NSStoryboard(name: .main, bundle: nil)

    private var isScratchpadVisible: Bool {
        return scratchpadWindowController?.window?.isVisible ?? false
    }

    func applicationWillFinishLaunching(_ notification: Notification) {
        UserDefaults.standard.register(defaults: [
            DefaultsKey.showDockIcon.rawValue: NSControl.StateValue.on.rawValue,
            DefaultsKey.textSize.rawValue: TextSize.default.rawValue,
        ])

        UserDefaults.standard.addObserver(
            self,
            forKeyPath: DefaultsKey.showDockIcon.rawValue,
            options: [.initial, .new],
            context: nil
        )

        MASShortcutBinder.shared().bindShortcut(
            withDefaultsKey: DefaultsKey.shortcut.rawValue,
            toAction: toggleScratchpad
        )
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        let showDockIconValue = UserDefaults.standard.integer(forKey: DefaultsKey.showDockIcon.rawValue)
        let showDockIcon = NSControl.StateValue(rawValue: showDockIconValue)

        switch showDockIcon {
        case .off:
            openPreferences(self)
        case .on:
            showScratchpad()
        default:
            break
        }

        return true
    }

    func applicationWillTerminate(_ notification: Notification) {
        UserDefaults.standard.removeObserver(self, forKeyPath: DefaultsKey.showDockIcon.rawValue, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case DefaultsKey.showDockIcon.rawValue?:
            let showDockIcon: NSControl.StateValue = {
                guard let showDockIconValue = change?[.newKey] as? Int else {
                    return .on
                }

                return NSControl.StateValue(rawValue: showDockIconValue)
            }()

            switch showDockIcon {
            case .off:
                DockIcon.hide()
            case .on:
                DockIcon.show()
            default:
                break
            }

        default:
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
        if isScratchpadVisible {
            hideScratchpad()
        } else {
            showScratchpad()
        }
    }

    @IBAction func openPreferences(_ sender: AnyObject?) {
        guard let preferencesWindowController = preferencesWindowController else {
            return
        }

        if isScratchpadVisible {
            scratchpadWindowController?.close()
        }

        NSApp.activate(ignoringOtherApps: true)
        preferencesWindowController.showWindow(self)
        preferencesWindowController.window?.makeKeyAndOrderFront(self)
    }
}
