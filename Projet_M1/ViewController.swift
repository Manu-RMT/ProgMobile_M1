//
//  ViewController.swift
//  Projet_M1
//
//  Created by Manu on 05/04/2023.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var affichage_resultat: UITextView!
    @IBOutlet weak var messageBot: UILabel!
    @IBOutlet weak var nombreSasie: UITextField!
    // nombre aléatoire
    let random_combinaison : Int = Int.random(in: 1000...9999)
    var nb_essaie : Int = 11
   
    
    /// PERMET DE LANCER LE MASTERMIND
    @IBAction func valideChoice(_ sender: Any) {
        var error_message : String! = ""
        let val = Int(nombreSasie.text!) ?? 0
        
        
        // non int
        if (val == 0) {
            error_message = "Valeur acceptée : nombre"
            
        }
        
        // hors 1000 et 9999
        if (1000 > val) || (val > 9999) {
            error_message = "La combinaison doit être de 4 chiffres, compris entre 1000 et 9999"
        }
        
        // error message
        if (error_message != "") {
            AlerteMessage("Saisie incorrecte",error_message)
            return
        }
        
        nb_essaie -= 1
        // on met la combinaison dans un tableau
        var combinaison = String(random_combinaison).compactMap{ $0.wholeNumberValue }
        var combinaison_sasie = String(val).compactMap{ $0.wholeNumberValue }
        var comb_secret_copie = combinaison_sasie
        
        // type de chiffre
        var bien_place : Int! = 0
        var mal_place : Int!  = 0
        var faux : Int! = 0
        
        // Vérification les nombres identiques
        for i in 0...3 {
            if combinaison[i] == comb_secret_copie[i] {
                bien_place += 1
                comb_secret_copie[i] = -1 // on change la valeur des OK
                combinaison[i] = -2
            }
            
            var n : Int = 0
            for j in combinaison {
                if j == comb_secret_copie[i]{
                    mal_place += 1
                    comb_secret_copie[i] = -1
                    combinaison[n] = -2
                }
                n += 1
            }
        }
        
        faux = 4 - (bien_place + mal_place)
        
        
        let resultat = "\(nb_essaie) _  \(combinaison_sasie[0]) | \(combinaison_sasie[1]) | \(combinaison_sasie[2]) | \(combinaison_sasie[3]) -- OK : \(bien_place!) - Mal placé : \(mal_place!) - Faux : \(faux!)"

        affichage_resultat.text = resultat + "\r" + affichage_resultat.text
       
        
        
        
        
        
        
        
        
    }
    
    
    // pop-up en cas d'erreur
    func AlerteMessage(_ titre : String,_ message : String) {
        
        // create alert
        let alert = UIAlertController(title: titre, message: message, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    

}

