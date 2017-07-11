//
//  Strategy.swift
//  Velha
//
//  Created by Allan on 11/07/17.
//  Copyright © 2017 Allan. All rights reserved.
//

import Foundation

public enum Mark: String {
    case empty = "-"
    case cross = "x"
    case circle = "o"
}

public typealias Marks = [Mark]

public final class Strategy {
    
    static func choosePositionForBoard(_ board: Marks, completion: (_ positionForMark: Int) -> Void){
        
        var hasMoved = false
        
        //Verifique se consigue ganhar, se sim, retornar a marca
        for i in 0..<board.count{
            var cloneBoard = board
                if cloneBoard[i] == Mark.empty{
                    cloneBoard[i] = Mark.circle //Marca da AI
                    if let _ = Result.checkResultForBoard(cloneBoard){
                        completion(i)
                        hasMoved = true
                        break
                    }
                }
        }
        
        if !hasMoved{
            //Verifique se o adversário pode ganhar, se sim, bloquear!
            for i in 0..<board.count{
                var cloneBoard = board
                if cloneBoard[i] == Mark.empty{
                    cloneBoard[i] = Mark.cross //Marca da AI
                    if let _ = Result.checkResultForBoard(cloneBoard){
                        completion(i)
                        hasMoved = true
                        break
                    }
                }
            }
        }
        
        
        if !hasMoved{
            //Se o centro estiver em branco, jogar nele!
            var cloneBoard = board
            if cloneBoard[4] == Mark.empty{
                completion(4)
                hasMoved = true
            }
        }
        
        if !hasMoved{
            //Se o adversário jogar em uma ponta e as outras duas estiverem livres, bloquear jogando na outra ponta!
            for combination in Result.winningCombinations{
                
                if (board[combination[0]] == Mark.cross && board[combination[1]] == Mark.empty && board[combination[2]] == Mark.empty){
                    completion(combination[2])
                    hasMoved = true
                    break
                }
                else if (board[combination[0]] == Mark.empty && board[combination[1]] == Mark.empty && board[combination[2]] == Mark.cross){
                    completion(combination[0])
                    hasMoved = true
                    break
                }
            }
        }
        
        if !hasMoved{
            //Se há alguma ponta livre, jogar em alguma ponta
            if board[0] == Mark.empty{
                completion(0)
                hasMoved = true
            }
            else if board[2] == Mark.empty{
                completion(2)
                hasMoved = true
            }
            else if board[8] == Mark.empty{
                completion(8)
                hasMoved = true
            }
        }
        
        if !hasMoved{
            //Se há alguma posição livre, jogar nela
            if let index = board.index(of: Mark.empty){
                completion(index)
                hasMoved = true
            }
        }
        
    }
    
}
