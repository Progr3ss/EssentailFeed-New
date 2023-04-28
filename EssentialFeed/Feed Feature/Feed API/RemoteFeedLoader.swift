//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by martin chibwe on 4/27/23.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

//extension LoadFeedResult: Equatable where Error: Equatable{}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
