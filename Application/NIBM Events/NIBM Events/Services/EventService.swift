//
//  EventService.swift
//  NIBM Events
//
//  Created by Pradeep Sanjaya on 3/1/20.
//  Copyright © 2020 Pradeep Sanjaya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class EventService {
    func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        // 1
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            return completion(nil)
        }

        // 2
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            // 3
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }

            // 4
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                completion(url)
            })
        })
    }
    
    func create(for image: UIImage, token: String)  -> String {
        let imageRef = Storage.storage().reference().child("users").child("\(token)).jpg")
        var urlString:String = ""
        
        uploadImage(image, at: imageRef) {
            (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            urlString = downloadURL.absoluteString
            print("image url: \(urlString)")
        }
        
        return urlString
    }
}
