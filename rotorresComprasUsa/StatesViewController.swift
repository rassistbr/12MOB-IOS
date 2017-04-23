//
//  StatesViewController.swift
//  rotorresComprasUsa
//
//  Created by Rober Torres on 23/04/17.
//  Copyright © 2017 Rober Torres. All rights reserved.
//

import UIKit
import CoreData

class StatesViewController: UIViewController {

    
    @IBOutlet weak var tvStates: UITableView!
    @IBOutlet weak var tfDolar: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var btNewState: UIButton!
    
    
    var dataSource: [State] = []
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
            tvStates.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    

    @IBAction func addNewState(_ sender: UIButton) {
        showAlert(type: .add, state: nil)
    }
    
    func showAlert(type: StateAlertType, state: State?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Estado"
            if let name = state?.name {
                textField.text = name
            }
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Imposto"
            if let tax = state?.tax {
                textField.text = "\(tax)"
            }
        }
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            
            let state = state ?? State(context: self.context)
            state.name = alert.textFields?.first?.text
            state.tax = Double((alert.textFields?.last?.text!)!)!
            
            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


enum StateAlertType {
    case add
    case edit
}


extension StatesViewController: UITableViewDelegate {
}


extension StatesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)
        
        let state = dataSource[indexPath.row]
        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = "\(state.tax)"
        cell.detailTextLabel?.textColor = .red
        return cell
    }
    
}






