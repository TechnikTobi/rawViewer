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
    
    func getImage(url: URL) -> NSImage?
    {
        var image: NSImage?
        
        lock.sync
        {
            if !self.cache.keys.contains(url)
            {
                self.cache[url] = (DispatchTime.now(), self.loadImage(url: url)!)
            }
            
            image = self.cache[url]?.1;
        }
        
        Task
        {
            lock.sync
            {
                repeat
                {
                    if let next = self.findNextImageOutsideOfCache()
                    {
                        self.cache[next] = (DispatchTime.now(), self.loadImage(url: next)!)
                    }
                }
                while self.cache.count < CacheController.MIN_CACHE_COUNT
            }
        }
        
        return image;
    }
    
    func loadImage(url: URL) -> NSImage?
    {
        let image = NSImage(contentsOf: url)
        return image;
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
    
    func findNextImageFor(forURL url: URL?) -> URL?
    {
        if url == nil { return nil; }
        
        let directoryContents = self.scanDirectory(forURL: url!);
        if let urlIndex = directoryContents.firstIndex(of: url!)
        {
            let nextIndex = urlIndex+1;
            return nextIndex < directoryContents.count ? directoryContents[nextIndex] : nil;
        }
        
        return nil;
    }
    
    func findNextImageOutsideOfCache() -> URL?
    {
        if let maxURLinCache = self.cache.keys.max(by: { $0.absoluteURL.path < $1.absoluteURL.path })
        {
            return self.findNextImageFor(forURL: maxURLinCache)
        }
        
        return nil;
    }
}
