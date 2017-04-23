//
//  NewProductViewController.swift
//  rotorresComprasUsa
//
//  Created by Rober Torres on 23/04/17.
//  Copyright © 2017 Rober Torres. All rights reserved.
//

import UIKit
import CoreData
import CoreMotion

class NewProductViewController: UIViewController {

    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var tfProductValue: UITextField!
    @IBOutlet weak var swProductByCard: UISwitch!
    @IBOutlet weak var ivProductPoster: UIImageView!
    @IBOutlet weak var tfProductState: UITextField!
    @IBOutlet weak var btNewState: UIButton!
    @IBOutlet weak var btNewProduct: UIButton!
    @IBOutlet weak var btClose: UIButton!
    
    var product: Product!
    
    var imagePicker = UIImagePickerController()
    var smallImage: UIImage!
    
    var motionManager = CMMotionManager()
    var pickerView: UIPickerView!
    
    var stateDataSource: [State] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadStatesPicker()
        
        if product != nil {
            tfProductName.text = product.name
            tfProductValue.text = "\(product.value)"
            tfProductState.text = product.states?.name
            
            if let image = product.poster as? UIImage {
                ivProductPoster.image = image
            }
            btNewProduct.setTitle("Atualizar", for: .normal)
            btClose.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! StatesViewController
        if product == nil {
            product = Product(context: context)
        }
        vc.product = product
    }
    
    
    @IBAction func close(_ sender: UIButton?) {
        dismiss(animated: true, completion: nil)
        if product != nil && product.name == nil {
            context.delete(product)
        }
    }
    
    
    @IBAction func addNewProduct(_ sender: UIButton) {
        
        if product == nil {
            product = Product(context: context)
        }
        product.name = tfProductName.text!
        product.value = Double(tfProductValue.text!)!
        product.bycard = swProductByCard.isOn

        if smallImage != nil {
            product.poster = smallImage
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        close(nil)
    }
    
    
    private func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onImageTap(_ sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Selecionar imagem", message: "Selecione a origem", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Galeria", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func cancel() {
        tfProductState.resignFirstResponder()
    }
    
    func done() {
        tfProductState.text = stateDataSource[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }

    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            stateDataSource = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadStatesPicker(){
        
        loadStates()
        
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        
        tfProductState.inputView = pickerView
        tfProductState.inputAccessoryView = toolbar
    }

}


extension NewProductViewController: UIPickerViewDelegate {
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateDataSource[row].name
    }
}

extension NewProductViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateDataSource.count
    }
}


extension NewProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        let smallSize = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivProductPoster.image = smallImage
        
        dismiss(animated: true, completion: nil)
    }
}
