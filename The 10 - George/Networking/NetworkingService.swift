//  NetworkingService.swift
//  The 10 - George

//  Created by George Garcia on 2/14/19.
//  Copyright © 2019 George Garcia. All rights reserved

import Foundation
import Alamofire
import SwiftyJSON

class NetworkingService {
    
    static let shared = NetworkingService()
    
    func getNowPlayingMovies(with url: URL, success: @escaping (_ movie: [Movie]) -> Void, failure: @escaping(_ error: Error) -> Void) {
        getMovies(url: now_playingURL, success: success, failure: failure)
    }

    func getUpcomingMovies(url: String, success: @escaping (_ movie: [Movie]) -> Void, failure: @escaping(_ error: Error) -> Void) {
        getMovies(url: url, success: success, failure: failure)
    }
    
    
    private func getMovies(url: String, success: @escaping (_ movie: [Movie]) -> Void, failure: @escaping(_ error: Error) -> Void) {
        guard let api = URL(string: url) else { return }
        Alamofire.request(api, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in

            if response.result.isSuccess {

                let movieJSON = JSON(response.result.value!)
                print("Movie JSON: \(movieJSON)")

            //  let movie = movieJSON["results"].arrayValue
            //  let results = movie.map({ Movie(rawData: $0) })
            //  success(results)

                // run a loop i from 1 to 10. add movie at i into result array. and return result.
                let movie = movieJSON["results"].arrayValue
                var results = [Movie]()
                
                for i in 0...9 {
                    results.append(Movie(rawData: movie[i]))
                    print("Results Count: \(results.count)")
                }
                success(results)
            }
        }
    }
    
    func getGenreId(movieId: String, completion: @escaping(_ genreId: String) -> Void) {
        //results (now playing)
    }
    
    func getGenreTitle(genreId: String, completion: @escaping(_ title: String) -> Void) {
        // genre api
    }
    
    //    func getTitle(movieId: String, success: (_ title: String) -> Void) {
    //        getGenreId(movieId: movieId) { genreId in
    //            self.getGenreTitle(genreId: genreId) { title in
    //                success(title)
    //            }
    //        }
    //    }
    
    func getMoviePoster(movieId: String, success: @escaping (_ url: String) -> Void, failure: @escaping(_ error: Error) -> Void) {
        
        getImageBaseUrl() { stringUrl in
            guard let stringUrl = stringUrl else {
                
                return
            }
            // GCD
            self.getPosterPath(movieId: movieId) { posterPathString in
                guard let posterPathString = posterPathString else {
                    return
                }
                
                let photoURL = stringUrl + "original" + posterPathString
                
                success(photoURL)
            }
        }
    }
    
    func getImageBaseUrl(completion: @escaping (_ stringUrl: String?) -> Void) {
        let movieDBAPI = "https://api.themoviedb.org/3/configuration?api_key=\(api_key)"
        
        guard let url = URL(string: movieDBAPI) else { return }
        
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
    
    func getPosterPath(movieId: String, completion: @escaping (_ posterPath: String?) -> Void) {
        guard let url = URL(string: now_playingURL) else { return }
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            // if it's not successful exit early in the function
            // with a completion and a return statements
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
    
    
//    func justGetData(completion: () -> Void) {
//        Alamofire.request("https://api.themoviedb.org/3/movie/now_playing?api_key=f2448e7d924f45f280a5db37ec9619b1").responseJSON { response in
//            
//            if response.result.isSuccess {
//                let movieJSON = JSON(response.result.value!)
//                print("VENUE JSON (from NetworkingService): \(movieJSON)")
//            } else {
//                print("No Response")
//            }
//           
//        }
//    }
    
}
