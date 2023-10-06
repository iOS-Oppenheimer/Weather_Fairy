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
