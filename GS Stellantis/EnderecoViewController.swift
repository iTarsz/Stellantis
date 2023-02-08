//
//  EnderecoViewController.swift
//  GS Stellantis
//
//  Created by Usuário Convidado on 07/11/22.
//

import UIKit
import CoreData

class EnderecoViewController: UIViewController {

    
    @IBOutlet weak var txtCep: UITextField!
    
    @IBOutlet weak var txtEndereco: UITextField!
    
    @IBOutlet weak var txtBairro: UITextField!
    
    @IBOutlet weak var txtCidade: UITextField!
    
    @IBOutlet weak var txtEstado: UITextField!
    
    @IBOutlet weak var txtNumero: UITextField!
    var session: URLSession?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func exibir(_ sender: Any) {
        let urlCep = txtCep.text
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
        let url = URL(string:"https://viacep.com.br/ws/\(urlCep!)/json/")
        let task = session?.dataTask(with: url!, completionHandler: { data, response, error in
            if let endereco = self.retornarEndereco(data: data!){
                DispatchQueue.main.sync {
                    self.txtEndereco.text = endereco
                }
            }
            if let bairro = self.retornarBairro(data: data!){
                DispatchQueue.main.sync {
                    self.txtBairro.text = bairro
                }
            }
            if let cidade = self.retornarCidade(data: data!){
                DispatchQueue.main.sync {
                    self.txtCidade.text = cidade
                }
            }
            
            if let endereco = self.retornarEstado(data: data!){
                DispatchQueue.main.sync {
                    self.txtEstado.text = endereco
                }
            }
            
        })
        task?.resume()
    }
    
    func retornarEndereco(data:Data)->String?{
        var resposta:String? = nil
        do{
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
            if let retorno = json["logradouro"] as? String{
                resposta = retorno
            }
            
        }catch let error as NSError{
            resposta = "Falha ao carregar \(error.localizedDescription)"
        }
        return resposta
    }
    
    func retornarBairro(data:Data)->String?{
        var resposta:String? = nil
        do{
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
            if let retorno = json["bairro"] as? String{
                resposta = retorno
            }
            
        }catch let error as NSError{
            resposta = "Falha ao carregar \(error.localizedDescription)"
        }
        return resposta
    }
    
    func retornarCidade(data:Data)->String?{
        var resposta:String? = nil
        do{
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
            if let retorno = json["localidade"] as? String{
                resposta = retorno
            }
            
        }catch let error as NSError{
            resposta = "Falha ao carregar \(error.localizedDescription)"
        }
        return resposta
    }
    
    func retornarEstado(data:Data)->String?{
        var resposta:String? = nil
        do{
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
            if let retorno = json["uf"] as? String{
                resposta = retorno
            }
            
        }catch let error as NSError{
            resposta = "Falha ao carregar \(error.localizedDescription)"
        }
        return resposta
    }
    
    
    @IBAction func btSalvar(_ sender: Any) {
        
        self.save(cep: txtCep.text!, endereco: txtEndereco.text!, bairro: txtBairro.text!, cidade: txtCidade.text!, estado: txtEstado.text!, numero: txtNumero.text!)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func save(cep:String, endereco:String, bairro:String, cidade:String, estado:String, numero:String) {
    
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entidade = NSEntityDescription.entity(forEntityName: "Endereco", in: managedContext)!
        
        let pessoa = NSManagedObject(entity: entidade, insertInto: managedContext)
        pessoa.setValue(cep, forKey: "cep")
        pessoa.setValue(endereco, forKey: "endereco")
        pessoa.setValue(bairro, forKey: "bairro")
        pessoa.setValue(cidade, forKey: "cidade")
        pessoa.setValue(estado, forKey: "estado")
        pessoa.setValue(numero, forKey: "numero")
        
        do{
            try managedContext.save()
        }catch let error as NSError {
            print("Não foi possível salvar. \(error), \(error.userInfo)")
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
