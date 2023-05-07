//
//  URLSessionHTTpClientTests.swift
//  EssentialFeedTests
//
//  Created by martin chibwe on 5/4/23.
//

import XCTest

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) {
        session.dataTask(with: url) { data, response, error in
            
        }
        .resume()
    }
}
final class URLSessionHTTpClientTests: XCTestCase {
    
    func test_getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "http: //any-url.com")
        let session = URLSessionSpy()
        
        let sut = URLSessionHTTPClient(session: session)
        
        guard (url != nil) else {
            return
        }
        sut.get(from: url!)
        
        XCTAssertEqual(session.receivedURLs, [url])
        
    }
    func test_getFromURL_resumeDataTaskWithURL() {
        let url = URL(string: "http://any-url.com") ?? URL(string: "http://default-url.com")!
           let session = URLSessionSpy()
           let task = URLSessionDataTaskSpy()
           let sut = URLSessionHTTPClient(session: session)
           session.stub(url: url, task: task)
           
           sut.get(from: url)
           
           XCTAssertEqual(task.resumeCallCount, 1)
        
    }
                                              
    private class URLSessionSpy: URLSession {
        var receivedURLs = [URL]()
        private var stubs = [URL: URLSessionDataTask]()
        
        func stub(url: URL, task: URLSessionDataTask) {
            stubs[url] = task
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            
            return stubs[url] ?? FakeURLSessionDataTask()
        }
   }
    private class FakeURLSessionDataTask: URLSessionDataTask {
        override func resume() {}
    }
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCallCount = 0
        
        override func resume() {
            resumeCallCount += 1
        }
    }
}
