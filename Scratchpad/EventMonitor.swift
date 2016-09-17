//
//  EventMonitor.swift
//  Scratchpad
//
//  Created by Matthew Miner on 2016-08-16.
//  Copyright © 2016 Matthew Miner. All rights reserved.
//

import Cocoa

class EventMonitor {

    private let handler: (NSEvent) -> Void
    private let mask: NSEventMask
    private var monitor: Any?

    init(mask: NSEventMask, handler: @escaping (NSEvent) -> Void) {
        self.handler = handler
        self.mask = mask
    }

    deinit {
        stop()
    }

    func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }

    func stop() {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }

        monitor = nil
    }
}
