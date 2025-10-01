//
// NetworkingManagerMock.swift
// Blockfolio
//
// Created by Oleg Zakladnyi on 01.10.2025

import Foundation
import Combine

class NetworkingManagerMock: NetworkingManaging {
    static var testData: Data?
    static var shouldFail = false
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        if shouldFail {
            return Fail(error: URLError(.badServerResponse))
                .mapError { $0 as Error } // 🔑 приводимо до Error
                .eraseToAnyPublisher()
        }
        return Just(testData ?? Data())
            .setFailureType(to: Error.self) // 🔑 напряму Error
            .eraseToAnyPublisher()
    }
}
