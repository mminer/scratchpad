//
//  ScratchpadViewController.swift
//  Scratchpad
//
//  Created by Matthew Miner on 2016-08-15.
//  Copyright © 2016 Matthew Miner. All rights reserved.
//

import AppKit

final class ScratchpadViewController: NSViewController {

    @IBOutlet var textView: NSTextView! {
        didSet {
            textView.delegate = self
            textView.string = UserDefaults.standard.string(forKey: DefaultsKey.content.rawValue) ?? ""
            textView.textColor = .textColor
        }
    }

    private let fontSizes: [TextSize: CGFloat] = [
        .small: 13,
        .medium: 16,
        .large: 19,
    ]

    private lazy var eventMonitor: EventMonitor = EventMonitor(
        mask: [.leftMouseDown, .rightMouseUp],
        handler: { [weak self] _ in self?.view.window?.close() }
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.addObserver(
            self,
            forKeyPath: DefaultsKey.textSize.rawValue,
            options: [.initial, .new],
            context: nil
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

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case DefaultsKey.textSize.rawValue?:
            let rawValue = (change?[.newKey] as? String) ?? ""
            let textSize = TextSize(rawValue: rawValue) ?? .default
            setFont(for: textSize)

        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: DefaultsKey.textSize.rawValue, context: nil)
    }

    func hide(_ sender: AnyObject?) {
        view.window?.close()
    }

    func performClose(_ sender: AnyObject?) {
        view.window?.close()
    }

    private func setFont(for textSize: TextSize) {
        guard let fontSize = fontSizes[textSize] else {
            return
        }

        textView.font = NSFont.systemFont(ofSize: fontSize)
    }
}

extension ScratchpadViewController: NSTextViewDelegate {

    func textDidChange(_ notification: Notification) {
        UserDefaults.standard.set(textView.string, forKey: DefaultsKey.content.rawValue)
    }
}
