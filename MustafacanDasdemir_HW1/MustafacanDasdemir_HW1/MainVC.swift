//
//  ViewController.swift
//  HomeworkCan
//
//  Created by Can Daşdemir on 16.10.2024.
//

import UIKit

class MainVC: UIViewController {
  
    
    @IBOutlet weak var mimageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mimageView.isUserInteractionEnabled = true
    }

    

    
    
    // FitnessVcdeki butonu main vcdeki exite getir, unwind segue için gerekli
    @IBAction func goBackToMainVcc(_ sender: UIStoryboardSegue) {
    }
    
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "goToFitnessVC", sender: self)

    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let mNavigationController = segue.destination as? UINavigationController {
//            if let FitnesVC = mNavigationController.viewControllers.first as? FitnessVcViewController {
//                
//         
//            }
//        }
//    }
    
    
}

