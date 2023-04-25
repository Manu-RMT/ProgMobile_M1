//
//  MasterMindViewController.swift
//  Projet_M1
//
//  Created by Manu RAMANITRA on 05/04/2023.
//

import UIKit
import AVFoundation

class MasterMindViewController: UIViewController {
    
    @IBOutlet weak var affichage_resultat: UITextView!
    @IBOutlet weak var messageBot: UILabel!
    @IBOutlet weak var nombreSasie: UITextField!
    @IBOutlet weak var libelleNbSaisie: UILabel!
    @IBOutlet weak var button_reload_game: UIButton!
    @IBOutlet weak var img_win: UIImageView!
    @IBOutlet weak var img_loose: UIImageView!
    
    
    // nombre aléatoire
    var random_combinaison : Int = Int.random(in: 1000...9999)
    var nb_essaie : Int = 10
    var fond_game : AVAudioPlayer?
   
    
    /// PERMET DE LANCER LE MASTERMIND
    @IBAction func valideChoice(_ sender: Any) {
        var error_message : String! = ""
        let val = Int(nombreSasie.text!) ?? 0
        
        
        // non int
        if (val == 0) {
            error_message = "Valeur acceptée : nombre"
            
        }
        
        // hors 1000 et 9999
        if  val != 0 && ((val < 1000) || (val > 9999)){
            error_message = "La combinaison doit être de 4 chiffres, compris entre 1000 et 9999"
        }
        
        // error message
        if (error_message != "") {
            AlerteMessage("Saisie incorrecte",error_message)
            return
        }
        
        // on met la combinaison dans un tableau
        let combinaison = String(random_combinaison).compactMap{ $0.wholeNumberValue }
        let combinaison_sasie = String(val).compactMap{ $0.wholeNumberValue }
        var comb_saisie_copie = combinaison_sasie // copie pour traitement
        var comb_secret_copie = combinaison // copie pour traitement
        
        // type de chiffre
        var bien_place : Int! = 0
        var mal_place : Int!  = 0
        var faux : Int! = 0
        
        for i in 0...3 {
            // Vérification les nombres identiques
            if comb_secret_copie[i] == comb_saisie_copie[i] {
                bien_place += 1
                comb_saisie_copie[i] = -1 // on change la valeur des bonnes valeurs pour ne plus les traiter dans le test suivant
                comb_secret_copie[i] = -2
            }
            
            // Vérification des chiffres mal placé
            var n : Int = 0
            for j in comb_secret_copie {
                if j == comb_saisie_copie[i]{
                    mal_place += 1
                    comb_saisie_copie[i] = -1
                    comb_secret_copie[n] = -2
                }
                n += 1
            }
        }
        
        // chiffre faux
        faux = 4 - (bien_place + mal_place)
        
        // affichage du resultat
        let resultat = "\n\n  Essai \(nb_essaie)  :  \(combinaison_sasie[0]) | \(combinaison_sasie[1]) | \(combinaison_sasie[2]) | \(combinaison_sasie[3]) \r  OK : \(bien_place!) - Mal placé : \(mal_place!) - Faux : \(faux!) \n --------------------------------------------"

        affichage_resultat.text = affichage_resultat.text + "\r" + resultat
        nb_essaie -= 1 // on met le compteur à 10 et on enlève 1 à chaque fois
        let range = NSRange(location: affichage_resultat.text.count - 1, length: 0)
        affichage_resultat.scrollRangeToVisible(range)
        libelleNbSaisie.text = "Il vous reste \(nb_essaie) tentative(s)"
        
        // Dans le cs ou il n'a pas trouvé la combinaison
        if nb_essaie == 0 {
            messageBot.text = "Vous avez utiliser toutes vos tentatives. \n La réponse était : \(random_combinaison)"
            desactivate_game(win: false)
        }
        
        // Dans le cas ou il  a trouvé la combinaision
        if bien_place == 4 && nb_essaie > 1 {
            messageBot.text = "Bravo la combinaision était bien : \(random_combinaison)"
            desactivate_game(win: true)
            
        }
        
        print(combinaison)
        nombreSasie.text = nil // on remet la zone de saisie à nil
        
    }
    
    // relance une nouvelle partie
    @IBAction func reload_game(_ sender: Any) {
        messageBot.text = "Bonjour les MasterMinder"
        activate_game()
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
    
    // desactive les elements de la partie
    func desactivate_game(win : Bool){
        if win == true {
            print("gagne")
            img_win.isHidden = false
        }else {
            img_loose.isHidden = false
        }
        nombreSasie.isHidden = true
        libelleNbSaisie.isHidden = true
        affichage_resultat.isHidden = true
        button_reload_game.isHidden = false
    }
    
    // active les éléments de la partie
    func activate_game(){
        nombreSasie.isHidden = false
        libelleNbSaisie.isHidden = false
        affichage_resultat.isHidden = false
        button_reload_game.isHidden = true
        img_win.isHidden = true
        img_loose.isHidden = true
        affichage_resultat.text = nil
        libelleNbSaisie.text = "Je tente"
        nb_essaie = 10
        random_combinaison = Int.random(in: 1000...9999)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // permet d'effacer le clavier après la saisie d'une valeur
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)
        // bruit de fond
        ajout_bruit("bruit_mastermind", "mp3", bruit: &fond_game)
        fond_game!.play()
        
    }
}
