//
//  ViewController.swift
//  swift
//
//  Created by keith on 2022/1/30.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var canvasView: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func revoke() {
        canvasView.revoke()
    }
    
    @IBAction func save() {
        let image = canvasView.saveImage()
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }

    @IBAction func rewrite() {
        canvasView.clear()
    }

    @IBAction func valueChange(value: UISwitch) {
        if(value.isOn) {
            canvasView.pathColor = .orange
        } else {
            canvasView.pathColor = .black
        }
    }

}

