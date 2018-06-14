//
//  DatosViewController.swift
//  ProyectoIOS
//
//  Created by Francisco López Gómez on 29/5/18.
//  Copyright © 2018 Francisco López Gómez. All rights reserved.
//



import UIKit

class DatosViewController: UIViewController {
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellidos: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var direccion: UITextField!
    @IBOutlet weak var codigopostal: UITextField!
    @IBOutlet weak var poblacion: UITextField!
    @IBOutlet weak var provincia: UITextField!
    @IBOutlet weak var pais: UITextField!
    
    let datos  = UserDefaults.standard
    let config = Config()
    
    @IBAction func salir() {
        self.datos.set(false, forKey: "remember")
        self.datos.synchronize()
        print("Saliendo...")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "vistauno") as! ViewController
        self.present(resultViewController, animated:false, completion:nil)
    }
    
    @IBAction func guardarDatos(_ sender: Any) {
        
        let parametros = "fn=\(self.nombre.text!)&ln=\(self.apellidos.text!)&em=\(self.email.text!)&iad=\(self.direccion.text!)&ipc=\(self.codigopostal.text!)&ipr=\(self.provincia.text!)&ito=\(self.poblacion.text!)&ico=\(self.pais.text!)"
        print(parametros)
        
        let url = URL(string: "http://\(config.ip)/proyecto/assets/apis/fmapi/Services/saveUserData.php")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.httpBody = parametros.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request){data,response,error in
            guard data != nil else{
                print("solicitud fallida\(String(describing: error))")
                return
            }
            
            do{
                print("recibimos respuesta")
                sleep(2)
                if let json = try JSONSerialization.jsonObject(with: data!) as? [String: String] {
                    
                    
                    DispatchQueue.main.async {//proceso principal
                        
                        let mensaje = json["message"]//constante
                        let error = Int(json["success"]!)//constante
                        print(mensaje!)
                        
                    }
                }
            } catch let parseError {//manejamos el error
                print("error al parsear: \(parseError)")
                let responseString = String(data: data!, encoding: .utf8)
                print("respuesta : \(responseString!)")
            }
        }
        task.resume()
    }
    
    
    override  func viewDidLoad(){
        super.viewDidLoad()
        
        let url = URL(string: "http://\(config.ip)/proyecto/assets/apis/fmapi/Services/loadUserData.php")
        let task = URLSession.shared.dataTask(with: url!){data,response,error in
            if error != nil {
                print(error!)
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    let success = parsedData["success"] as! String
                    if success == "1" {
                        let datos = parsedData["data"] as! [[String:Any]]
                        
                        let customer = datos[0]
                        
                        
                        
                        DispatchQueue.main.async {//proceso principal
                            
                            self.nombre.text = customer["d_firstName"] as? String
                            self.apellidos.text = customer["d_lastName"] as? String
                            self.email.text = customer["d_email"] as? String
                            self.direccion.text = customer["d_invoiceAddress"] as? String
                            self.codigopostal.text = customer["d_invoicePc"] as? String
                            self.poblacion.text = customer["d_invoiceTown"] as? String
                            self.provincia.text = customer["d_invoiceProvince"] as? String
                            self.pais.text = customer["d_invoiceCountry"] as? String
                            
                        }
                        
                        
                        
                        
                        
                        
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        task.resume()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

