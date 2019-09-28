//
//  GameTableViewController.swift
//  MyCows
//
//  Created by Kyle Thompson on 9/4/19.
//  Copyright © 2019 Kyle Thompson. All rights reserved.
//

import UIKit


class PlayerCardTableViewCell: UITableViewCell {
    @IBOutlet var playerImage: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cowsLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var beaverButton: UIButton!
    
    @IBOutlet var slider: UISlider!
    @IBOutlet var sliderLabel: UILabel!
    
    var delegate: PlayerCardCellDelegate?
    var sliderVal: Float = 0
    
    
    @IBAction func sliderChange(_ sender: Any) {
        sliderVal = round(pow(10.0, slider.value))
        sliderLabel.text = String(sliderVal)
    }
    
    @IBAction func addOnClick(_ sender: UIButton) {
        delegate?.didTapAddCows(sender: self)
    }
    @IBAction func beaverOnClick(_ sender: UIButton) {
        delegate?.didTapBeaver(sender: self)
    }
    
}

class GameTableViewController: UITableViewController {
    
    var appDelegate: AppDelegate!
    var game: Game!
    var activeRow: Int = -1;
    
    var isBeaverActive: Bool = false;
    var beaverActiveRow: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        game = appDelegate.game
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerCardTableViewCell
       
        let player =  game.players[indexPath.row]
        
        cell.nameLabel.text = player.name
        cell.cowsLabel.text = String(player.cowCount)
        
        cell.tag = indexPath.row
        
        cell.delegate = self
        
        cell.slider.minimumValue = 0
        cell.slider.maximumValue = 3
        cell.slider.value = 0;
        cell.sliderLabel.text  = String(0);
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if isBeaverActive  {
            isBeaverActive = false;
            
            let player = game.players[beaverActiveRow!.row]
            let subject = game.players[indexPath.row]
            
            let numCows = subject.cowCount / 2;
            
            let playerCell = tableView.cellForRow(at: beaverActiveRow!)!
            let subjectCell = tableView.cellForRow(at: indexPath)!
            
            let rStart:CGFloat = playerCell.frame.width / 4;
            let endPoint = CGPoint(x: playerCell.frame.midX, y: playerCell.frame.midY)
            
            anim_cows(numCows: numCows, xOrigin: subjectCell.frame.midX, yOrigin: subjectCell.frame.midY, rStart: rStart, endPoint: endPoint, completion: {(() -> Void).self})
            
            self.game.performGameAction(action: Action.GameAction.BEAVER,
                                        player: player, subject: subject);
            
            DispatchQueue.main.async { self.tableView.reloadData() }
            
        } else {
            activeRow = indexPath.row == activeRow ? -1 : indexPath.row;
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == activeRow {
            return 150;
        } else {
            return 100;
        }
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol PlayerCardCellDelegate {
    func didTapAddCows(sender: PlayerCardTableViewCell)
    func didTapBeaver(sender: PlayerCardTableViewCell)
    
}

extension GameTableViewController: PlayerCardCellDelegate {
    
    func didTapAddCows(sender: PlayerCardTableViewCell) {

        let player = game.players[sender.tag]
        func completion () -> Void {
            self.game.performGameAction(action: Action.GameAction.ADD_COWS,
                                        player: player, subject: nil, cows: 1);
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
        self.activeRow = -1;
        DispatchQueue.main.async { self.tableView.reloadData() };
            
        let xOrigin = sender.frame.midX
        let yOrigin = sender.frame.midY
        let rStart = sender.frame.width / 4
        let endPoint = CGPoint(x: xOrigin, y: yOrigin)
        let numCows = Int(sender.sliderVal)
        
        anim_cows(numCows: numCows, xOrigin: xOrigin, yOrigin: yOrigin, rStart: rStart, endPoint: endPoint, completion: completion)
        
    }
    
    func didTapBeaver(sender: PlayerCardTableViewCell) {
        let player = game.players[sender.tag]
        
        if isBeaverActive {
            isBeaverActive = false;
            beaverActiveRow = nil
        } else {
            isBeaverActive = true;
            beaverActiveRow = tableView.indexPath(for: sender)
        }
    }
    
    func anim_cows(numCows: Int, xOrigin: CGFloat, yOrigin: CGFloat, rStart: CGFloat, endPoint: CGPoint, completion: @escaping () -> Void) {
        
        var rads: CGFloat = CGFloat.random(in: 0 ..< 2);
        let deltaRads =   (2 * CGFloat.pi) / (CGFloat(numCows))
        
        
        for _ in 0...numCows {
            
            let xStart = xOrigin + (rStart * sin(rads));
            let yStart = yOrigin + (rStart * cos(rads));
            let startPoint = CGPoint(x: xStart, y: yStart);
            
            let rControl = rStart * (2 + CGFloat.random(in: 0 ..< 2))
            
            let xControl = xOrigin + (rControl * sin(rads));
            let yControl = yOrigin + (rControl * cos(rads));
            let controlPoint = CGPoint(x: xControl, y: yControl);
            
            let duration = 1 + Double.random(in: 0 ..< 2)
            
            create_cow(startPoint: CGPoint(x: xOrigin, y: yOrigin), controlPoint: controlPoint, endPoint: endPoint, duration: duration, completion: completion);
            
            rads += deltaRads;
        }
    }
    
    
    
    
    func create_cow(startPoint: CGPoint, controlPoint: CGPoint, endPoint: CGPoint, duration: Double, completion: @escaping () -> Void) {
        
        let square = UILabel()
        square.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        square.text = "🐮"
        self.view.addSubview(square)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            square.removeFromSuperview();
            completion();
        })
        
        let path = UIBezierPath()
        
        //set starting point for bezier curve
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        
        // create the animation
        let anim = CAKeyframeAnimation(keyPath: "position");
        anim.duration = duration;
        anim.path = path.cgPath;
        
        
        square.layer.add(anim, forKey: "animate position along path")
        CATransaction.commit()
    }
}
