//
//  PadelViewController.swift
//  Projet_M1
//
//  Created by Manu on 14/04/2023.
//

import UIKit
import AVFoundation

class PadelViewController: UIViewController {
    var trajectoire = CGPoint(x: 0.5, y: 3) // trajectoire balle horizentale et verticale
    var timer : Timer!
    var perdu : Bool = false
    var bas_ecran_enabled = true
    var score : [Int] = [0,0]
    var joueur : String = ""
    var tape_balle : AVAudioPlayer?
    
    @IBOutlet weak var balle: UIImageView!
    @IBOutlet weak var raquette_J1: UIImageView!
    @IBOutlet weak var raquette_J2: UIImageView!
    @IBOutlet weak var tableau_score: UILabel!
    @IBOutlet weak var affichage_resultat_final: UILabel!
    @IBOutlet weak var boutoRretourHome: UIButton!
    @IBOutlet weak var boutonRetourJeu: UIButton!
    
   
    @objc func lancement_game(t: Timer) {
        tableau_score.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)

        var pos_balle : CGPoint = balle.frame.origin                 // position balle
        let size_balle = balle.frame.size                           // taille de la balle
        let size_screen = self.view.frame.size                     // taille de l'ecran
        let pos_raquette : CGPoint  = raquette_J1.frame.origin     // position de la raquette
        let size_raquette = raquette_J1.frame.size                 // taille de la raquette
        let pos_raquette2 : CGPoint  = raquette_J2.frame.origin     // position de la raquette 2
        let size_raquette2 = raquette_J2.frame.size                 // taille de la raquette 2
        
        // permet de bouger la balle
        pos_balle.x += trajectoire.x
        pos_balle.y += trajectoire.y
        
        balle.frame.origin = pos_balle // bouge la balle
        
        if pos_balle.x + size_balle.width > size_screen.width || pos_balle.x < 0 // rebond à gauche ou à droite
        {
           trajectoire.x = -trajectoire.x
        }
        
        // gestion tour des joueurs de jouer
        if bas_ecran_enabled { // joueur du bas
            // test le rebond donc non-perdu et la balle est elle en dessous de la raquette
            // perdu permet de ne pas retester la balle si elle ne touche pas la raquette
            if !perdu && (pos_balle.y + size_balle.height > pos_raquette.y) {  // est-ce que la balle est entrain de dépasser la raquettte en Y ?
                // si oui on regarde si la balle est entre la raquette et on inverse la trajectoire de la balle
                if (pos_balle.x + size_balle.width > pos_raquette.x) && (pos_balle.x < pos_raquette.x + size_raquette.width) {
                    trajectoire.y = -trajectoire.y
                    bas_ecran_enabled = false // au tour de l'autre de jouer
                    tape_balle!.play()
                } else {
                    perdu = true // on a perdu la balle
                    score[0] += 1
                }
            }
            
        }
        else { // joueur du haut
            if !perdu && (pos_balle.y < pos_raquette2.y) {  // est-ce que la balle est entrain de dépasser la raquettte en Y ?
                // si oui on regarde si la balle est entre la raquette et on inverse la trajectoire de la balle
                if (pos_balle.x + size_balle.width > pos_raquette2.x) && (pos_balle.x < pos_raquette2.x + size_raquette2.width) {
                    trajectoire.y = -trajectoire.y
                    bas_ecran_enabled = true
                    tape_balle!.play()
                } else {
                    perdu = true // on a perdu la balle
                    score[1] += 1
                }
            }
        }
        
        
        // si balle dépasse le bas de l'ecran ou le haut de l'ecran
        if (pos_balle.y > size_screen.height + 100) || (pos_balle.y < -100){
            tableau_score.text = "Score \(score[0]) - \(score[1])"
            perdu = false
            balle.frame.origin = CGPoint(x: (size_screen.width / 2) , y: (size_screen.height / 2)) // on remet la balle au centre
        }
        
        
        // gestion fin du jeu
        if score[0] == 10 {
            affichage_resultat_final.isHidden = false
            boutonRetourJeu.isHidden = false
            boutoRretourHome.isHidden = false
            balle.isHidden = true
            tableau_score.isHidden = true
            joueur = "Victoire du joueur A : \(score[0]) - \(score[1])"
            
        }
        if score[1] == 10 {
            affichage_resultat_final.isHidden = false
            boutonRetourJeu.isHidden = false
            boutoRretourHome.isHidden = false
            balle.isHidden = true
            tableau_score.isHidden = true
            joueur = "Victoire du joueur B : \(score[1]) - \(score[0])"
            
        }
        
        affichage_resultat_final.text = joueur
    }
    
    
    // permet de localiser le doigt sur l'ecran avec un click
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let doigt :UITouch = touches.randomElement()!
        let pos_doigt = doigt.location(in: self.view) // position du doigt sur l'ecran
        
        // qui joue ?
        if bas_ecran_enabled {
            raquette_J1.center.x = pos_doigt.x
        }
        else {
            raquette_J2.center.x = pos_doigt.x
          
        }
        
        
    }
    
    // permet de localiser le doigt sur l'ecran en glisant (faut les deux)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let doigt :UITouch = touches.randomElement()!
        let pos_doigt = doigt.location(in: self.view) // position du doigt sur l'ecran
        
        // qui joue ?
        if bas_ecran_enabled {
            raquette_J1.center.x = pos_doigt.x
        }
        else {
            raquette_J2.center.x = pos_doigt.x
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(lancement_game), userInfo: nil, repeats: true)
        
        let path = Bundle.main.path(forResource: "bruit_balle_tennis", ofType:"mp3")!
        let url_balle = URL(fileURLWithPath: path)
        
        do {
            tape_balle = try AVAudioPlayer(contentsOf: url_balle)
        } catch{
            print("Erreur lancement bruit")
        }
    
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
