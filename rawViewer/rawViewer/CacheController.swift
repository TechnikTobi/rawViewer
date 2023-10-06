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
            print("found in cache!")
            
            Task
            {
                if let next = self.findNextImageOutsideOfCache()
                {
                    let image = cacheImage(url: next);
                }
            }
            
            return self.cache[url]?.1;
        }
        
        return cacheImage(url: url);
    }
    
    func cacheImage(url: URL) -> NSImage?
    {
        print("why does this get called?")
        let image = NSImage(byReferencing: url);
        lock.sync
        {
            self.cache[url] = (DispatchTime.now(), image);
        }
        
        print("Next: ", self.findNextImageOutsideOfCache())
        
        return image;
    }
    
    func initCacheFill()
    {
        
    }
    
    func scanDirectory(forURL url: URL) -> [URL]
    {
        let directoryURL = url.deletingPathExtension().deletingLastPathComponent();
        var directoryContents: [URL] = [];
        
        if let scanResult = try? FileManager.default.contentsOfDirectory(atPath: directoryURL.absoluteURL.path)
        {
            for item in scanResult
            {
                let suffix = URL(fileURLWithPath: item).pathExtension;
                if suffix.lowercased() == "rw2" || suffix.lowercased() == "jpg"
                {
                    directoryContents.append(
                        URL(filePath: item, relativeTo: directoryURL)
                    )
                }
            }
            
            directoryContents.sort(by:{ $0.absoluteString < $1.absoluteString })
        }
        
        return directoryContents;
    }
    
    func findNextImageOutsideOfCache() -> URL?
    {
        if let maxURLinCache = self.cache.keys.max(by: { $0.absoluteURL.path < $1.absoluteURL.path })
        {
            let directoryContents = self.scanDirectory(forURL: maxURLinCache);
            if let maxURLindex = directoryContents.firstIndex(of: maxURLinCache)
            {
                let nextIndex = maxURLindex+1;
                return nextIndex < directoryContents.count ? directoryContents[nextIndex] : nil;
            }
        }
        
        return nil;
    }
    
    /*
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
        print("why does this get called?")
        let image = NSImage(byReferencing: url);
        lock.sync
        {
            self.cache[url] = (DispatchTime.now(), image);
        }
        return image;
    }
    
    func cleanup()
    {
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
                repeat
                {
                    let newURL = currentDirectoryContents[currentIndex+offset]
                    print("Reading file ", newURL)
                    let image = NSImage(byReferencing: newURL);
                    image.cacheMode = .always;
                    print(image.size)
                    self.cache[newURL] = (DispatchTime.now(), image);
                    offset += 1;
                } while self.cache.count < CacheController.MIN_CACHE_COUNT
            }
        }
    }
    */
}
