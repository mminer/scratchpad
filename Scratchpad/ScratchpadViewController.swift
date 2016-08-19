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

    private let defaults = NSUserDefaults.standardUserDefaults()
    private var textSizeContext = 0

    private lazy var eventMonitor: EventMonitor = EventMonitor(
        mask: [.LeftMouseDownMask, .RightMouseUpMask],
        handler: { _ in self.view.window?.close() }
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        textView.string = defaults.stringForKey(DefaultsKeys.content.rawValue) ?? ""
        textView.textColor = NSColor.textColor()

        NSUserDefaults.standardUserDefaults().addObserver(
            self,
            forKeyPath: DefaultsKeys.textSize.rawValue,
            options: [.Initial, .New],
            context: &textSizeContext
        )
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        eventMonitor.start()
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        eventMonitor.stop()
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

    deinit {
        NSUserDefaults.standardUserDefaults().removeObserver(
            self,
            forKeyPath: DefaultsKeys.textSize.rawValue,
            context: &textSizeContext
        )
    }

    func hide(sender: AnyObject?) {
        view.window?.close()
    }

    func performClose(sender: AnyObject?) {
        view.window?.close()
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

extension ScratchpadViewController: NSTextViewDelegate {

    func textDidChange(notification: NSNotification) {
        defaults.setObject(textView.string ?? "", forKey: DefaultsKeys.content.rawValue)
    }
}
