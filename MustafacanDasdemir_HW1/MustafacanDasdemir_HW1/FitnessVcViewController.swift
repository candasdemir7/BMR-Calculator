//
//  FitnessVcViewController.swift
//  HomeworkCan
//
//  Created by Can Daşdemir on 17.10.2024.
//

import UIKit

class FitnessVcViewController: UIViewController, UIPickerViewDelegate , UIPickerViewDataSource {
    
    @IBOutlet weak var height: UITextField!
    
    @IBOutlet weak var weight: UITextField!
    
    @IBOutlet weak var heightUnits: UISegmentedControl!
    
    @IBOutlet weak var weightUnits: UISegmentedControl!
    
    @IBOutlet weak var genderValue: UISwitch!    
    
    //labels
    @IBOutlet weak var HeightLabel: UILabel!
    
    @IBOutlet weak var WeightLabel: UILabel!
    
    @IBOutlet weak var AgeLabel: UILabel!
    
    @IBOutlet weak var GenderLabel: UILabel!
    

    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        PickerView.delegate = self
        PickerView.dataSource = self
           
           // Verileri yükle
          // loadActivityData()
        
            let bundle = Bundle.main
        
            if let url = bundle.url(forResource: "types", withExtension: "plist") {
            plistArray = NSMutableArray(contentsOf: url)!
            mArray = Array(plistArray as! [String])
            print(mArray)
        }
        
        
        height.keyboardType = .decimalPad
        weight.keyboardType = .decimalPad
                
        // View'ye bir tap gesture recognizer ekleyerek klavyeyi kapat
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
           view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    
    //Hide keyboard
    @objc func hideKeyboard() {
        // Klavyeyi kapat
        view.endEditing(true)
    }
    

