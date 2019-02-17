//  NetworkingService.swift
//  The 10 - George

//  Created by George Garcia on 2/14/19.
//  Copyright © 2019 George Garcia. All rights reserved

import Foundation
import Alamofire
import SwiftyJSON

class NetworkingService {
    
    static let shared = NetworkingService()
    var genreNameIdPairs: [Int: String] = [:]
    
    func getNowPlayingMovies(with url: URL, success: @escaping (_ movie: [Movie]) -> Void, failure: @escaping(_ error: Error) -> Void) {
        getMovies(url: now_playingURL, success: success, failure: failure)
    }

    func getUpcomingMovies(with url: URL, success: @escaping (_ movie: [Movie]) -> Void, failure: @escaping(_ error: Error) -> Void) {
        getMovies(url: upcoming_URL, success: success, failure: failure)
    }
    
    init() {
        getGenreTitle {
            print("Gotten tiles")
        }
    }
    
    private func getMovies(url: String, success: @escaping (_ movie: [Movie]) -> Void, failure: @escaping(_ error: Error) -> Void) {
        guard let api = URL(string: url) else { return }
        Alamofire.request(api, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in

            if response.result.isSuccess {

                let movieJSON = JSON(response.result.value!)
                //print("Movie JSON: \(movieJSON)")

            //  let movie = movieJSON["results"].arrayValue
            //  let results = movie.map({ Movie(rawData: $0) })
            //  success(results)

                // run a loop i from 1 to 10. add movie at i into result array. and return result.
                let movie = movieJSON["results"].arrayValue
                var results = [Movie]()
                
                for i in 0...9 {
                    results.append(Movie(rawData: movie[i]))
                    //print("Results Count: \(results.count)")
                }
                success(results)
            }
        }
    }
    
    // MARK: Images
    
    // getting the image base url from the "Configuration" MovieBaseDB API URL
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
    
    // getting the poster path from the Movies Now_Playing API URL
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
            
            //print("Result from getPosterPath: \(result)")
            
            let posterPath = result["poster_path"].stringValue
            
            completion(posterPath)
        }
    }
    
    // Getting both requests and making them into 1 (GCD)
    func getMoviePoster(movieId: String, success: @escaping (_ url: String) -> Void, failure: @escaping(_ error: Error) -> Void) {
        
        getImageBaseUrl() { stringUrl in
            guard let stringUrl = stringUrl else {

                return
            }
            // GCD (Calling both Requests to create the photo URL)
            self.getPosterPath(movieId: movieId) { posterPathString in
                guard let posterPathString = posterPathString else {
                    return
                }
                
                let photoURL = stringUrl + "original" + posterPathString
                
                success(photoURL)
            }
        }
    }
    
    func getGenre(movieId: String, success: @escaping (_ title: String) -> Void) {
        getGenreId(movieId: movieId) { genreId in
            guard let genreId = genreId else {
                print("Abotu to return here")
                success("")
                return
            }
            let genreName = self.genreNameIdPairs[genreId] ?? ""
            print("Genre Name", genreId, genreName, self.genreNameIdPairs)
            success(genreName)
        }
    }
    
    
    
    // MARK: Genres
    func getGenreId(movieId: String, completion: @escaping(_ genreId: Int?) -> Void) {
        //results (now playing)
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=f2448e7d924f45f280a5db37ec9619b1&language=en-US") else { return }
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
//            print("REsponse", response)
//            print("Success", response.result.isSuccess)
//            print("Key value", response.result.value)
//            print("JSONified", JSON(response))
//            print("DictValue", JSON(response).dictionaryValue)
//            print("Results", JSON(response).dictionaryValue["results"]?.arrayValue)
            print("Response response", response)
            if !response.result.isSuccess {
                print("Failed here 1")
                completion(nil)
                return
            }
            
            guard let response = response.result.value as? [String : AnyObject] else {
                print("Failed here 2")
                completion(nil)
                return
            }
            
            let rawData = JSON(response)
            let dict = rawData.dictionaryValue
            let genres = dict["genres"]?.arrayValue
            let firstGenreDict = genres?[0].dictionaryValue
            let firstGenre = firstGenreDict?["id"]?.intValue
            print("Genres genres", firstGenre)
            
            guard let firstGenreId = firstGenre else { print("Couldn't find first genreId"); completion(nil); return }
            print("First genre id found", firstGenreId)
   
            completion(firstGenreId)

            
        }
        
    }
    
    func getGenreTitle( completion: @escaping() -> Void) { // getting the genreTitle

        // genre api
        let genre_apiURL = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(api_key)&language=en-US"
        guard let url = URL(string: genre_apiURL) else { return }
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            print("The response")
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
            
//            guard let genre_name = genreDict["name"]?.stringValue else {
//                completion()
//                return
//            }
//
            completion()
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
