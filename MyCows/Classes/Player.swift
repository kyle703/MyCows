//
//  Player.swift
//  MyCows
//
//  Created by Kyle Thompson on 3/9/19.
//  Copyright © 2019 Kyle Thompson. All rights reserved.
//

import Foundation

class Player: Codable, Comparable {
    
    var id: UUID;
    var name: String;
    var cowCount: Int {
        willSet(newCount) {
            if cowATH < newCount {
                cowATH = newCount
            }
        }
    }
    var cowATH: Int; // All-time-high player cow count
    var cowTotal: Int;
    var beaverTotal: Int;
    
    init (name: String) {
        id = UUID()
        self.name = name
        cowCount = 0
        cowTotal = 0
        beaverTotal = 0
        cowATH = 0
    }
    
    init (id: UUID, name: String, cowCount: Int, cowTotal: Int, beaverTotal: Int, cowATH: Int) {
        self.id = id
        self.name = name
        self.cowCount = cowCount
        self.cowTotal = cowTotal
        self.beaverTotal = beaverTotal
        self.cowATH = cowATH
    }
    
    static func <(lhs: Player, rhs: Player) -> Bool {
        return lhs.cowCount == rhs.cowCount ?
                lhs.name < rhs.name : lhs.cowCount > rhs.cowCount;
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
}
