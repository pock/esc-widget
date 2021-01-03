//
//  EscWidget.swift
//  Esc
//
//  Created by Pierluigi Galdi on 06/01/2020.
//  Copyright © 2020 Pierluigi Galdi. All rights reserved.
//

import Foundation
import AppKit
import PockKit
        				
/// Make sure to include `PockKit` in your Podfile and run `pod install`
				        
class EscWidget: PKWidget {
    var identifier: NSTouchBarItem.Identifier = NSTouchBarItem.Identifier(rawValue: "EscWidget")
    var customizationLabel: String = "Esc"
    var view: NSView!

    private let key: KeySender = KeySender(keyCode: Int32(0x35), isAux: false)
    
    required init() {
        self.view = PKButton(title: "esc", maxWidth: 64, target: self, action: #selector(tap))
    }
    
    @objc private func tap() {
        key.send()
    }
        
}

extension EscWidget: PKScreenEdgeMouseDelegate {
	
	private var button: PKButton {
		return view as! PKButton
	}
	
	private func shouldHighlight(for location: NSPoint, in view: NSView) -> Bool {
		return button.convert(button.bounds, to: view).contains(location)
	}
	
	func screenEdgeController(_ controller: PKScreenEdgeController, mouseEnteredAtLocation location: NSPoint, in view: NSView) {
		button.isHighlighted = shouldHighlight(for: location, in: view)
	}
	
	func screenEdgeController(_ controller: PKScreenEdgeController, mouseMovedAtLocation location: NSPoint, in view: NSView) {
		button.isHighlighted = shouldHighlight(for: location, in: view)
	}
	
	func screenEdgeController(_ controller: PKScreenEdgeController, mouseClickAtLocation location: NSPoint, in view: NSView) {
		button.isHighlighted = shouldHighlight(for: location, in: view)
		if button.isHighlighted {
			tap()
		}
	}
	
	func screenEdgeController(_ controller: PKScreenEdgeController, mouseExitedAtLocation location: NSPoint, in view: NSView) {
		button.isHighlighted = false
	}
	
}
