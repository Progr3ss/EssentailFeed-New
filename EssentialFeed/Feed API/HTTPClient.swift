//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by martin chibwe on 4/27/23.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL,completion: @escaping (HTTPClientResult) -> Void)
}
