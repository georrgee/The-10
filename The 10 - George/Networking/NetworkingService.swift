//  NetworkingService.swift
//  The 10 - George

//  Created by George Garcia on 2/14/19.
//  Copyright © 2019 George Garcia. All rights reserved

import Foundation
import Alamofire
import SwiftyJSON

class NetworkingService {
    
    // MARK: Constant Variables
    static let shared = NetworkingService()
    var genreNameIdPairs: [Int: String] = [:]
    
    init() {
        getGenreTitle {}
    }
    
    func getNowPlayingMovies(with url: URL, success: @escaping (_ movie: [Movie]) -> Void, failure: @escaping(_ error: Error) -> Void) {
        getMovies(url: now_playingURL, success: success, failure: failure)
    }

    func getUpcomingMovies(with url: URL, success: @escaping (_ movie: [Movie]) -> Void, failure: @escaping(_ error: Error) -> Void) {
        getMovies(url: upcoming_URL, success: success, failure: failure)
    }
    
    private func getMovies(url: String, success: @escaping (_ movie: [Movie]) -> Void, failure: @escaping(_ error: Error) -> Void) {
        guard let api = URL(string: url) else { return }
        Alamofire.request(api, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in

            if response.result.isSuccess {
                let movieJSON = JSON(response.result.value!)

                // run a loop i from 1 to 10. add movie at i into result array. and return result.
                let movie = movieJSON["results"].arrayValue
                var results = [Movie]()
                
                for i in 0...9 {
                    results.append(Movie(rawData: movie[i]))
                }
                success(results)
            }
        }
    }
    
    // MARK: Images - Getting them from TheMovieDB API
    private func getImageBaseUrl(completion: @escaping (_ stringUrl: String?) -> Void) {
        
        // getting the image base url from the "Configuration" MovieBaseDB API URL
        guard let url = URL(string: config_URL) else { return }
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if !response.result.isSuccess {
                completion(nil)
                return
            }
            let rawData = JSON(response.result.value!)
            let imageDict = rawData["images"].dictionaryValue as [String: JSON]
            
            guard let base_url = imageDict["base_url"]?.stringValue else {
                completion(nil)
                return
            }
            
            completion(base_url)
        }
    }
    // Upcoming API URL getting Poster Path
    private func getUpcomingPosterPath(movieId: String, completion: @escaping (_ posterPath: String?) -> Void) {
        
        guard let url = URL(string: upcoming_URL) else { return }
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if !response.result.isSuccess {   // if it's not successful, exit early in the function
                completion(nil)
                return                        // with a completion and a return statements
            }
            
            guard let response = response.result.value as? [String: AnyObject] else {
                completion(nil)
                return
            }
            
            let rawData = JSON(response)
            let dict = rawData.dictionaryValue
            
            guard let results = dict["results"]?.arrayValue else {
                completion(nil)
                return
            }
            
            guard let result = results.filter({
                return $0["id"].stringValue == movieId
            }).first else {
                completion(nil)
                return
            }

            let posterPath = result["poster_path"].stringValue
            
            completion(posterPath)
        }
    }
    
    // getting the poster path from the Movies Now_Playing API URL
    private func getNowPlayingPosterPath(movieId: String, completion: @escaping (_ posterPath: String?) -> Void) {
        
        guard let url = URL(string: now_playingURL) else { return }
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if !response.result.isSuccess {
                completion(nil)
                return
            }
            
            guard let response = response.result.value as? [String: AnyObject] else {
                completion(nil)
                return
            }
            
            let rawData = JSON(response)
            let dict = rawData.dictionaryValue
            
            guard let results = dict["results"]?.arrayValue else {
                completion(nil)
                return
            }
            
            guard let result = results.filter({
                return $0["id"].stringValue == movieId
            }).first else {
                completion(nil)
                return
            }
            
            let posterPath = result["poster_path"].stringValue
            
            completion(posterPath)
        }
    }
    
    func getUpcomingMoviePoster(movieId: String, success: @escaping (_ url: String) -> Void, failure: @escaping(_ error: Error) -> Void) {
        
        getImageBaseUrl() { stringUrl in
            guard let stringUrl = stringUrl else {
                return
            }
            self.getUpcomingPosterPath(movieId: movieId) { posterPathString in
                guard let posterPathString = posterPathString else {
                    return
                }
                let photoUrl = stringUrl + "original" + posterPathString
                success(photoUrl)
            }
        }
    }
    
    // Getting both requests and making them into 1 (GCD)
    func getNowPlayingMoviePoster(movieId: String, success: @escaping (_ url: String) -> Void, failure: @escaping(_ error: Error) -> Void) {
        
        getImageBaseUrl() { stringUrl in
            guard let stringUrl = stringUrl else {

                return
            }
            // GCD (Calling both Requests to create the photo URL)
            self.getNowPlayingPosterPath(movieId: movieId) { posterPathString in
                guard let posterPathString = posterPathString else {
                    return
                }
                
                let photoURL = stringUrl + "original" + posterPathString
                
                success(photoURL)
            }
        }
    }
    
    // MARK: Genres - Getting them from TheMovieDB API
    
    func getGenre(movieId: String, success: @escaping (_ title: String) -> Void) {
        getGenreId(movieId: movieId) { genreId in
            guard let genreId = genreId else {
                success("")
                return
            }
            let genreName = self.genreNameIdPairs[genreId] ?? ""
            success(genreName)
        }
    }
    
    private func getGenreId(movieId: String, completion: @escaping(_ genreId: Int?) -> Void) {
        
        // movie details API
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(api_key)&language=en-US") else { return }
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in

            if !response.result.isSuccess {
                completion(nil)
                return
            }
            
            guard let response = response.result.value as? [String : AnyObject] else {
                completion(nil)
                return
            }
            
            let rawData = JSON(response)
            let dict = rawData.dictionaryValue
            let genres = dict["genres"]?.arrayValue
            let firstGenreDict = genres?[0].dictionaryValue
            let firstGenre = firstGenreDict?["id"]?.intValue
            
            guard let firstGenreId = firstGenre else { completion(nil); return }
            completion(firstGenreId)
        }
        
    }
    
    private func getGenreTitle( completion: @escaping() -> Void) { // getting the genreTitle

        // genre api
        guard let url = URL(string: genre_URL) else { return }
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if !response.result.isSuccess {
                completion()
                return
            }
            
            let rawData = JSON(response.result.value!)
            let genreArray = rawData["genres"].arrayValue
            print(" Genre Array", genreArray)
            for (key, value) in genreArray.enumerated() {
                let valueDict = value.dictionaryValue
                let id = valueDict["id"]?.intValue
                let name = valueDict["name"]?.stringValue
                guard let genreId = id, let genreName = name else { return }
                self.genreNameIdPairs.updateValue(genreName, forKey: genreId)
                print("Value Dict", valueDict)
            }
            completion()
        }
    }
}
