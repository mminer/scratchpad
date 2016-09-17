//
//  PreferencesViewController.swift
//  Scratchpad
//
//  Created by Matthew Miner on 2016-08-16.
//  Copyright © 2016 Matthew Miner. All rights reserved.
//

import Cocoa
import MASShortcut

class PreferencesViewController: NSViewController {

    @IBOutlet weak var shortcutView: MASShortcutView!

    @IBOutlet weak var largeTextButton: NSButton!
    @IBOutlet weak var mediumTextButton: NSButton!
    @IBOutlet weak var smallTextButton: NSButton!

    private var textSize: TextSize {
        let rawValue = UserDefaults.standard.string(forKey: DefaultsKey.textSize.rawValue) ?? ""
        return TextSize(rawValue: rawValue) ?? .defaultSize
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        shortcutView.associatedUserDefaultsKey = DefaultsKey.shortcut.rawValue

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
        let textSize: TextSize

        switch sender {
        case smallTextButton:
            textSize = .small

        case mediumTextButton:
            textSize = .medium

        case largeTextButton:
            textSize = .large

        default:
            fatalError("Unrecognized button choosing text size.")
        }

        UserDefaults.standard.set(textSize.rawValue, forKey: DefaultsKey.textSize.rawValue)
    }
}
