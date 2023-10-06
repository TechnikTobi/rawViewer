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
    
    var lock: DispatchQueue = DispatchQueue.init(label: "")
    
    var cache: [URL: (DispatchTime, NSImage)] = [:];
    
    func getImage(url: URL) async -> NSImage?
    {
        
        if self.cache.keys.contains(url)
        {
            // self.cache[url]!.0 = DispatchTime.now();
            return self.cache[url]?.1;
        }
    
        Task
        {
            self.cleanup()
            self.lookahead(forURL: url)
        }
        
        return cacheImage(url: url);
    }
    
    func cacheImage(url: URL) -> NSImage?
    {
        print("this should not get called actually")
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
            if self.cache.count > CacheController.MAX_CACHE_COUNT
            {
                while self.cache.count > CacheController.MIN_CACHE_COUNT
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
            print("Current cache size: ", self.cache.count)
        }
        
        
        
        
    }
    
    func lookahead(forURL url: URL)
    {
        let directoryURL = url.deletingPathExtension().deletingLastPathComponent();
        var currentDirectoryContents: [URL] = [];
        
        if let scanResult = try? FileManager.default.contentsOfDirectory(atPath: directoryURL.absoluteURL.path)
        {
            for item in scanResult
            {
                let suffix = URL(fileURLWithPath: item).pathExtension;
                if suffix.lowercased() == "rw2" || suffix.lowercased() == "jpg"
                {
                    currentDirectoryContents.append(
                        URL(filePath: item, relativeTo: directoryURL)
                    )
                }
            }
            
            currentDirectoryContents.sort(by:{ $0.absoluteString < $1.absoluteString })
        }
        
        if let currentIndex = currentDirectoryContents.firstIndex(of: url)
        {
            var offset = 1;
            lock.sync
            {
                while self.cache.count < CacheController.MAX_CACHE_COUNT
                {
                    let newURL = currentDirectoryContents[currentIndex+offset]
                    self.cache[newURL] = (DispatchTime.now(), NSImage(byReferencing: newURL));
                    offset += 1;
                }
            }
        }
    }
}
