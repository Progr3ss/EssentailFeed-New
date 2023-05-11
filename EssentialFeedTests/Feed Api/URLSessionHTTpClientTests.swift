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
            }
        }.resume()
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_performsGETRequestWithURL() {
        URLProtocolSub.startInerceptionRequests()
        let url = URL(string: "http://any-url.com")!
        let exp = expectation(description: "Wait for request")
        
        URLProtocolSub.obsereveRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        URLSessionHTTPClient().get(from: url) { _ in }
        wait(for: [exp], timeout: 1.0)
        
        URLProtocolSub.stopInterceptingRequests()
    }
    
    func test_getFromURL_failsOnRequestError() {
        URLProtocolSub.startInerceptionRequests()
        let url = URL(string: "http://any-url.com") ?? URL(string: "http://default-url.com")!
        let sut = URLSessionHTTPClient()
        let error = NSError(domain: "any error", code: 1)
        URLProtocolSub.stub(data: nil, response: nil, error: error)
        
        let exp = expectation(description: "Wait for completion")
        
        sut.get(from: url) {result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError.domain, error.domain)
                XCTAssertEqual(receivedError.code, error.code)
            default:
                XCTFail("Expected failure with error \(error) , got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        URLProtocolSub.stopInterceptingRequests()
    }
    
    // MARK: - Helpers
    
    private class URLProtocolSub: URLProtocol {
        private static var stubs: Stub?
        private static var reqeustObserver:((URLRequest) -> Void)?
        
        private struct Stub {
            let error: Error?
            let data: Data?
            let response: URLResponse?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stubs = Stub(error: error, data: data, response: response)
        }
        
        static func obsereveRequests(observer: @escaping (URLRequest) -> Void) {
            reqeustObserver = observer
        }
        
        static func startInerceptionRequests() {
            URLProtocol.registerClass(URLProtocolSub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolSub.self)
            stubs = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            reqeustObserver?(request)
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let error = URLProtocolSub.stubs?.error {
                client?.urlProtocol(self, didFailWithError: error)
                return
            }
            
            if let data = URLProtocolSub.stubs?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolSub.stubs?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}
