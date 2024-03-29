//
//  ViewController.swift
//  coreData2
//
//  Created by Sandra Herrera on 15/07/19.
//  Copyright © 2019 Edison Effect. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {

    
    var managedContext : NSManagedObjectContext!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var labelModelo: UILabel!
    
    @IBOutlet weak var labelClasification: UILabel!
    
    @IBOutlet weak var labelNumberOfTest: UILabel!
    
    @IBOutlet weak var labelLastTimeUsed: UILabel!
    @IBOutlet weak var buttonTest: UIButton!
    @IBOutlet weak var buttonEvaluate: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guardarDatosPlistEnCoreData()
        //Agregar
        let peticion = NSFetchRequest<Automovil>(entityName: "Automovil")
        let primerTitulo = segmentedControl.titleForSegment(at: 0)!
        peticion.predicate = NSPredicate(format: "busqueda == %@", primerTitulo)
        do {
            let resultados try managedContext.fetch(peticion)
            //popularDatos(automovil: resultados.first!)
        } catch let error as NSError {
            print("No puede recuperar datos \(error), \(error.userInfo)")
        }
    }


    func guardarDatosPlistEnCoreData()
    {
        let peticion = NSFetchRequest<Automovil>(entityName: "Automovil")
        peticion.predicate = NSPredicate(format: "nombre != nil")
        let cantidad = try! managedContext.count(for: peticion)
        if cantidad > 0
        {
            //la información inicial de nuestro Plist ya esta en core data
            print("Core data ya tiene la informacion inicial del plist")
            return
        }
        else
        {
            print("Se ingresaran los datos iniciales que están en ListaDatosIniciales.plist")
            
            let pathList = Bundle.main.path(forResource: "ListaDatosIniciales", ofType: "plist")
            let arregloDatosPlist = NSArray(contentsOfFile: pathList!)!
            for diccionarioDatosPlist in arregloDatosPlist
            {
                let entity = NSEntityDescription.entity(forEntityName: "Automovil", in: managedContext)!
                let automovil = Automovil(entity: entity, insertInto: managedContext)
                let dictAutomovil = diccionarioDatosPlist as! [String: AnyObject]
                automovil.nombre = dictAutomovil["nombre"] as? String
                automovil.busqueda = dictAutomovil["busqueda"] as? String
                automovil.calificacion = dictAutomovil["calificacion"] as! Double
                
                let nombreArchivo = dictAutomovil["nombreImagen"] as? String
                let imagen = UIImage(named: nombreArchivo!)
                let datosArchivoImg = imagen!.jpegData(compressionQuality: 0.5)!
                automovil.datosImagen = NSData(data: datosArchivoImg)
                automovil.ultimaPrueba = dictAutomovil["ultimaPrueba"] as? NSDate
                
                let vecesProbado = dictAutomovil["vecesProbado"] as! NSNumber
                automovil.vecesProbado = vecesProbado.int32Value
                
                try! managedContext.save()
            }
            
        }
    }
}

