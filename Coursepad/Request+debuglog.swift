//
//  Request+debuglog.swift
//  Coursepad
//
//  Created by Metech3 on 6/5/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//


import Alamofire
extension Request {
    public func debugLog() -> Self {
        #if DEBUG
            debugPrint(self)
        #endif
        return self
    }
}
