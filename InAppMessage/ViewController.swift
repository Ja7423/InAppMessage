//
//  ViewController.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.placeholder = "標題"
        titleTextField.text = "測試訊息"
        titleTextField.returnKeyType = .done
        titleTextField.delegate = self
        
        bodyTextField.placeholder = "Body"
        bodyTextField.text = "Body"
        bodyTextField.returnKeyType = .done
        bodyTextField.delegate = self
    }

    @IBAction func sendTopMessage(_ sender: UIButton) {
        titleTextField.resignFirstResponder()
        bodyTextField.resignFirstResponder()
        
        IAMessageService.show(message())
    }
    
    @IBAction func sendBottomMessage(_ sender: UIButton) {
        titleTextField.resignFirstResponder()
        bodyTextField.resignFirstResponder()
        
        IAMessageService.show(message(), at: .bottom)
    }
    
    @IBAction func presentVC(_ sender: UIButton) {
        
    }
    
    private func message() -> IAMessage {
        let title = titleTextField.text ?? ""
//        let body = bodyTextField.text ?? ""
        let body = "Line 1 \nLine 2 \nLine 3 \nLine 4"
        let image = "post"
        let info = ["test key": "test value"]
        return IAMessage(title: title, body: body, image: image, userInfo: info)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
