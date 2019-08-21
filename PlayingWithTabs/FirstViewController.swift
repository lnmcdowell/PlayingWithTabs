//
//  FirstViewController.swift
//  PlayingWithTabs
//
//  Created by Nathaniel Mcdowell on 8/21/19.
//  Copyright © 2019 Nathaniel Mcdowell. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil{
            print("first going away")
        }else{
            print("red is being pushed to stack")
        }
    }


}

