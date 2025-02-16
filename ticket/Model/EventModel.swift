//
//  EventModel.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/02/16.
//

import Foundation

struct EventModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let detail: String
}
