//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Martin Chibwe on 5/12/22.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL,completion: @escaping (Error) -> Void)
}

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) {error in }
        completion(.connectivity)
    }
}
