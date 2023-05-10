//
//  URLSessionHTTpClientTests.swift
//  EssentialFeedTests
//
//  Created by martin chibwe on 5/4/23.
//

import XCTest
import EssentialFeed

import XCTest
import EssentialFeed


class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping(HTTPClientResult) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let httpResponse = response as? HTTPURLResponse {
                completion(.success(data ?? Data(), httpResponse))
            } 
        }.resume()
    }
}


final class URLSessionHTTpClientTests: XCTestCase {
    
    func test_getFromURL_failsOnRequestError() {
        URLProtocol.registerClass(URLProtocolSub.self)
        let url = URL(string: "http://any-url.com") ?? URL(string: "http://default-url.com")!
//        let task = URLSessionDataTaskSpy()
        let sut = URLSessionHTTPClient()
        let error = NSError(domain: "any error", code: 1)
        URLProtocolSub.stub(url: url, error: error)
        
        let exp = expectation(description: "Wait for completion")
        
        sut.get(from: url) {result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("Expected failure with error \(error) , got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        URLProtocol.unregisterClass(URLProtocolSub.self)
    }
    
    // MARK: - Helpers
    private class URLProtocolSub: URLProtocol{
        private static var stubs = [URL: Stub]()
        
        private struct Stub {
            let error: Error?
        }
        
        static func stub(url: URL, error: Error? = nil) {
            stubs[url] = Stub(error: error)
        }
        
        
        override class func canInit(with request: URLRequest) -> Bool {
            guard let url = request.url else { return false}
            
            return URLProtocolSub.stubs[url] != nil
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            guard let url = request.url, let stub = URLProtocolSub.stubs[url] else { return }
            
            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
        
    }
}
