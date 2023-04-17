//
//  MasterMindViewController.swift
//  Projet_M1
//
//  Created by Manu on 14/04/2023.
//

import UIKit

class MasterMindViewController: UIViewController {
    
    // combinaison
    @IBOutlet weak var bleu: UIImageView!
    @IBOutlet weak var jaune: UIImageView!
    @IBOutlet weak var orange: UIImageView!
    @IBOutlet weak var rouge: UIImageView!
    @IBOutlet weak var vert: UIImageView!
    
    
    // case pour les choix
    @IBOutlet weak var case1: UIImageView!
    @IBOutlet weak var case2: UIImageView!
    @IBOutlet weak var case3: UIImageView!
    @IBOutlet weak var case4: UIImageView!
    @IBOutlet weak var case5: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    var combinaison : [Any] = [Int.random(in: 1...5),Int.random(in: 1...5),Int.random(in: 1...5),Int.random(in: 1...5),Int.random(in: 1...5)]
    var reponse : [Any] = [0,0,0,0,0]

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let doigt :UITouch = touches.randomElement()!
        let pos_doigt = doigt.location(in: self.view) // position du doigt sur l'ecran
        
        if (bleu.frame.origin.x + bleu.frame.width > pos_doigt.x) && (pos_doigt.x > bleu.frame.origin.x) &&
           (bleu.frame.origin.y + bleu.frame.height > pos_doigt.y) && (pos_doigt.y > bleu.frame.origin.y) {
            bleu.center = pos_doigt
        }
            
        
    }
    
    // permet de localiser le doigt sur l'ecran en glisant (faut les deux)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let doigt :UITouch = touches.randomElement()!
        let pos_doigt = doigt.location(in: self.view) // position du doigt sur l'ecran
        
        if (bleu.frame.origin.x + bleu.frame.width > pos_doigt.x) && (pos_doigt.x > bleu.frame.origin.x) &&
           (bleu.frame.origin.y + bleu.frame.height > pos_doigt.y) && (pos_doigt.y > bleu.frame.origin.y) {
            bleu.center = pos_doigt
        }
       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let doigt :UITouch = touches.randomElement()!
        let pos_doigt = doigt.location(in: self.view) // position du doigt sur l'ecran
        if (case1.frame.origin.x + case1.frame.width > pos_doigt.x) && (pos_doigt.x > case1.frame.origin.x) &&
           (case1.frame.origin.y + case1.frame.height > pos_doigt.y) && (pos_doigt.y > case1.frame.origin.y) {
            case1.backgroundColor = bleu.backgroundColor
        
        }
    }
    
   
    @IBAction func valide(_ sender: Any) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
