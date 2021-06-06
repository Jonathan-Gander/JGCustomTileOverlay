//
//  CacheDirectoryManager.swift
//  CustomTileOverlay
//
//  Created by Jonathan Gander on 06.06.21.
//

import Foundation

class CacheDirectoryManager {
    
    // MARK: Public members
    
    /// Singleton access
    static let shared = CacheDirectoryManager()
 
    /// Cache directory URL
    public let cacheDirectory: URL
    
    // MARK: Private members and methods
    private let fileManager = FileManager.default
    
    private init() {
        // Define cache directory URL
        cacheDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("tiles")
        
        // Create cache directory (if needed)
        createCacheDirectory()
    }

    /// Create cache directory if needed
    private func createCacheDirectory() {
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
            try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    // MARK: Public methods
    
    /// Returns size of cache directory as human readable string. Use Tools.cacheDirectory() as directory.
    ///
    /// - Returns: A human readable string
    func getCacheSize() -> String! {
        
        // Get files
        let files = fileManager.enumerator(at: cacheDirectory, includingPropertiesForKeys: nil)
        
        // Calculate size of each file
        var folderSize: Int64 = 0
        while let file = files?.nextObject() as? URL {
            let fileAttributes = try? fileManager.attributesOfItem(atPath: file.path)
            folderSize += fileAttributes?[FileAttributeKey.size] as! Int64
        }
        
        // Format size in readable string
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        
        return formatter.string(fromByteCount: folderSize)
    }
    
    /// Clear cache directory (will remove directory and its content, and recreate it)
    func clearCacheDirectory() {
        // Remove directory
        try? fileManager.removeItem(atPath: cacheDirectory.path)
        
        // Recreate it
        createCacheDirectory()
    }
}
