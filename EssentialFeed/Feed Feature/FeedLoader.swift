//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Martin Chibwe on 5/12/22.
//

import Foundation

// RemoteFeedLoader is responsible for loading feed from remote server
public final class RemoteFeedLoader: FeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    // Possible errors that can occur while loading the feed
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult
    
    // Initialize new instance of RemoteFeedLoader
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    // Loads the feed from the remote server and calls the completion handler with the result.
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            // Guard against the possibility that the object has been deallocated.
            guard self != nil else {return}
            
            // Handle the result of the request
            switch result {
                
            case let .success(data, response):
                    completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

