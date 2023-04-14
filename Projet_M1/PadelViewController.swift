//
//  PadelViewController.swift
//  Projet_M1
//
//  Created by Manu on 14/04/2023.
//

import UIKit

class PadelViewController: UIViewController {
    var trajectoire = CGPoint(x: 0.5, y: 3) // trajectoire balle horizentale et verticale
    var timer : Timer!
    var perdu : Bool = false

    @IBOutlet weak var balle: UIImageView!
    @IBOutlet weak var raquette_J1: UIImageView!
    
    
    @objc func lancement_game(t: Timer) {
        var pos_balle : CGPoint = balle.frame.origin                 // position balle
        let size_balle = balle.frame.size                           // taille de la balle
        let size_screen = self.view.frame.size                     // taille de l'ecran
        let pos_raquette : CGPoint  = raquette_J1.frame.origin     // position de la raquette
        let size_raquette = raquette_J1.frame.size                 // taille de la raquette
        
        // permet de bouger la balle
        pos_balle.x += trajectoire.x
        pos_balle.y += trajectoire.y
        
        balle.frame.origin = pos_balle // bouge la balle
        
        if pos_balle.x + size_balle.width > size_screen.width || pos_balle.x < 0 // rebond à gauche ou à droite
        {
           trajectoire.x = -trajectoire.x
        }
        if pos_balle.y < 0 // rebond sur le plafond
        {
           trajectoire.y = -trajectoire.y
        }
        
        // test le rebond donc non-perdu et la balle est elle en dessous de la raquette
        // perdu permet de ne pas retester la balle si elle ne touche pas la raquette
        if !perdu && (pos_balle.y + size_balle.height > pos_raquette.y) {  // est-ce que la balle est entrain de dépasser la raquettte en Y ?
            // si oui on regarde si la balle est entre la raquette et on inverse la trajectoire de la balle
            if (pos_balle.x + size_balle.width > pos_raquette.x) && (pos_balle.x < pos_raquette.x + size_raquette.width) {
                trajectoire.y = -trajectoire.y
            } else {
                perdu = true // on a perdu la balle
            }
        }
        
        // si balle dépasse le bas de l'ecran
        if (pos_balle.y > size_screen.height + 100) {
            perdu = false
            balle.frame.origin = CGPoint(x: (size_screen.width / 2) , y: (size_screen.height / 2)) // on remet la balle au centre
        }
        
    }
    
    // permet de localiser le doigt sur l'ecran avec un click
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let doigt :UITouch = touches.randomElement()!
        let pos_doigt = doigt.location(in: self.view) // position du doigt sur l'ecran
        raquette_J1.center.x = pos_doigt.x
        
    }
    
    // permet de localiser le doigt sur l'ecran en glisant (faut les deux)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let doigt :UITouch = touches.randomElement()!
        let pos_doigt = doigt.location(in: self.view) // position du doigt sur l'ecran
        raquette_J1.center.x = pos_doigt.x
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(lancement_game), userInfo: nil, repeats: true)
        
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
