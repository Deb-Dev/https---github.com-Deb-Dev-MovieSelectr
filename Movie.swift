//
//  Movie.swift
//  MovieSelectr
//
//  Created by NXP Tims on 06/01/17.
//  Copyright © 2017 deb. All rights reserved.
//

import UIKit

public struct Movie{
    
    static let APIKEY = "1c62e70512f7904371d57bacf7e36017"
    private static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    
    public let title : String!
    public let imagepath : String!
    public let description : String!
    
    public init (title : String , imagepath : String , description : String){
        self.title = title
        self.imagepath = imagepath
        self.description = description
        
    }
    
    
    
    private static func getMovieData (with completion : @escaping (_ success: Bool , _ object: AnyObject?) ->()){
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(APIKEY)&language=en-US&page=1")!)
        session.dataTask(with: request){(data : Data? , response : URLResponse? ,error: Error?) in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode{
                    completion(true , json as AnyObject?)
                }
                else{
                    completion(false , json as AnyObject?)
                    
                }
                
            }
            }.resume()
        
    }
    
    public static func nowPlaying(with completion:@escaping(_ success:Bool,_ movies:[Movie]?)->()){
        Movie.getMovieData{(success,object) in
            if success{
                var movieArray = [Movie]()
                if let movieResults = object?["results"] as? [Dictionary<String,AnyObject>]{
                    for movie in movieResults{
                        let title = movie["original_title"] as! String
                        let description = movie["overview"] as! String
                        guard let posterImage = movie["poster_path"] as? String else {continue}
                        
                        let movieObject = Movie(title: title, imagepath: posterImage, description: description)
                        movieArray.append(movieObject)

                    }
                    completion(true, movieArray)
                }
                else{
                    completion(false, nil)
                }
            }
        }
    }
    
    
    private static func getDocumentsDirectory () -> String?{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard let documents:String = path.first else {
            return nil
        }
        return documents
        
    }
    private static func checkForImageData (withMovieObj movie:Movie)->String?{
        if let document = getDocumentsDirectory(){
            let moviePath = document + "/\(movie.title!)"
            let escapedImagePath = moviePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if FileManager.default.fileExists(atPath: escapedImagePath!){
                return escapedImagePath
            }
        }
        return nil
    }

    
    public static func getImageForCell(forCell cell:AnyObject, withMovieObject movie:Movie){
        if let imagePath = checkForImageData(withMovieObj: movie){
            if let imageData = FileManager.default.contents(atPath: imagePath){
                if cell is UITableViewCell {
                    let tableViewCell = cell as! UITableViewCell
                    tableViewCell.imageView?.image = UIImage(data: imageData)
                    tableViewCell.setNeedsLayout()
                }
                else{
                    //Add collectionViewCell implementation
                    let collectionViewCell = cell as! MovieCollectionViewCell
                    collectionViewCell.movieImageView.image = UIImage(data: imageData)
                    collectionViewCell.setNeedsLayout()
                    
                }
                
            }
        }
        else{
            //download the image and save it to the disk
            let imagePath = Movie.imageBaseURL + movie.imagepath
            let imageUrl = URL(string: imagePath)
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                do {
                    
                    let data = try Data(contentsOf: imageUrl!)
                    
                    let documents = getDocumentsDirectory()
                    
                    let imageFilePathString = documents! + "/\(movie.title)"
                    let escapedImagePath = imageFilePathString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    if FileManager.default.createFile(atPath: escapedImagePath!, contents: data, attributes: nil){
                        print("Image Saved")
                    }
                    
                    DispatchQueue.main.async {
                        if cell is UITableViewCell {
                            let tableViewCell = cell as! UITableViewCell
                            tableViewCell.imageView?.image = UIImage(data: data)
                            tableViewCell.setNeedsLayout()
                        }
                        else{
                            //Add collectionViewCell implementation
                            let collectionViewCell = cell as! MovieCollectionViewCell
                            collectionViewCell.movieImageView.image = UIImage(data: data)
                            collectionViewCell.setNeedsLayout()
                        }
                    }
                }
                catch{
                    print("Noiamge at specified location")
                }
            }
            
        }
    }
    
    
}

