//
//  DeltaCoreProtocol+Delta.swift
//  Delta
//
//  Created by Riley Testut on 4/30/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

import DeltaCore

import NESDeltaCore
import SNESDeltaCore
import GBCDeltaCore
import GBADeltaCore
import N64DeltaCore
import MelonDSDeltaCore

import Systems

extension Delta
{
    // Legacy Cores
    static let desmumeCoreID = "com.rileytestut.DSDeltaCore"
}

@dynamicMemberLookup
struct DeltaCoreMetadata
{
    enum Key: String, CaseIterable
    {
        case name
        case developer
        case version
        case source
        case donate
        
        var localizedName: String {
            return self.rawValue.capitalized
        }
    }
    
    struct Item
    {
        var value: String
        var url: URL?
    }
    
    var name: Item { self.items[.name]! }
    private let items: [Key: Item]
    
    init?(_ items: [Key: Item])
    {
        guard items.keys.contains(.name) else { return nil }
        self.items = items
    }
    
    subscript(dynamicMember keyPath: KeyPath<Key.Type, Key>) -> Item?
    {
        let key = Key.self[keyPath: keyPath]
        return self[key]
    }
    
    subscript(_ key: Key) -> Item?
    {
        let item = self.items[key]
        return item
    }
}

extension DeltaCoreProtocol
{
    var supportedRates: ClosedRange<Double> {
        return 1...self.maximumFastForwardSpeed
    }
    
    private var maximumFastForwardSpeed: Double {
        switch self
        {
        case NES.core, SNES.core, GBC.core: return 4
        case GBA.core: return 3
        case N64.core where UIDevice.current.hasA11ProcessorOrBetter: return 3
        case N64.core where UIDevice.current.hasA9ProcessorOrBetter: return 1.5
        case MelonDS.core where UIDevice.current.hasA15ProcessorOrBetter || ProcessInfo.processInfo.isJITAvailable: return 3
        case MelonDS.core where UIDevice.current.hasA11ProcessorOrBetter: return 1.5
        case GPGX.core: return 4
        default: return 1
        }
    }
    
    var metadata: DeltaCoreMetadata? {
        switch self
        {
        case MelonDS.core:
            return DeltaCoreMetadata([.name: .init(value: NSLocalizedString("melonDS", comment: ""), url: URL(string: "http://melonds.kuribo64.net")),
                                      .developer: .init(value: NSLocalizedString("Arisotura", comment: ""), url: URL(string: "https://twitter.com/Arisotura")),
                                      .version: .init(value: NSLocalizedString("0.9.5", comment: ""), url: URL(string: "https://github.com/melonDS-emu/melonDS/releases/tag/0.9.5")),
                                      .source: .init(value: NSLocalizedString("GitHub", comment: ""), url: URL(string: "https://github.com/Arisotura/melonDS")),
                                      .donate: .init(value: NSLocalizedString("Patreon", comment: ""), url: URL(string: "https://www.patreon.com/staplebutter"))])
            
        default: return nil
        }
    }
}
