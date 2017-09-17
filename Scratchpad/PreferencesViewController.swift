//
//  PreferencesViewController.swift
//  Scratchpad
//
//  Created by Matthew Miner on 2016-08-16.
//  Copyright © 2016 Matthew Miner. All rights reserved.
//

import AppKit
import MASShortcut

final class PreferencesViewController: NSViewController {

    @IBOutlet weak var showDockIconCheckbox: NSButton! {
        didSet {
            let showDockIconValue = UserDefaults.standard.integer(forKey: DefaultsKey.showDockIcon.rawValue)
            showDockIconCheckbox.state = NSControl.StateValue(rawValue: showDockIconValue)
        }
    }

    @IBOutlet weak var shortcutView: MASShortcutView! {
        didSet {
            shortcutView.associatedUserDefaultsKey = DefaultsKey.shortcut.rawValue
        }
    }

    @IBOutlet weak var largeTextButton: NSButton!
    @IBOutlet weak var mediumTextButton: NSButton!
    @IBOutlet weak var smallTextButton: NSButton!

    private var textSize: TextSize {
        let rawValue = UserDefaults.standard.string(forKey: DefaultsKey.textSize.rawValue) ?? ""
        return TextSize(rawValue: rawValue) ?? .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switch textSize {
        case .small:
            smallTextButton.state = .on

        case .medium:
            mediumTextButton.state = .on

        case .large:
            largeTextButton.state = .on
        }
    }

    @IBAction func chooseTextSize(_ sender: NSButton) {
        let newTextSize: TextSize

        switch sender {
        case smallTextButton:
            newTextSize = .small

        case mediumTextButton:
            newTextSize = .medium

        case largeTextButton:
            newTextSize = .large

        default:
            fatalError("Unrecognized button choosing text size.")
        }

        UserDefaults.standard.set(newTextSize.rawValue, forKey: DefaultsKey.textSize.rawValue)
    }

    @IBAction func toggleShowDockIcon(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state.rawValue, forKey: DefaultsKey.showDockIcon.rawValue)
    }
}
