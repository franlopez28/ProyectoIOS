//
//  ViewController.swift
//  ProyectoIOS
//
//  Created by Francisco López Gómez on 25/5/18.
//  Copyright © 2018 Francisco López Gómez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var remember: UISwitch!
    
    @IBOutlet weak var _email: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _login: UIButton!
    @IBOutlet weak var errorlabel: UILabel!
    
    let datos  = UserDefaults.standard
    
    let config = Config()
    
    
  
    
    
    @IBAction func login(){
        
        self._email.layer.borderColor = UIColor(red:255/255 , green:255/255, blue: 255/255, alpha: 1).cgColor;
        self._password.layer.borderColor = UIColor(red:255/255 , green:255/255, blue: 255/255, alpha: 1).cgColor;
        
        var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
       
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        self.errorlabel.textColor = UIColor.white
        self.errorlabel.text = "Cargando...";
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) {(timer) in
            UIApplication.shared.endIgnoringInteractionEvents()
            activityIndicator.stopAnimating()
            
        }
       
        let email = _email.text
        let passwd = _password.text
        
        if(email==""||passwd==""){
            print("campos vacios")
            self.errorlabel.textColor = UIColor.red
            self._email.layer.borderColor = UIColor(red:255/255 , green:0/255, blue: 0/255, alpha: 1).cgColor;
            self._email.layer.borderWidth = CGFloat(Float(1.5));
            self._email.layer.cornerRadius = CGFloat(Float(5.0));
            self._password.layer.borderColor = UIColor(red:255/255 , green:0/255, blue: 0/255, alpha: 1).cgColor;
            self._password.layer.borderWidth = CGFloat(Float(1.5));
            self._password.layer.cornerRadius = CGFloat(Float(5.0));
            self.errorlabel.text = "Por favor rellena los campos";
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            return
        }
        
        
        let postString = "email=\(email!)&passwd=\(passwd!)"
        
        print("solicitud enviada\(postString)")
        
        let url = URL(string: "http://\(config.ip)/proyecto/assets/apis/fmapi/Services/comprobateUser.php")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: request){data,response,error in
            guard data != nil else{
                
                self.errorlabel.textColor = UIColor.red
                self.errorlabel.text = "Error del servidor";
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
                        
                        if(error == 1){//todo correcto
                            
                            print(self.remember.isOn)
                           
                            if self.remember.isOn {
                                
                               
                                self.datos.set(email, forKey: "email")
                                self.datos.set(passwd, forKey: "pass")
                                self.datos.set(self.remember.isOn, forKey: "remember")
                                self.datos.synchronize()
                                
                                func setObject(value: AnyObject?, forKey defaultName: String){
                                    self.datos.set(email, forKey: "email")
                                    self.datos.set(passwd, forKey: "pass")
                                    self.datos.set(self.remember.isOn, forKey: "remember")
                                    
                                }
                            }
                           
                            
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            
                            
                            
                            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "vistaTabs") as! UITabBarController
                            
                            
                            self.present(resultViewController, animated:false, completion:nil)
                        }else if(error == 2){//datos denegados
                            
                        }else if(error == 3){//no existe
                            
                        }
                        if(mensaje == "Usuario o contraseña incorrectos"){
                            self.errorlabel.textColor = UIColor.red
                            self._email.layer.borderColor = UIColor(red:255/255 , green:0/255, blue: 0/255, alpha: 1).cgColor;
                            self._email.layer.borderWidth = CGFloat(Float(1.5));
                            self._email.layer.cornerRadius = CGFloat(Float(5.0));
                            self._password.layer.borderColor = UIColor(red:255/255 , green:0/255, blue: 0/255, alpha: 1).cgColor;
                            self._password.layer.borderWidth = CGFloat(Float(1.5));
                            self._password.layer.cornerRadius = CGFloat(Float(5.0));
                            
                        }else if(mensaje == "Login correcto"){
                            self._email.layer.borderColor = UIColor(red:0/255 , green:255/255, blue: 0/255, alpha: 1).cgColor;
                            self._email.layer.borderWidth = CGFloat(Float(1.5));
                            self._email.layer.cornerRadius = CGFloat(Float(5.0));
                            self._password.layer.borderColor = UIColor(red:0/255 , green:255/255, blue: 0/255, alpha: 1).cgColor;
                            self._password.layer.borderWidth = CGFloat(Float(1.5));
                            self._password.layer.cornerRadius = CGFloat(Float(5.0));
                        }
                        
                        self.errorlabel.text = mensaje;
                        print(mensaje!)
                        
                    }
                }
                
            } catch let parseError {//manejamos el error
                print("error al parsear: \(parseError)")
                self.errorlabel.textColor = UIColor.red
                self.errorlabel.text = "error del servidor (json)";
                
                let responseString = String(data: data!, encoding: .utf8)
                print("respuesta : \(responseString!)")
            }
            
        }
        
        task.resume()
    }
    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activo = datos.bool(forKey: "remember")
        let emailguardar = datos.string(forKey: "email")
        let passwdguardar = datos.string(forKey: "pass")
     
        sleep(1)
        
        
        
        if activo {
            _email.text = emailguardar!
            _password.text = passwdguardar!
            remember.isOn = true
            login()
        }else{
            _email.text = ""
            _password.text = ""
            remember.isOn = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
    

