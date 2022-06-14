//
//  AuthManager.swift
//  Spotify
//
//  Created by MAC on 14/06/2022.
//

import Foundation

class AuthManager {
    static let shared = AuthManager()
    
    private var refreshingToken: Bool = false
    
    private var onRefreshBlocks = [(String) -> Void]()
    
    struct Constants {
        static let clienID = "391a80c5101c4a72bafefedddcbb6d21"
        static let clientSecret = "b06514f4af93437f95d777688a04c312"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectUri = "https://www.google.com"
        static let scopes = "user-read-private%20user-read-email%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20playlist-modify-public%20user-library-modify%20user-library-read"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let urlString =  "\(base)?response_type=code&client_id=\(Constants.clienID)&redirect_uri=\(Constants.redirectUri)&scopes=\(Constants.scopes)&show_dialog=TRUE"
        
        return URL(string: urlString)
    }
    
    var isSingedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        guard let token = UserDefaults.standard.value(forKey: "access_token") as? String else {
            return nil
        }
        return token
    }
    
    private var refreshToken: String? {
        guard let refreshToken = UserDefaults.standard.value(forKey: "refresh_token") as? String else {
            return nil
        }
        return refreshToken
    }
    
    
    private var expairationDate: Date? {
        guard let expirationIn = UserDefaults.standard.value(forKey: "expiration_in") as? Date else {
            return nil
        }
        return expirationIn
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationIn = expairationDate else {
            return false
        }
        
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationIn
    }
    
    public func exchangeCodeForToken(code: String,
                                     completion: @escaping ((Bool) -> Void)) {
        // Get token from Code
        guard let url = URL(string: Constants.tokenAPIURL) else {
            completion(false)
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUri),
        ]
        
        let basicToken = Constants.clienID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let  base64String = data?.base64EncodedString() else {
            completion(false)
            print("Cannot parse data to base64")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        
        let task =  URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                print("Cannot send token request")
                return
            }
            
            do {
                let result = try AuthResponse.init(data: data)
                print("Success: \(result)")
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print("Error occured: \(error.localizedDescription)")
                completion(false)
            }
        })
        
        task.resume()
    }
    
    /// Supplies valid token with every api call
    public func withValidToken(completion: @escaping ((String) -> Void)) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            // Refresh token
            self.refreshTokenIfNeeded(completion: {[weak self]success in
                
                if let accessToken = self?.accessToken, success {
                    completion(accessToken)
                }
                
            })
        } else if let accessToken = accessToken {
            completion(accessToken)
        }
    }
    
    
    public func refreshTokenIfNeeded(completion: ( (Bool) -> Void)?) {
        guard !refreshingToken else {
            completion?(false)
            return
        }
        
        guard self.shouldRefreshToken else {
            completion?(false)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            completion?(false)
            return
        }
        
        guard let url = URL(string: Constants.tokenAPIURL) else {
            completion?(false)
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]
        
        let basicToken = Constants.clienID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let  base64String = data?.base64EncodedString() else {
            completion?(false)
            print("Cannot parse data to base64")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        
        let task =  URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                completion?(false)
                print("Cannot send token request")
                return
            }
            
            do {
                let result = try AuthResponse.init(data: data)
                self?.refreshingToken = false
                self?.onRefreshBlocks.forEach({$0(result.accessToken)})
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true)
            } catch {
                print("Error occured: \(error.localizedDescription)")
                completion?(false)
            }
        })
        
        task.resume()
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.accessToken, forKey: "access_token")
        if let refreshToken = result.refreshToken {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expiresIn)), forKey: "expiration_in")
    }
}
