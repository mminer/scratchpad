//
//  PreferencesViewController.swift
//  Scratchpad
//
//  Created by Matthew Miner on 2016-08-16.
//  Copyright © 2016 Matthew Miner. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    @IBOutlet weak var smallTextButton: NSButton!
    @IBOutlet weak var mediumTextButton: NSButton!
    @IBOutlet weak var largeTextButton: NSButton!

    private var textSize: TextSize {
        let rawValue = NSUserDefaults.standardUserDefaults().stringForKey(DefaultsKeys.textSize.rawValue) ?? ""
        return TextSize(rawValue: rawValue) ?? TextSize.defaultSize
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
    
    @IBAction func chooseTextSize(sender: NSButton) {
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

        NSUserDefaults.standardUserDefaults().setValue(
            textSize.rawValue,
            forKey: DefaultsKeys.textSize.rawValue
        )
    }
}
