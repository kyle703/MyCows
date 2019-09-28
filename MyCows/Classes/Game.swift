//
//  Game.swift
//  MyCows
//
//  Created by Kyle Thompson on 7/21/19.
//  Copyright © 2019 Kyle Thompson. All rights reserved.
//

import Foundation

class Game {
    
    var players = [Player]()
    
    enum GameErrors : Error {
        case IllegalAction
        case NoSuchPlayer
        case NoCowsArgument
    }
    
    // this is probably where the logger will live and any future sockets
    
    init () {
        players.append(Player(name: "KYLE"))
        players.append(Player(name: "SARAH"))
    }
    
    func performGameAction (action: Action.GameAction, player: Player, subject: Player?, cows: Int = 0) {
        switch action {
            case .ADD_COWS:
                Action.add_cows(player: player, cows: cows);
            case .REMOVE_COWS:
                Action.remove_cows(player: player, cows: cows);
            case .SET_COWS:
                Action.set_cows(player: player, cows: cows);
            case .BEAVER:
                if (subject == nil) { print("Subject is nil"); return; }
                let donor = subject!
                Action.beaver(recipient: player, donor: donor);
            default:
                print("Illegal Action")
        }
        players.sort();
    }
    
}
