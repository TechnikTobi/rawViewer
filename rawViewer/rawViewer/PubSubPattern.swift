//
//  PubSubPattern.swift
//  rawViewer
//
//  Created by Tobias Prisching on 05.10.23.
//

import Foundation

class Publisher
{
    var observers: Set<AnyHashable> = [];
    
    func send()
    {
        for item in self.observers
        {
            (item as? Observer)?.observerUpdate()
        }
    }
    
    func insert<T>(_ item: T) where T: Observer, T: Hashable
    {
        self.observers.insert(AnyHashable(item))
    }
    
    func remove<T>(_ item: T) where T: Observer, T: Hashable
    {
        self.observers.remove(AnyHashable(item))
    }
}

protocol Observer
{
    func observerUpdate();
}
