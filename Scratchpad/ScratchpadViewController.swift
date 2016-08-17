//
//  ScratchpadViewController.swift
//  Scratchpad
//
//  Created by Matthew Miner on 2016-08-15.
//  Copyright © 2016 Matthew Miner. All rights reserved.
//

import Cocoa

class ScratchpadViewController: NSViewController {

    @IBOutlet var textView: NSTextView!

    private var textSizeContext = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.textColor = NSColor.textColor()

        NSUserDefaults.standardUserDefaults().addObserver(
            self,
            forKeyPath: DefaultsKeys.textSize.rawValue,
            options: [.Initial, .New],
            context: &textSizeContext
        )
    }

    deinit {
        NSUserDefaults.standardUserDefaults().removeObserver(
            self,
            forKeyPath: DefaultsKeys.textSize.rawValue,
            context: &textSizeContext
        )
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &textSizeContext {
            let rawValue = (change?[NSKeyValueChangeNewKey] as? String) ?? ""
            let textSize = TextSize(rawValue: rawValue) ?? TextSize.defaultSize
            setTextSize(textSize)
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }

    private func setTextSize(textSize: TextSize) {
        let fontSize: CGFloat

        switch textSize {
        case .small:
            fontSize = 13
        case .medium:
            fontSize = 16
        case .large:
            fontSize = 19
        }

        textView.font = NSFont.systemFontOfSize(fontSize)
    }
}
