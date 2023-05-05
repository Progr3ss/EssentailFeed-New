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
                                              
    private class URLSessionSpy: URLSession {
        var receivedURLs = [URL]()
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            return FakeURLSessionDataTask()
        }
   }
    private class FakeURLSessionDataTask: URLSessionDataTask {}
}
/**
 var mergedString = ""
   let minLength = min(word1.count, word2.count)
   
   for i in 0..<minLength {
       let index1 = word1.index(word1.startIndex, offsetBy: i)
       let index2 = word2.index(word2.startIndex, offsetBy: i)
       mergedString.append(word1[index1])
       mergedString.append(word2[index2])
   }
   
   if word1.count > minLength {
       mergedString += word1.suffix(from: word1.index(word1.startIndex, offsetBy: minLength))
   } else if word2.count > minLength {
       mergedString += word2.suffix(from: word2.index(word2.startIndex, offsetBy: minLength))
   }
   
   return mergedString
 
 */
