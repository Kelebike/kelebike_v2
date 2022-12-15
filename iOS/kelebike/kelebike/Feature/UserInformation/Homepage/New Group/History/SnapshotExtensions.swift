//
//  SnapshotExtensions.swift
//  kelebike
//
//  Created by Mert on 15.12.2022.
//

import Foundation
import FirebaseFirestore

extension QueryDocumentSnapshot {
    
    func decoded<T: Decodable> () throws -> T {
        
        //print(data())
        
        let jsonData = try JSONSerialization.data(withJSONObject: data(), options: [])
        
        let object = try JSONDecoder().decode(T.self, from: jsonData)
        
        return object
    }
}
