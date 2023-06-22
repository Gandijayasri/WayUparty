//
//  DatePickerViewController.swift
//  Jananetha
//
//  Created by jasty saran on 14/02/20.
//  Copyright © 2020 jasty saran. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {// Added condition for iOS 14
             datePicker.preferredDatePickerStyle = .compact
        }
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd/MM/yyyy"
           dobOfUser = dateFormatter.string(from: sender.date)
           signUpDOB = dateFormatter.string(from: sender.date)
           print(dobOfUser)
           print(signUpDOB)
       }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        view.removeFromSuperview()
        removeFromParent()
        print(dobOfUser)
        print(signUpDOB)
    }
}
