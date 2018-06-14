//
//  GraficaViewController.swift
//  ProyectoIOS
//
//  Created by Francisco López Gómez on 4/6/18.
//  Copyright © 2018 Francisco López Gómez. All rights reserved.
//

import Foundation
import UIKit
import WebKit


class GraficaController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var list: UIPickerView!
    let config = Config()
    var years:[String] = Array()
    let datos  = UserDefaults.standard
    var list1 = ["","","","","","","","","","","",""]
    var list2 = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
    var list3 = ["","","","","","","","","","","",""]
    var list4 = ["","","","","","","","","","","",""]
    var listpk = ["","","","","","","","","","","",""]
    
    @IBAction func salir() {
        self.datos.set(false, forKey: "remember")
        self.datos.synchronize()
        
        print("Saliendo...")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "vistauno") as! ViewController
        self.present(resultViewController, animated:false, completion:nil)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let url = URL(string: "http://\(config.ip)/proyecto/grafica.php")
        let request = URLRequest(url: url!)
        webview.loadRequest(request)
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        var year =  components.year!
        getConsumo(year: year)
        let bottom = 2015
        
        while year >= bottom {
            years.append("\(year)")
            year -= 1
        }
        
        list.dataSource = self
        list.delegate = self
    }
    
    func getConsumo(year:Int){
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
        let url = URL(string: "http://\(config.ip)/proyecto/grafica.php")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.httpBody = parametros.data(using: .utf8)
        webview.loadRequest(request)
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
        getConsumo(year: Int(years[row])!)
    }
}
