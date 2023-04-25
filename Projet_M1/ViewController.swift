//
//  ViewController.swift
//  Projet_M1
//
//  Created by Manu RAMANITRA on 05/04/2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // retour vers la page d'accueil
    @IBAction func PageAccueil(_ for : UIStoryboardSegue) {
    }
}

// extension de la view IUViewController qui permet de lire les audios
extension UIViewController {
    func ajout_bruit(_ path_file: String,_ extension_file: String , bruit: inout AVAudioPlayer!) {
        let path = Bundle.main.path(forResource: path_file, ofType: extension_file)!
        let url_balle = URL(fileURLWithPath: path)
        
        do {
            bruit = try AVAudioPlayer(contentsOf: url_balle)
        } catch{
            print("Erreur lancement bruit")
        }
    }
}
