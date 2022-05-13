//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Martin Chibwe on 5/12/22.
//

import XCTest

class RemoteFeedLoader {
    
}
class HTTPClient {
    var requestedURL: URL?
}
class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        let sut = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }

}
