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

    private lazy var eventMonitor: EventMonitor = EventMonitor(
        mask: [.leftMouseDown, .rightMouseUp],
        handler: { _ in self.view.window?.close() }
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        textView.string = UserDefaults.standard.string(forKey: DefaultsKey.content.rawValue) ?? ""
        textView.textColor = NSColor.textColor

        UserDefaults.standard.addObserver(
            self,
            forKeyPath: DefaultsKey.textSize.rawValue,
            options: [.initial, .new],
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

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &textSizeContext {
            let rawValue = (change?[.newKey] as? String) ?? ""
            let textSize = TextSize(rawValue: rawValue) ?? .defaultSize
            setFont(forTextSize: textSize)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    deinit {
        UserDefaults.standard.removeObserver(
            self,
            forKeyPath: DefaultsKey.textSize.rawValue,
            context: &textSizeContext
        )
    }

    func hide(_ sender: AnyObject?) {
        view.window?.close()
    }

    func performClose(_ sender: AnyObject?) {
        view.window?.close()
    }

    private func setFont(forTextSize textSize: TextSize) {
        let fontSize: CGFloat

        switch textSize {
        case .small:
            fontSize = 13
        case .medium:
            fontSize = 16
        case .large:
            fontSize = 19
        }

        textView.font = NSFont.systemFont(ofSize: fontSize)
    }
}

extension ScratchpadViewController: NSTextViewDelegate {

    func textDidChange(_ notification: Notification) {
        UserDefaults.standard.set(textView.string ?? "", forKey: DefaultsKey.content.rawValue)
    }
}
