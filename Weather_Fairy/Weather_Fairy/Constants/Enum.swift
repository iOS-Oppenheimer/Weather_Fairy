//
//  ErrorHandling.swift
//  Weather_Fairy
//
//  Created by t2023-m0050 on 2023/09/27.
//

import Foundation

enum Result<Success, Failure: Error> {
     case success(Success)
     case failure(Failure)
 }

 enum APIError: Error {
     case invalidResponse
     case noCityName
     case noData
     case invalidJSON
     case failedRequest
     case invalidData
     case failedResponse
 }
