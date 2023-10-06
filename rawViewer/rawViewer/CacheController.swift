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
    static let MAX_CACHE_COUNT = 5 // 20;
    static let MIN_CACHE_COUNT = 0 // 10;
    
    var lock: DispatchQueue = DispatchQueue.init(label: "")
    
    var cache: [URL: (DispatchTime, NSImage)] = [:];
    
    func getImage(url: URL) async -> NSImage?
    {
        var image: NSImage?
        
        lock.sync
        {
            if self.cache.keys.contains(url)
            {
                self.cache[url]!.0 = DispatchTime.now();
                image = self.cache[url]?.1;
            }
        }
        
        Task
        {
            self.cleanup()
            self.lookahead()
        }
        
        return (image != nil) ? image : cacheImage(url: url);
    }
    
    func cacheImage(url: URL) -> NSImage?
    {
        let image = NSImage(byReferencing: url);
        lock.sync
        {
            self.cache[url] = (DispatchTime.now(), image);
        }
        return image;
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
        
        lock.sync
        {
            while self.cache.count > CacheController.MAX_CACHE_COUNT
            {
                if let keyToRemove = self.cache.min(by: { $0.value.0 < $1.value.0 })?.key
                {
                    self.cache.removeValue(forKey: keyToRemove);
                }
                else
                {
                    break;
                }
            }
        }
        
        
    }
    
    func lookahead()
    {
        
    }
}
