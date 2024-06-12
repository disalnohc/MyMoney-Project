//
//  AddCategoryViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 29/4/2567 BE.
//

import UIKit

class AddCategoryViewController: UIViewController, UIPickerViewDataSource , UIPickerViewDelegate {
    
    @IBOutlet weak var bgImage: UIView!
    @IBOutlet weak var imageCategory: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var colorWells: UIColorWell!
    @IBOutlet weak var uploadImaguttone: UIButton!
    @IBOutlet weak var bgDetails: UIView!
    
    var selectedColor: UIColor = .white
    var hexColor : String = ""
    let data = ["Income", "Expenses"]
    var selectedOption : String = "Income"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bgImage.layer.cornerRadius = 10
        bgDetails.layer.cornerRadius = 10
        tappedImages()
        
        //color
        colorWells.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
        
        let picker = UIPickerView()
            picker.dataSource = self
            picker.delegate = self
        
        typeTextField.inputView = picker
        typeTextField.text = selectedOption
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPickerView))
            view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - UIPickerViewDelegate and UIPickerViewDataSource methods
    
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return data.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return data[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedOption = data[row]
            typeTextField.text = selectedOption
        }
    
    @objc func dismissPickerView() {
        // Dismiss the inputView (UIPickerView) of typeTextField
        typeTextField.resignFirstResponder()
    }
    
    // MARK: COLORWELL AND COLOR CHANGED
    @objc private func colorChanged() {
                bgImage.backgroundColor = colorWells.selectedColor
                guard let hexValue = colorWells.selectedColor?.toHex else { return }
                hexColor = hexValue
    }
    
    class func initVC() -> AddCategoryViewController {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(identifier: "AddCategoryViewController") as! AddCategoryViewController
        
        return vc
    }
    
    @objc func imagePicker() {
        let imagePick = UIImagePickerController()
        imagePick.sourceType = .photoLibrary
        imagePick.delegate = self
        self.present(imagePick, animated: true, completion: nil)
    }
    
    @IBAction func imageUploadButton(_ sender: UIButton) {
        imagePicker()
    }
    
    @IBAction func save(_ sender: UIButton) {
        addNewCategory()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension AddCategoryViewController {
    func addNewCategory() {
        guard let url = URL(string: "\(ipURL)/insert-category") else {
            print("Invalid Url")
            return
        }
        
        let categoryData = CategoryData(
            username: "\(userName)",
            name: nameTextField.text ?? "",
            bgcolor: hexColor,
            type: selectedOption.lowercased(),
            image: nil)
        
        let postData = try! JSONEncoder().encode(categoryData);
            
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data , response , error in
            if let error = error {
                print("Error : \(error)")
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.updateImage()
                    }
                } else {
                    print("Response is not 200 : \(response.statusCode)")
                }
            }
        }
        task.resume()
    }
    
    func updateImage() {
        guard let url = URL(string: "\(ipURL)/update-image/\(userName)") else {
            print("Invalid Url")
            return
        }
        
        guard let imageData = imageCategory.image?.jpegData(compressionQuality: 0.8) else {
            let imageData = UIImage(named: "package")?.jpegData(compressionQuality: 0.8)
            return
        }

        // Boundary
        let boundary = UUID().uuidString

        // Header for image data
        var imageDataPart = Data()
        imageDataPart.append("--\(boundary)\r\n")
        imageDataPart.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpeg\"\r\n")
        imageDataPart.append("Content-Type: image/jpeg\r\n\r\n")
        imageDataPart.append(imageData)
        imageDataPart.append("\r\n")

        // Footer boundary
        let footer = "--\(boundary)--\r\n"

        // Combine all parts
        var requestData = Data()
        requestData.append(imageDataPart)
        requestData.append(footer)

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = requestData
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        
        let task = URLSession.shared.dataTask(with: request) { data , response , error in
            if let error = error {
                print("error : \(error)")
            }
            
            if let statusCode = response as? HTTPURLResponse {
                if statusCode.statusCode == 200 {
                    print("Success")
                    if self.selectedOption.lowercased() == "income" {
                        incomeCategory.append(CategoryData(username: userName, name: self.nameTextField.text ?? "", bgcolor: self.hexColor, type: "income", image: imageData))
                    } else {
                        expensesCategory.append(CategoryData(username: userName, name: self.nameTextField.text ?? "", bgcolor: self.hexColor, type: "expenses", image: imageData))
                    }
                } else {
                    print("Failed : \(statusCode.statusCode)")
                }
            }
        }
        task.resume()
    }
    
    func createRequestBody(imageData: Data, boundary: String, attachmentKey: String, fileName: String) -> Data{
            let lineBreak = "\r\n"
            var requestBody = Data()

            requestBody.append("\(lineBreak)--\(boundary + lineBreak)" .data(using: .utf8)!)
            requestBody.append("Content-Disposition: form-data; name=\"\(attachmentKey)\"; filename=\"\(fileName)\"\(lineBreak)" .data(using: .utf8)!)
            requestBody.append("Content-Type: image/jpeg \(lineBreak + lineBreak)" .data(using: .utf8)!) // you can change the type accordingly if you want to
            requestBody.append(imageData)
            requestBody.append("\(lineBreak)--\(boundary)--\(lineBreak)" .data(using: .utf8)!)

            return requestBody
        }
    
    func tappedImages() {
        UITapGestureRecognizer(target: self, action: #selector(imagePicker))
    }
    
    
    
}

extension AddCategoryViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageCategory.image = info[.originalImage] as? UIImage
        imageCategory.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
    }
}
