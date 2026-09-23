//  Thanks: https://github.com/brianmichel/ESCapey
//
//  ESCKeySender.swift
//  ESCapey-macOS
//
//  Created by Brian Michel on 10/25/16.
//  Copyright © 2016 Brian Michel. All rights reserved.
//
import Foundation
import ApplicationServices

protocol KeySenderProtocol {
    var keyCode: Int32  { get }
    var isAux:   Bool   { get }
    func send()
    func press()
    func release()
}

struct KeySender: KeySenderProtocol {
    let keyCode: Int32
    let isAux:   Bool
    init(keyCode: Int32, isAux: Bool) {
        self.keyCode = keyCode
        self.isAux   = isAux
    }
    func send() {
        KeySender.checkAccessibilityPermission()
        self.press()
        self.release()
    }
    func press() {
        KeySenderPress(UInt16(keyCode), isAux)
    }
    func release() {
        KeySenderRelease(UInt16(keyCode), isAux)
    }
}

extension KeySender {
    /// Posting key events through IOHIDPostEvent is silently dropped by macOS
    /// if Pock is not trusted for Accessibility (System Settings > Privacy & Security > Accessibility).
    /// Ask the user (once per launch) to grant it instead of failing without any feedback.
    private static var didPromptForAccessibility: Bool = false
    /// `AXIsProcessTrusted()` is a synchronous TCC query: once trusted, don't ask again on every key press.
    private static var isProcessTrusted: Bool = false
    static func checkAccessibilityPermission() {
        guard isProcessTrusted == false else {
            return
        }
        isProcessTrusted = AXIsProcessTrusted()
        guard isProcessTrusted == false, didPromptForAccessibility == false else {
            return
        }
        didPromptForAccessibility = true
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        AXIsProcessTrustedWithOptions(options)
    }
}
