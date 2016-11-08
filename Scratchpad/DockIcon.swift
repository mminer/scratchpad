//
//  DockIcon.swift
//  Scratchpad
//
//  Created by Matthew Miner on 2016-11-07.
//  Copyright © 2016 Matthew Miner. All rights reserved.
//

import Foundation

final class DockIcon {

    private static var processSerialNumber: ProcessSerialNumber {
        return ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
    }

    static func hide() {
        var psn = processSerialNumber

        TransformProcessType(
            &psn,
            ProcessApplicationTransformState(kProcessTransformToUIElementApplication)
        )
    }

    static func show() {
        var psn = processSerialNumber

        TransformProcessType(
            &psn,
            ProcessApplicationTransformState(kProcessTransformToForegroundApplication)
        )
    }
}
