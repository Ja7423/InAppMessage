//
//  ViewController.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.placeholder = "標題"
        titleTextField.text = "測試訊息"
        titleTextField.returnKeyType = .done
        titleTextField.delegate = self

        bodyTextField.placeholder = "Body"
        bodyTextField.returnKeyType = .done
        bodyTextField.delegate = self
    }

    @IBAction func sendTopMessage(_: UIButton) {
        titleTextField.resignFirstResponder()
        bodyTextField.resignFirstResponder()

        let config = IAMessageConfig(presentStyle: .top, duration: .seconds(2.0))
        let view = IANotifyView()
        view.setMessage(message())
        view.clickMessage { message in
            if let message = message {
                print("\(message)")
            }

            IAMessageService.hide()
        }

        IAMessageService.show(view, config: config)
    }

    @IBAction func sendBottomMessage(_: UIButton) {
        titleTextField.resignFirstResponder()
        bodyTextField.resignFirstResponder()

        let config = IAMessageConfig(presentStyle: .bottom, duration: .auto)
        let view = IANotifyView()
        view.setMessage(message())
        view.clickMessage { message in
            if let message = message {
                print("\(message)")
            }

            IAMessageService.hide()
        }

        IAMessageService.show(view, config: config)
    }

    @IBAction func topForever(_: UIButton) {
        titleTextField.resignFirstResponder()
        bodyTextField.resignFirstResponder()

        let config = IAMessageConfig(presentStyle: .top, duration: .forever)
        let view = IANotifyView()
        view.setMessage(message())
        view.clickMessage { message in
            if let message = message {
                print("\(message)")
            }

            IAMessageService.hide()
        }

        IAMessageService.show(view, config: config)
    }

    @IBAction func bottomForever(_: UIButton) {
        titleTextField.resignFirstResponder()
        bodyTextField.resignFirstResponder()

        let config = IAMessageConfig(presentStyle: .bottom, duration: .forever)
        let view = IANotifyView()
        view.setMessage(message())
        view.clickMessage { message in
            if let message = message {
                print("\(message)")
            }

            IAMessageService.hide()
        }

        IAMessageService.show(view, config: config)
    }

    @IBAction func presentVC(_: UIButton) {
        let nextVC = NextViewController()
        present(nextVC, animated: true, completion: nil)
    }

    private func message() -> IAMessage {
        var title = titleTextField.text ?? ""
        title = title.count != 0 ? title : "title 1 \ntitle 2 \ntitle 3 \ntitle 4"

        var body = bodyTextField.text ?? ""
        body = body.count != 0 ? body : "Line 1 \nLine 2 \nLine 3 \nLine 4"

        let image = "post"
        let info = ["your key": "your value"]
        return IAMessage(title: title, body: body, image: image, userInfo: info)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
