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
    
    // MARK: - User Profile
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
                    
                    completion(.success(result))
                } catch {
                    print("Cannot pars data: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            })
            task.resume()
        })
    }
    
    // MARK: - Albums
    /// Get album details
    public func getAlbumDetails(
        for album: Album,
        completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
            createBaseRequest(
                with: URL(string: "\(Constants.baseAPIURL)/albums/\(album.id)"),
                type: .GET
            ) { request in
                
                let task = URLSession.shared.dataTask(with: request,
                                                      completionHandler: {data, _, error in
                    print("Start fetching album datails...")
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
                        let result = try JSONDecoder().decode(AlbumDetailsResponse.self,
                                                              from: data)
                        completion(.success(result))
                    } catch {
                        print("Error while fetch album data: \(error)")
                        completion(.failure(error))
                    }
                })
                
                task.resume()
            }
        }
    
    // MARK: - Playlists
    // Get playlist details
    public func getPlaylistDetails(
        for playlist: Playlist,
        completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
            createBaseRequest(
                with: URL(string: "\(Constants.baseAPIURL)/playlists/\(playlist.id)"),
                type: .GET
            ) { request in
                
                let task = URLSession.shared.dataTask(with: request,
                                                      completionHandler: {data, _, error in
                    print("Start fetching album datails...")
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
                        let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                        print(result)
                        completion(.success(result))
                    } catch {
                        print("Error while fetch album data: \(error)")
                        completion(.failure(error))
                    }
                })
                
                task.resume()
            }
        }
    
    
    // MARK: - Categories
    /// Get Available Categories
    public func getAvailableCategories(completion: @escaping ((Result<CategoryResponse, Error>) -> Void)) {
        createBaseRequest(with: URL(string: "\(Constants.baseAPIURL)/browse/categories/"),
                          type: .GET,
                          completion: { request in
            
            let task = URLSession.shared.dataTask(with: request,
                                                  completionHandler: {data, response, error in
                
                guard let data = data, error == nil else {
                    print("Cannot fetch featured playlist")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(CategoryResponse.self,
                                                          from: data)
                    
                    completion(.success(result))
                }
                catch {
                    print("Error while parsing data: \(error)")
                    completion(.failure(error))
                }
            })
            task.resume()
        })
        
    }
    
    /// Get Playlists for Category
    public func getCategoryPlaylists(
        category: Category,
        completion: @escaping ((Result<[Playlist], Error>) -> Void)) {
            createBaseRequest(
            with: URL(string: "\(Constants.baseAPIURL)/browse/categories/\(category.id)/playlists"),
            type: .GET,
            completion: { request in
                
                let task = URLSession.shared.dataTask(with: request,
                                                      completionHandler: {data, response, error in
                    
                    guard let data = data, error == nil else {
                        print("Cannot fetch featured playlist")
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    do {
                        let result =  try JSONDecoder().decode(FeaturedResponse.self,
                                                                  from: data)
                        
                        completion(.success(result.playlists.items))
                    }
                    catch {
                        print("Error while parsing data: \(error)")
                        completion(.failure(error))
                    }
                })
                task.resume()
            })
        
    }
    
    // MARK: - Browse
    /// Get new releases
    public func getNewReleases(completion: @escaping ((Result<NewReleaseResponse, Error>) -> Void)) {
        createBaseRequest(with: URL(string: "\(Constants.baseAPIURL)/browse/new-releases?limit=10"),
                          type: .GET,
                          completion: {request in
            let task = URLSession.shared.dataTask(with: request,
                                                  completionHandler: {data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleaseResponse.self, from: data)
                    
                    completion(.success(result))
                } catch {
                    print("Error while fetch new releases: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            })
            task.resume()
        })
    }
    
    /// Get featured playlists
    public func getFeaturedPlaylist(completion: @escaping ((Result<FeaturedResponse, Error>) -> Void)) {
        createBaseRequest(with: URL(string: "\(Constants.baseAPIURL)/browse/featured-playlists"),
                          type: .GET,
                          completion: { request in
            let task = URLSession.shared.dataTask(with: request,
                                                  completionHandler: {data, _, error in
                guard let data = data, error == nil else {
                    print("Cannot fetch featured playlist")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    //                    let result = try JSONDecoder().decode(FeaturedResponse.self, from: data)
                    let result = try JSONDecoder().decode(FeaturedResponse.self, from: data)
                    
                    completion(.success(result))
                }
                catch {
                    print("Error while parsing data: \(error)")
                    completion(.failure(error))
                }
            })
            task.resume()
        })
        
    }
    
    /// Get Available Genre
    public func getAvailableGenre(completion: @escaping ((Result<GenresResponse, Error>) -> Void)) {
        createBaseRequest(with: URL(string: "\(Constants.baseAPIURL)/recommendations/available-genre-seeds/"),
                          type: .GET,
                          completion: { request in
            
            let task = URLSession.shared.dataTask(with: request,
                                                  completionHandler: {data, response, error in
                
                guard let data = data, error == nil else {
                    print("Cannot fetch featured playlist")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    //                    let result = try JSONDecoder().decode(GenresResponse.self, from: data)
                    
                    
                    let result = try JSONDecoder().decode(GenresResponse.self,
                                                          from: data)
                    
                    completion(.success(result))
                }
                catch {
                    print("Error while parsing data: \(error)")
                    completion(.failure(error))
                }
            })
            task.resume()
        })
        
    }
    
    /// Get recommendations
    public func getRecommendations(genres: Set<String>,
                                   completion: @escaping ((Result<RecommendationResponse, Error>) -> Void)) {
        let seeds = genres.joined(separator: ",")
        createBaseRequest(with: URL(string: "\(Constants.baseAPIURL)/recommendations?seed_genres=\(seeds)&limit=2"),
                          type: .GET,
                          completion: { request in
            let task = URLSession.shared.dataTask(with: request,
                                                  completionHandler: {data, _, error in
                
                guard let data = data, error == nil else {
                    print("Cannot fetch featured playlist")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    //                    let result = try JSONDecoder().decode(GenresResponse.self, from: data)
                    let result = try JSONDecoder().decode(RecommendationResponse.self, from: data)
                    
                    completion(.success(result))
                }
                catch {
                    print("Error while parsing data: \(error)")
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
