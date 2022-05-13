//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Martin Chibwe on 5/12/22.
//

import Foundation

class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL
    
    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.get(from: url)
    }
}

//enum LoadFeedResult {
//    case success([FeedItem])
//    case error(Error)
//}

protocol HTTPClient {
    func get(from url: URL)
}

//protocol FeedLoader {
//    func load(completion: @escaping (LoadFeedResult) -> Void)
//}
