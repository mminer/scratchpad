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
            showDockIconCheckbox.state = UserDefaults.standard.integer(
                forKey: DefaultsKey.showDockIcon.rawValue
            )
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
        return TextSize(rawValue: rawValue) ?? .defaultSize
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switch textSize {
        case .small:
            smallTextButton.state = NSOnState

        case .medium:
            mediumTextButton.state = NSOnState

        case .large:
            largeTextButton.state = NSOnState
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
        UserDefaults.standard.set(sender.state, forKey: DefaultsKey.showDockIcon.rawValue)
    }
}
