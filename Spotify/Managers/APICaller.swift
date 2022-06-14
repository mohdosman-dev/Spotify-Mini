//
//  APICaller.swift
//  Spotify
//
//  Created by MAC on 14/06/2022.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

final class APICaller {
    public static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    enum APIError: Error {
        case failedToGetData
    }
    
    /// Get profile to current logged in user
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile,Error>) -> Void) {
        self.createBaseRequest(with: URL(string: "\(Constants.baseAPIURL)/me"),
                               type: .GET,
                               completion: {baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest, completionHandler: {data, _, error in
                guard let data = data, error == nil else {
                    print("Cannot send request: \(String(describing: error?.localizedDescription))")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result =  try UserProfile.init(data: data)
                    print(result)
                    completion(.success(result))
                } catch {
                    print("Cannot pars data: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            })
            task.resume()
        })
    }
    
    /// Get new releases
    public func getNewReleases(completion: @escaping ((Result<String, Error>) -> Void)) {
        createBaseRequest(with: URL(string: "\(Constants.baseAPIURL)/browse/new-releases?limit=5"),
                          type: .GET,
                          completion: {request in
            let task = URLSession.shared.dataTask(with: request,
                                                  completionHandler: {data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data)
                    print("Resutl: \(result)")
                } catch {
                    print("Error while fetch new releases: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            })
            task.resume()
        })
    }
    
    // MARK: - Private
    private func createBaseRequest(
        with url:URL?,
        type:HTTPMethod,
        completion: @escaping ((URLRequest) -> Void)) {
            AuthManager.shared.withValidToken(completion: {token in
                guard let apiUrl = url else {
                    return
                }
                
                var request = URLRequest(url: apiUrl)
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.httpMethod = type.rawValue
                request.timeoutInterval = 30
                
                completion(request)
            })
        }
}
