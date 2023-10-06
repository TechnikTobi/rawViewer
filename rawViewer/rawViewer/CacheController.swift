//
//  CacheController.swift
//  rawViewer
//
//  Created by Tobias Prisching on 06.10.23.
//

import Foundation
import AppKit

class CacheController
{
    static let MAX_CACHE_COUNT = 20;
    static let MIN_CACHE_COUNT = 10;
    
    var cache: [URL: (DispatchTime, NSImage)] = [:];
    
    func getImage(url: URL) async -> NSImage?
    {
        if self.cache.keys.contains(url)
        {
            self.cache[url]!.0 = DispatchTime.now();
            return self.cache[url]?.1;
        }
        
        Task
        {
            // Resize caches
            self.cleanup()
            // Get lookahead image data into cache
        }
        
        return cacheImage(url: url);
    }
    
    func cacheImage(url: URL) -> NSImage?
    {
        return NSImage(byReferencing: url);
    }
    
    func cleanup()
    {
        // Remove cached items where the files have been deleted
        // Disabled in case the delete operation gets un-done and we quickly need the image again to be displayed
        /*
        for url in self.cache.keys
        {
            if !FileManager.default.fileExists(atPath: url.absoluteURL.path)
            {
                self.cache.removeValue(forKey: url);
            }
        }
        */
        
        while self.cache.count > CacheController.MAX_CACHE_COUNT
        {
            
        }
    }
    
    func lookahead()
    {
        
    }
}
