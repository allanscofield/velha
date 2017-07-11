//
//  Result.swift
//  Velha
//
//  Created by Allan on 11/07/17.
//  Copyright © 2017 Allan. All rights reserved.
//

import Foundation


/** Informação sobre o vencedor (se houve um) e qual foi a combinação que venceu */
public typealias Winner = (winner: Mark, winningCombination: [Int])

/** Verifica o quadro atual e retorna a marca campeã ou retorna nil se ainda não há uma campeã */
public class Result {
    
    static let winningCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    
    static func checkResultForBoard(_ board: Marks) -> Winner?{
        
        for combination in winningCombinations{
            if board[combination[0]] != Mark.empty && board[combination[0]] == board[combination[1]] && board[combination[1]] == board[combination[2]]{
                if board[combination[0]] == Mark.cross{
                    return Winner(winner: Mark.cross, winningCombination: combination)
                }
                else{
                    return Winner(winner: Mark.circle, winningCombination: combination)
                }
            }
        }
        return nil
    }
}
