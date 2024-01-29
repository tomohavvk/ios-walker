//
//  Injector.swift
//  walker
//
//  Created by IZ on 26.01.2024.
//

import Foundation
import UIKit

class Injector {
    
    init() {
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
    }
}
