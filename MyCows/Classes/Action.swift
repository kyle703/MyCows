//
//  Action.swift
//  MyCows
//
//  Created by Kyle Thompson on 3/10/19.
//  Copyright © 2019 Kyle Thompson. All rights reserved.
//

import Foundation



class Action {
    enum GameAction {
        case ADD_COWS
        case REMOVE_COWS
        case SET_COWS
        case BEAVER
    }
    
    class func add_cows (player: Player, cows: Int) {
        player.cowCount += cows;
        player.cowTotal += cows;
    }
    
    class func remove_cows (player: Player, cows: Int) {
        if (player.cowCount < cows) {
            player.cowCount = 0
        } else {
            player.cowCount -= cows;
        }
    }
    
    class func set_cows (player: Player, cows: Int) {
        player.cowCount = cows;
    }
    
    class func beaver (recipient: Player, donor: Player) {
        let splitCows = donor.cowCount / 2;
        recipient.cowCount += splitCows;
        donor.cowCount -= splitCows;
    }
    
}
