//
//  ViewController.swift
//  iOS-Networking
//
//  Created by Anuj Dutt on 7/19/19.
//  Copyright © 2019 Anuj Dutt. All rights reserved.
//

import UIKit

// Struct to parse data from JSON
struct MLModel{
    let models: String
    
    init(json: [String: Any]) {
        // Get ML Model Version from JSON
        models = json["models"] as! String
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    var serverAvailable:Bool = false
    
    override func viewDidLoad() {
        // Check if server is LIVE
        // On opening the app, get all ML Model Versions from REST API
        self.get(route: "ping")
        super.viewDidLoad()
    }
    
    
    // Function to GET Response from REST API
    func get(route: String){
        let routeURL = "http://0.0.0.0:80/" + route
        
        // Define the URL for the API Call
        guard let url = URL(string: routeURL) else {return}
        
        // Create a URL Session
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response{
                print("API Response:\n\(response)")
            }
            // Raw Data
            if let data = data{
                print("Data length: \(data.count)")
                do {
                    // Convert data to JSON
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    print("Recieved JSON Data: \n\(jsonData)")
                    // Check Server Availability
                    if (route.contains("ping")){
                        self.get(route: "models")
                    }
                    // Get ML Model Version
                    if (route.contains("models")){
                        let modelVersions = MLModel(json: jsonData).models
                        print("Model Versions: \(modelVersions)")
                    }
                }
                catch{
                    print(error)
                }
            }
            }.resume()
    }
    
    // Function to make GET Request
    @IBAction func onGetTapped(_ sender: Any) {
        print("Hello World...")
    }
    
    // Function to make a POST Request
    @IBAction func onPostTapped(_ sender: Any) {
        // Load local Image
//        let resourcesPath = Bundle.main.resourcePath
//        let fileManager = FileManager.default
//
//        do{
//            let docsArr = try fileManager.contentsOfDirectory(atPath: resourcesPath ?? "")
//            print("Docs: \(docsArr)")
//        }catch{
//            print("\(#function) \(error)")
//        }
//
//        let goodUrl = URL(fileURLWithPath: (resourcesPath?.appending("/apple.png"))!)
//        var img:Data? = nil
//        do{
//            img = try Data(contentsOf: goodUrl)
//        }catch{
//            print(error)
//        }
//
//        self.imageView.image = UIImage(data: img!)
        
        // To send an Image and ASR Text use this in Parameters
        if let url = URL(string: "https://www.allaboutbirds.org/guide/assets/og/75335251-1200px.jpg"){
            do {
                let data = try Data(contentsOf: url)
                //self.imageView.image = UIImage(data: data)
                self.image = UIImage(data: data)
            }
            catch{
                print(error)
            }
        }
        
        // Input Parameters to Post
        let parameters = ["Image": self.image?.jpegData(compressionQuality: 0.5)?.base64EncodedString(), "Model_Version": "v1.1"]
        // Define the URL
        guard let url = URL(string: "http://0.0.0.0:80/predict") else {return}
        // Define URL Request
        var request = URLRequest(url: url)
        // Define this request as a Post Request
        request.httpMethod = "POST"
        // Create the JSON data as payload
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        // HTTP body to request body
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        // URL Session
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response{
                print("API Response:\n\(response)")
            }
            // Raw Data
            if let data = data{
                do {
                    // Convert data to JSON
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Sent JSON Data: \n\(json)")
                }
                catch{
                    print(error)
                }
            }
            }.resume()
    }
}

