//
//  AddCategoryViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 29/4/2567 BE.
//

import UIKit

class AddCategoryViewController: UIViewController {
    
    @IBOutlet weak var bgImage: UIView!
    @IBOutlet weak var imageCategory: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var colorWheel: UIColorWell!
    @IBOutlet weak var uploadImaguttone: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tappedImages()
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
//        addNewCategory()
        updateImage()
    }
    
}

extension AddCategoryViewController {
    func addNewCategory() {
        guard let url = URL(string: "http://localhost:8080/insert-category") else {
            print("Invalid Url")
            return
        }
        
        let categoryData = CategoryData(
            username: "toeibew00",
            name: "dad",
            bgcolor: ".green",
            type: "income",
            image: nil)
        
        let postData = try! JSONEncoder().encode(categoryData);
            
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data , error , response in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                print("SUCCESS")
            } else {
                print(statusCode)
            }
        }
        task.resume()
    }
    
    func updateImage() {
        guard let url = URL(string: "http://localhost:8080/update-image/\(userName)") else {
            print("Invalid Url")
            return
        }
        
        guard let imageData = UIImage(named: "package")?.jpegData(compressionQuality: 0.8) else {
            // Handle error if unable to convert image to data
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

        
        let task = URLSession.shared.dataTask(with: request) { data , error , response in
            if let error = error {
                print("error : \(error)")
            }
            if let statusCode = response as? HTTPURLResponse {
                if statusCode.statusCode == 200 {
                    print("Success")
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(imagePicker))
    }
    
}

extension AddCategoryViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageCategory.image = info[.originalImage] as? UIImage
        imageCategory.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
    }
}

extension Data {
   mutating func append(_ string: String) {
      if let data = string.data(using: .utf8) {
         append(data)
      }
   }
}
