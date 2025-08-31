//
//  DeviceIDManager.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/02/17.
//

import Foundation
import UIKit

class DeviceIDManager {
    // UDIDを取得
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
}
