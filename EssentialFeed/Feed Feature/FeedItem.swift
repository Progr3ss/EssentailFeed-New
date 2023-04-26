//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Martin Chibwe on 5/12/22.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL:URL
}
