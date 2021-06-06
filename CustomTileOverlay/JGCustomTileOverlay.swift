//
//  JGCustomTileOverlay.swift
//  CustomTileOverlay
//
//  Created by Jonathan Gander on 05.06.21.
//

import UIKit
import MapKit

class JGCustomTileOverlay: MKTileOverlay {
    
    private let cacheDirectory: URL
    private let fileManager: FileManager
    
    private var invalidTileURL: URL
    
    public var saveInCache = false
    
    override init(urlTemplate URLTemplate: String?) {
        
        // *** Set default values
        fileManager = FileManager.default
        cacheDirectory = CacheDirectoryManager.shared.cacheDirectory

        // URL for invalid tile image
        invalidTileURL = Bundle.main.url(forResource: "invalidTile", withExtension: "png")! // Warning : be sure you have a `invalidTile.png` image in your project
        
        super.init(urlTemplate: URLTemplate)
    }
    
    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        
        if var urlTemplate = urlTemplate {
            
            // Create URL with path values
            urlTemplate = urlTemplate.replacingOccurrences(of: "{x}", with: String(path.x))
                .replacingOccurrences(of: "{y}", with: String(path.y))
                .replacingOccurrences(of: "{z}", with: String(path.z))
            
            if let url = URL(string: urlTemplate) {
                return url
            }
        }
        
        return invalidTileURL
    }
    
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        
        guard urlTemplate != nil else {
            return result(try? Data(contentsOf: invalidTileURL), nil)
        }
        
        let tileURL = url(forTilePath: path)
        
        if let b64TileHash = tileURL.absoluteString.data(using: .utf8)?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
            let tilePath = cacheDirectory.appendingPathComponent(b64TileHash)
            
            // Try to find current tile in cache directory
            if fileManager.fileExists(atPath: tilePath.path) {
                return result(try? Data(contentsOf: tilePath), nil)
            }
            
            // If not already in cache, load tile from URL
            URLSession.shared.dataTask(with: tileURL, completionHandler: { data, response, error in
                
                if let data = data {
                    
                    let httpResponse = response as? HTTPURLResponse
                    
                    // Save in cache
                    if self.saveInCache && httpResponse?.statusCode == 200 && data.count > 0 {
                        try? data.write(to: tilePath)
                    }
                    
                    return result(data, nil)
                }
                
                return result(nil, nil)
            }).resume()
        }
        else {
            return result(nil, nil)
        }
    }
}
