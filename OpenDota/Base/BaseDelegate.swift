//
//  BaseDelegate.swift
//  OpenDota
//
//  Created by docotel on 24/09/20.
//  Copyright © 2020 Affandy Murad. All rights reserved.
//

import Foundation
import UIKit

protocol BaseDelegate {
    func taskDidBegin()
    func taskDidFinish()
    func taskDidError(txt: String)
}

extension BaseDelegate {
    func taskDidBegin(){}
    func taskDidFinish(){}
    func taskDidError(txt: String){}
}
