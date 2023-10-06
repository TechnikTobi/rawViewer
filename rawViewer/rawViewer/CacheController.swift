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
    var cache: [URL: NSImage] = [:];
    
    func getImage(url: URL) -> NSImage?
    {
        if self.cache.keys.contains(url)
        {
            return self.cache[url];
        }
        
        return cacheImage(url: url);
    }
    
    func cacheImage(url: URL) -> NSImage?
    {
        return NSImage(byReferencing: url);
    }
}
