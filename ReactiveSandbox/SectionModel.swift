//
//  SectionModel.swift
//  ReactiveSandbox
//
//  Created by Masakazu Sano on 2018/05/04.
//  Copyright © 2018年 Masakazu Sano. All rights reserved.
//

import Foundation

public protocol SectionModelType {
    associatedtype Item
    var items: [Item] { get }
    
    init(original: Self, items: [Item])
}

public struct SectionModel<Section, ItemType> {
    public var model: Section
    public var items: [Item]
    
    public init(
        model: Section,
        items: [Item]
        ) {
        self.model = model
        self.items = items
    }
}

extension SectionModel {
    public init(
        original: SectionModel<Section, Item>,
        items: [Item]
        ) {
        self.model = original.model
        self.items = items
    }
}

extension SectionModel: SectionModelType {
    public typealias Identify = Section
    public typealias Item = ItemType
    
    public var identify: Section {
        return model
    }
}

extension SectionModel: CustomStringConvertible {
    public var description: String {
        return "\(self.model) > \(items)"
    }
}