    //switch
    
    
    @IBAction func onValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            GenderLabel.text = "Gender (male):"
        } else {
            GenderLabel.text = "Gender (female):"
        }
    }
    
    
    
    //slider
    var currentValue: Int = 0
    @IBAction func AgeSlider(_ sender: UISlider) {
        
        currentValue = Int(sender.value)
        sender.value = Float(currentValue)
        AgeLabel.text = ("Age (\(currentValue)) years:")
        
        //  self.height.resignFirstResponder()
        // self.weight.resignFirstResponder()
    }
    
    //segmented
    
    @IBAction func onSegmentChangedHeight(_ sender: Any) {
        switch heightUnits.selectedSegmentIndex {  // switch sender.selectedSegmentIndex
        case 0:
            HeightLabel.text = "Height (cm)"
            height.placeholder = "cm"
            
        case 1:
            HeightLabel.text = "Height (inch)"
            height.placeholder = "inch"
            
        case 2:
            HeightLabel.text = "Height (feet)"
            height.placeholder = "feet"
            
        default:
            break
        }
        
    }
    
    //weight segmented
    
    @IBAction func onSegmentedChangedWeight(_ sender: Any) {
        
        switch weightUnits.selectedSegmentIndex {  // switch sender.selectedSegmentIndex
        case 0:
            WeightLabel.text = "Weight (kg)"
            weight.placeholder = "kg"
            
        case 1:
            WeightLabel.text = "Weight (ibs)"
            weight.placeholder = "ibs"
            
        case 2:
            WeightLabel.text = "Weight (stone)"
            weight.placeholder = "stone"
            
        default:
            break
        }
        
    }
    
    //pickerView
    @IBOutlet weak var PickerView: UIPickerView!
    
    var plistArray: NSMutableArray = []
    var mArray = [String]()
    var pickerValue: String = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return plistArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedItem = plistArray[row] as! String
        pickerValue = selectedItem
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (plistArray[row] as! String)
    }
    
    
    
    //CALCULATE
    var cm: Double = 0.0
    var inch: Double = 0.0
    var feet: Double = 0.0
    var heightt: Double = 0.0
    
    var kg: Double = 0.0
    var lbs: Double = 0.0
    var stone: Double = 0.0
    var weightt: Double = 0.0
    
    var age: Int = 0
    var bmr: Double = 0.0
    
    var calc: Double = 0.0
    var result: Double = 0.0
    
    var genderString: String = ""
    
    @IBAction func calculateBMR(_ sender: UIButton) {
        if height.text?.isEmpty == true || weight.text?.isEmpty == true {
            result = 0.0
        } else {
            if heightUnits.selectedSegmentIndex == 0 {
                heightt = Double(height.text!) ?? 0.0
            } else if heightUnits.selectedSegmentIndex == 1 {
                inch = Double(height.text!) ?? 0.0
                heightt = inchToCm(inch: inch)
            } else if heightUnits.selectedSegmentIndex == 2 {
                feet = Double(height.text!) ?? 0.0
                heightt = feetToCm(feet: feet)
            }

            if weightUnits.selectedSegmentIndex == 0 {
                weightt = Double(weight.text!) ?? 0.0
            } else if weightUnits.selectedSegmentIndex == 1 {
                lbs = Double(weight.text!) ?? 0.0
                weightt = lbsToKg(lbs: lbs)
            } else if weightUnits.selectedSegmentIndex == 2 {
                stone = Double(weight.text!) ?? 0.0
                weightt = stoneToKg(stone: stone)
            }

            
            
            age = currentValue

            if genderValue.isOn {
                calc = bmrMaleCalc(weight: weightt, height: heightt, age: age)
                genderString = "Male"
            } else {
                calc = bmrFemaleCalc(weight: weightt, height: heightt, age: age)
                genderString = "Female"
            }

            //fonsiyona götürür
            result = bmrMultiplier(activity: pickerValue, bmr: calc)
        
        
    }
        let mAlert = UIAlertController(
            title: "BMR Result",
            message: "BMR(\(genderString)) = \(String(format: "%.2f", result))",
            preferredStyle: .alert 
        )
        mAlert.addAction(UIAlertAction(title: "Close", style: .destructive, handler: nil))
        
        self.present(mAlert, animated: true, completion: nil)
    }
        
        
        
        
        //Methods
        
        func inchToCm(inch: Double) -> Double{
            return inch * 2.54
        }
        
        func feetToCm(feet: Double) -> Double{
            return feet * 30.48
        }
        
        func lbsToKg(lbs: Double) -> Double{
            return lbs * 0.4535
        }
        
        func stoneToKg(stone: Double) -> Double{
            return stone * 6.3503
        }
        
        func bmrFemaleCalc(weight: Double, height: Double, age: Int) -> Double{
            return 655 + 9.6 * weightt + 1.8 * heightt - 4.7 * Double(age)
        }
        
        func bmrMaleCalc(weight: Double, height: Double, age: Int) -> Double{
            return 66 + 13.7 * weightt + 5 * heightt - 6.8 * Double(age)
        }
        
        func bmrMultiplier(activity: String, bmr : Double) -> Double{
            
            var bmrActivityResult: Double = 0.0
            
            switch activity {
            case "Not active":
                bmrActivityResult = bmr * 1.0
            case "Lightly active":
                bmrActivityResult = bmr * 1.375
            case "Moderately active":
                bmrActivityResult = bmr * 1.55
            case "Very active":
                bmrActivityResult = bmr * 1.725
            case "Extremely active":
                bmrActivityResult = bmr * 1.9
            default:
                break
            }
            return bmrActivityResult
        }
        
  
        
    
    //Segue
    
    @IBAction func goBackToFitnesVcc(_ sender: UIStoryboardSegue) {
    }
    
        
        
        
    //For segue
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        guard let AboutVc = segue.destination as? AboutViewController else
//        {return}
//    }
    
    
    
    
//       // MARK: - View Load
//        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//            self.view.endEditing(true)
//        }
}
