//
//  ViewController.swift
//  HW 2.2.1
//
//  Created by Дамир Лутфуллин on 21.02.2020.
//  Copyright © 2020 Damir Lutfullin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // interface elements
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTF: UITextField!
    @IBOutlet var greenTF: UITextField!
    @IBOutlet var blueTF: UITextField!
    
    // метод жизнененного цикла
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // установка делегатом ViewController
        redTF.delegate = self
        greenTF.delegate = self
        blueTF.delegate = self
        
        // добавление кнопки Done
        setDoneOnKeyboard(textFields: redTF, greenTF, blueTF)
        
        // установка серого цвета ColorView
        colorView.backgroundColor = .gray
    }
    
    // обработка использования слайдера
    @IBAction func sliderUsed(_ sender: UISlider) {
        // определение через tag какой слайдер используется
        switch sender.tag {
        case 0:
            redTF.text = sender.value.string()
            redLabel.text = sender.value.string()
        case 1:
            greenTF.text = sender.value.string()
            greenLabel.text = sender.value.string()
        case 2:
            blueTF.text = sender.value.string()
            blueLabel.text = sender.value.string()
        default:
            break
        }
        setColor() // обновление параметров colorView
    }
    
    // метод изменения цвета colorView
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1)
    }
}


// MARK: work with keyboard
extension ViewController: UITextFieldDelegate {
    
    // закрываем клавиатуру тапом по экрану
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // метод, позволяющий добавить кнопку Done
    func setDoneOnKeyboard(textFields: UITextField...) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let doneBarButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(self.dismissKeyboard)
        )
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        for textField in textFields {
            textField.inputAccessoryView = keyboardToolbar
        }
    }
    
    // метод завершающий редактирование текстового поля
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // метод, позволящий заверш ить редактирование кнопкой Done на клавиатуре
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // изменение colorView, лейблов и слайдеров через ввод данных
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let string = textField.text, let float = Float(string) else { return }
        switch textField.tag {
        case 0:
            redLabel.text = string
            redSlider.value = float
        case 1:
            greenLabel.text = string
            greenSlider.value = float
        case 2:
            blueLabel.text = string
            blueSlider.value = float
        default:
            break
        }
        setColor()
    }
    
    // устанавливаем максимальную длину вводимого значения и символы, которые можно ввести
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        guard
            Double(string) != nil || string == "" || string == "." || string == ","
            else { return false }
        
        let maxLength = 4
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}


extension Float {
    // добавляем функционал для типа Float для удобства
    func string() -> String {
        return String(format: "%.2f", self)
    }
}
