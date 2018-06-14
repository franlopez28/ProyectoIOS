//
//  NewViewController.swift
//  ProyectoIOS
//
//  Created by Francisco López Gómez on 28/5/18.
//  Copyright © 2018 Francisco López Gómez. All rights reserved.
//

import UIKit
import UserNotifications

class NewViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var lista: UIPickerView!
    let config = Config()
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3.0, repeats: false)
    
    
    var list1 = ["","","","","","","","","","","",""]
    var list2 = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
    var list3 = ["","","","","","","","","","","",""]
    var list4 = ["","","","","","","","","","","",""]
    var listpk = ["","","","","","","","","","","",""]
    
    var currentPk = ""
    var currentMes = ""
    var years:[String] = Array()
    
    let datos  = UserDefaults.standard
    
    
    @IBAction func salir() {
        self.datos.set(false, forKey: "remember")
        self.datos.synchronize()
        print("Saliendo...")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "vistauno") as! ViewController
        self.present(resultViewController, animated:false, completion:nil)
    }
    
    @objc func showDialog(sender: UIButton) {
        
        currentPk = listpk[sender.tag]
        currentMes = list2[sender.tag]
        alerta(titulo: "Factura",mensaje: "¿Desea ver la factura?")
    }
    
    public func getFacturas(year:Int){
        
        let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
     
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) {(timer) in
            UIApplication.shared.endIgnoringInteractionEvents()
            activityIndicator.stopAnimating()
            
        }
        
        let parametros = "year=\(year)"
        let url = URL(string: "http://\(config.ip)/proyecto/assets/apis/fmapi/Services/loadContratos.php")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.httpBody = parametros.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request){data,response,error in
            if error != nil {
                print(error!)
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    let success = parsedData["success"] as! String
                    if success == "1" {
                        let datos = parsedData["data"] as! [[String:Any]]
                        
                        var i = 0
                        
                        while i < datos.count {
                            
                            let fact = datos[i]
                            
                            let mes = fact["l_mes"] as! String
                            let mess = Int(mes)!
                            let fecha = fact["d_date"] as! String
                            let precio = fact["l_TotalPlusVAT"] as! String
                            let pdf = fact["l_empty"] as! String
                            let pk = fact["__pk"] as! String
                            self.list1[mess-1] = fecha
                            self.list3[mess-1] = "\(precio) €"
                            self.list4[mess-1] = pdf
                            self.listpk[mess-1] = pk
                            
                            
                            i+=1
                        }
                        
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        task.resume()
        
    
        sleep(1)
        tabla.beginUpdates()
        tabla.dataSource = nil
        tabla.dataSource = self
        tabla.endUpdates()
        
    }
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        var year =  components.year!
        getFacturas(year: year)
        let bottom = 2015
        
        while year >= bottom {
            years.append("\(year)")
            year -= 1
        }
        
        lista.delegate = self
        lista.dataSource = self
        tabla.delegate = self
        
    }
    
    func numberOfComponents(in lista: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView( _ lista: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    func pickerView( _  lista: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return years[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        list1 = ["","","","","","","","","","","",""]
        list3 = ["","","","","","","","","","","",""]
        list4 = ["","","","","","","","","","","",""]
        listpk = ["","","","","","","","","","","",""]
        getFacturas(year: Int(years[row])!)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell") as! FacturasCellController
        cell.lblFecha.text = list1[indexPath.row]
        cell.lblMes.text = list2[indexPath.row]
        cell.lblPrecio.text = list3[indexPath.row]
        if list4[indexPath.row] == "1" {
            cell.btnPDF.isHidden = false
            cell.btnPDF.tag = indexPath.row
            cell.btnPDF.addTarget(self, action: #selector(showDialog(sender:)), for: .touchDown)
        } else {
            cell.btnPDF.isHidden = true
        }
        return cell
    }
    func ver(alert: UIAlertAction!){
        print("Ver")
        print(currentPk)
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "web") as! WebViewController
//        resultViewController.pk = currentPk
//        resultViewController.action = "view"
//        self.present(resultViewController, animated:false, completion:nil)
        let parametros = "action=view&pk=\(currentPk)"
        UIApplication.shared.open(URL(string : "http://\(config.ip)/proyecto/assets/apis/fmapi/Services/pdf1.php?\(parametros)")!, options: [:], completionHandler: { (status) in
        })
        let content = UNMutableNotificationContent()
        
        content.title = "Factura"
        content.body = "Enhorabuena, has visto la factura del mes de \(currentMes)"
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: "NotificationLocal", content: content, trigger: trigger)
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().add(request) { (error) in
            guard let error = error else{return}
            print("error al llamar la peticion de notificacion: \(error)")
            
        }
    }
    func userNotificationCenter(center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions)->Void){
        completionHandler([.alert,.sound])
    }
    func descargar(alert: UIAlertAction!){
        print("Descargar")
        print(currentPk)
//        let parametros = "pk=\(currentPk)"
        let parametros = "action=download&pk=\(currentPk)"
        UIApplication.shared.open(URL(string : "http://\(config.ip)/proyecto/assets/apis/fmapi/Services/pdf1.php?\(parametros)")!, options: [:], completionHandler: { (status) in
        })
        
    }
    func alerta(titulo:String, mensaje:String){
        
        let alerta = UIAlertController(title:titulo, message: mensaje, preferredStyle: .alert)
        //let button = UIAlertAction(title: "Descargar", style: .default, handler: descargar)
        let button2 = UIAlertAction(title: "Aceptar", style: .default, handler: ver)
        let button3 = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        //alerta.addAction(button)
        alerta.addAction(button2)
        alerta.addAction(button3)
        
        self.present(alerta, animated: true, completion: nil)
        
    }
    
    
}
