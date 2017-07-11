//
//  ViewController.swift
//  Velha
//
//  Created by Allan on 10/07/17.
//  Copyright © 2017 Allan. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblGameResult: UILabel!
    
    @IBAction func refresh(_ sender: Any) {
        startNewGame()
    }
    
    @IBAction func changeGameMode(_ sender: UIBarButtonItem) {
        if sender.title == "1 Jogador"{
            sender.title = "2 Jogadores"
            playingVSIA = false
        }
        else{
            sender.title = "1 Jogador"
            playingVSIA = true
        }
    }
    
    var playingVSIA = true
    var activePlayer: Mark = .cross
    var isGameActive = true
    var board: [Mark] = [Mark]()
    
    let line = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self,selector:  #selector(deviceDidRotate),name: .UIDeviceOrientationDidChange,object: nil)
        
        startNewGame()
    }
    
    func deviceDidRotate() {
        collectionView.reloadData()
    }
    
    func startNewGame(){
        
        lblGameResult.text = ""
        activePlayer = .cross
        isGameActive = true
        lblGameResult.isHidden = true
        
        board.removeAll()
        for _ in 0...8 {
            board.append(Mark.empty)
        }
        line.removeFromSuperlayer()
        collectionView.reloadData()
    }

    func markPosition(forIndexPath indexPath: IndexPath){
        if isGameActive && board[indexPath.item] == Mark.empty{
            if activePlayer == .cross{
                board[indexPath.item] = activePlayer
                activePlayer = .circle
                
                if playingVSIA{
                    Strategy.choosePositionForBoard(board, completion: { [weak self](position) in
                        let index = IndexPath(item: position, section: 0)
                        self?.markPosition(forIndexPath: index)
                    })
                }
                
            }
            else{
                board[indexPath.item] = Mark.circle
                activePlayer = .cross
            }
            collectionView.reloadItems(at: [indexPath])
        }
        
        if let winner = Result.checkResultForBoard(board){
            if winner.winner == Mark.cross{
                lblGameResult.text = "❌ GANHOU!"
            }
            else{
                lblGameResult.text = "⭕️ GANHOU!"
            }
            isGameActive = false
            lblGameResult.isHidden = false
            drawLine(withCombination: winner.winningCombination)
            return
        }
        
        if isGameActive && !board.contains(Mark.empty){
            lblGameResult.text = "XIII DEU 👵🏻"
            isGameActive = false
            lblGameResult.isHidden = false
        }
    }
    
    //MARK: - Line
    
    func drawLine(withCombination combination: [Int]){

        let path = UIBezierPath()
        
        if combination == [0,4,8]{// \
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: collectionView.contentSize.width, y: collectionView.contentSize.width))
        }
        else if combination == [2,4,6]{ // /
           path.move(to: CGPoint(x: collectionView.contentSize.width, y: 0))
           path.addLine(to: CGPoint(x: 0, y: collectionView.contentSize.height))
        }
        else if combination == [0,1,2] || combination == [3,4,5] || combination == [6,7,8]{ // -
            let firstCell = collectionView.cellForItem(at: IndexPath(item: combination[0], section: 0))
            let height = firstCell!.frame.origin.y + firstCell!.contentView.frame.size.height / 2
            path.move(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: collectionView.contentSize.width, y: height))
        }
        else if combination == [0,3,6] || combination == [1,4,7] || combination == [2,5,8]{ // |
            let firstCell = collectionView.cellForItem(at: IndexPath(item: combination[0], section: 0))
            let width = firstCell!.frame.origin.x + firstCell!.frame.size.width / 2
            path.move(to: CGPoint(x: width, y: 0))
            path.addLine(to: CGPoint(x: width, y: collectionView.contentSize.height))
        }
        
        
        line.path = path.cgPath
        line.strokeColor = UIColor.lightGray.cgColor
        line.lineWidth = 6.0
        collectionView.layer.addSublayer(line)
    }
    
}

//MARK: - CollectionView Datasource and Delegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellMark", for: indexPath)
        let state = board[indexPath.item]
        
        
        let imageView = UIImageView(image: UIImage(named: state.rawValue))
        imageView.contentMode = .scaleAspectFit
        cell.backgroundView = imageView
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        markPosition(forIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3 - 1, height: collectionView.frame.size.width/3 - 1)
    }
}

