//
//  ViewController.swift
//  DTMessageBar iOS Example
//
//  Created by Dan Jiang on 2016/11/8.
//
//

import UIKit
import DTMessageBar

class ViewController: UIViewController {

  @IBOutlet weak var styleSegmentedControl: UISegmentedControl!
  @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
  @IBOutlet weak var positionSegmentedControl: UISegmentedControl!
  @IBOutlet weak var messageTextField: UITextField!
  
  @IBAction func chooseStyle(_ sender: Any) {
    switch styleSegmentedControl.selectedSegmentIndex {
    case 1:
      DTMessageBar.style = .emoji
    default:
      DTMessageBar.style = .standard
    }
  }
  
  @IBAction func show(_ sender: Any) {
    guard let message = messageTextField.text, !message.isEmpty else {
      return
    }
    
    let position: DTMessageBarPosition
    switch positionSegmentedControl.selectedSegmentIndex {
    case 1:
      position = .center
    case 2:
      position = .bottom
    default:
      position = .top
    }
    
    DTMessageBar.success(message: "Good Jobs", position: .center)
    
    switch typeSegmentedControl.selectedSegmentIndex {
    case 1:
      DTMessageBar.info(message: message, position: position)
    case 2:
      DTMessageBar.warning(message: message, position: position)
    case 3:
      DTMessageBar.error(message: message, position: position)
    default:
      DTMessageBar.success(message: message, position: position)
    }
  }
  
  @IBAction func hideKeyboard(_ sender: Any) {
    view.endEditing(true)
  }
  
}

