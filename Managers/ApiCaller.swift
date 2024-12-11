//
//  ApiCaller.swift
//  MovieApp
//
//  Created by User on 19.08.2024.
//

import Foundation

struct Constants {
    static let API_KEY = "24cf02305657f8a25e5f7c3ef21cb8a1"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI = "AIzaSyAjRAXBJzxr4_VuJFqfQ5JmD4PEbuXrn3E"
}

enum APIError: Error {
    case failedToGetData
}

class ApiCaller {
    static let shared = ApiCaller()
    
//    func getTrendingMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
//        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data, error == nil else { return }
//            do {
//                let results =  try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
//                completion(.success(results.results))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//    
//    func getTrendingTvs(completion: @escaping(Result<[Title], Error>) -> Void) {
//        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else { return }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data, error == nil else { return }
//            do {
//                let results =  try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
//                completion(.success(results.results))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//    
//    func upcomingMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
//        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&include_video=false&language=en-US&") else { return }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data, error == nil else { return }
//            do {
//                let results =  try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
//                completion(.success(results.results))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//    
//    func topRatedMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
//        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)") else { return }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data, error == nil else { return }
//            do {
//                let results =  try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
//                completion(.success(results.results))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//    
//    func popularMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
//        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)") else { return }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data, error == nil else { return }
//            do {
//                let results =  try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
//                completion(.success(results.results))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
    
    private func fetchTitles(from urlString: String, completion: @escaping(Result<[Title], Error>) -> Void) {
           guard let url = URL(string: urlString) else {
               return
           }
           
           let task = URLSession.shared.dataTask(with: url) { data, _, error in
               guard let data = data, error == nil else {
                   return
               }
               do {
                   let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                   completion(.success(results.results))
               } catch {
                   completion(.failure(APIError.failedToGetData))
               }
           }
           task.resume()
       }
    
    func getTrendingMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
        fetchTitles(from: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)&include_video=false&language=en-US", completion: completion)
    }
    
    func getTrendingTvs(completion: @escaping(Result<[Title], Error>) -> Void) {
        fetchTitles(from: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)&include_video=false&language=en-US", completion: completion)
    }
    
    func upcomingMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
        fetchTitles(from: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&include_video=false&language=en-US", completion: completion)
    }
    
    func topRatedMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
        fetchTitles(from: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&include_video=false&language=en-US", completion: completion)
    }
    
    func popularMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
        fetchTitles(from: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&include_video=false&language=en-US", completion: completion)
    }
    
    func discoverMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
        fetchTitles(from: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&include_video=false&language=en-US&sork_by=popularity.desc&include_adult=false&with_watch_monetization_types=flatrate", completion: completion)
    }
    
    func search(with query: String, completion: @escaping(Result<[Title], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping(Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "https://youtube.googleapis.com/youtube/v3/search?q=\(query)&key=\(Constants.YoutubeAPI)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do{
                let results = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
                
                completion(.success(results.items[0]))
                
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
