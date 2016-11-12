//
//  DTMessageBar.swift
//  DTMessageBar
//
//  Created by Dan Jiang on 2016/11/8.
//
//

import UIKit

public enum DTMessageBarStyle {
  case standard
  case emoji
}

public enum DTMessageBarType {
  case success
  case info
  case warning
  case error
  
  var description: String {
    switch self {
    case .success:
      return "success"
    case .info:
      return "info"
    case .warning:
      return "warning"
    case .error:
      return "error"
    }
  }
}

public enum DTMessageBarPosition {
  case top
  case center
  case bottom
}

public class DTMessageBar: UIView {
  
  public static var style: DTMessageBarStyle = .standard
  public static var offset: CGFloat = 80

  fileprivate static let sharedView = DTMessageBar()
  
  fileprivate let typeImageView = UIImageView()
  fileprivate let messageLabel = UILabel()
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    layoutTypeImageView()
    layoutMessageLabel()
  }
  
  public class func success(message: String, position: DTMessageBarPosition = .top) {
    show(message: message, type: .success, position: position)
  }
  
  public class func info(message: String, position: DTMessageBarPosition = .top) {
    show(message: message, type: .info, position: position)
  }
  
  public class func warning(message: String, position: DTMessageBarPosition = .top) {
    show(message: message, type: .warning, position: position)
  }
  
  public class func error(message: String, position: DTMessageBarPosition = .top) {
    show(message: message, type: .error, position: position)
  }
  
  class func show(message: String, type: DTMessageBarType, position: DTMessageBarPosition = .top) {
    if let _ = DTMessageBar.sharedView.superview {
      return
    }
    
    if let w = UIApplication.shared.delegate?.window, let window = w {
      DTMessageBar.sharedView.translatesAutoresizingMaskIntoConstraints = false
      
      window.addSubview(DTMessageBar.sharedView)
      
      let centerX = NSLayoutConstraint(item: DTMessageBar.sharedView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)
      window.addConstraint(centerX)

      switch position {
      case .top:
        let top = NSLayoutConstraint(item: DTMessageBar.sharedView, attribute: .top, relatedBy: .equal, toItem: window, attribute: .top, multiplier: 1, constant: offset)
        window.addConstraint(top)
      case .center:
        let centerY = NSLayoutConstraint(item: DTMessageBar.sharedView, attribute: .centerY, relatedBy: .equal, toItem: window, attribute: .centerY, multiplier: 1, constant: 0)
        window.addConstraint(centerY)
      case .bottom:
        let bottom = NSLayoutConstraint(item: DTMessageBar.sharedView, attribute: .bottom, relatedBy: .equal, toItem: window, attribute: .bottom, multiplier: 1, constant: -offset)
        window.addConstraint(bottom)
      }
      
      DTMessageBar.sharedView.customize(message: message, type: type)
      
      DTMessageBar.sharedView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
      
      UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
        DTMessageBar.sharedView.transform = CGAffineTransform.identity
      }, completion: { _ in
        UIView.animate(withDuration: 0.25, delay: 2, options: .curveEaseIn, animations: {
          DTMessageBar.sharedView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: { _ in
          DTMessageBar.sharedView.removeFromSuperview()
        })
      })
    }
  }
  
  // MARK: - Private

  fileprivate func imageWithName(_ name: String) -> UIImage? {
    let bundle = Bundle(for: DTMessageBar.self)
    return UIImage(named: name, in: bundle, compatibleWith: nil)
  }

  fileprivate func layoutTypeImageView() {
    addSubview(typeImageView)
    
    typeImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let top = NSLayoutConstraint(item: typeImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 16)
    let leading = NSLayoutConstraint(item: typeImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 16)
    let bottom = NSLayoutConstraint(item: typeImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -16)
    
    addConstraints([top, leading, bottom])
  }
  
  fileprivate func layoutMessageLabel() {
    messageLabel.font = UIFont.boldSystemFont(ofSize: 17)
    
    addSubview(messageLabel)
    
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let leading = NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: typeImageView, attribute: .trailing, multiplier: 1, constant: 16)
    let trailing = NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -16)
    let centerY = NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
    
    addConstraints([leading, trailing, centerY])
  }
  
  fileprivate func customize(message: String, type: DTMessageBarType) {
    layer.cornerRadius = 12
    layer.borderWidth = 1
    
    messageLabel.text = message
    
    var borderColor: UIColor
    var backgroundColor: UIColor
    var textColor: UIColor

    switch type {
    case .success:
      borderColor = UIColor(red:0.84, green:0.91, blue:0.78, alpha:1.00)
      backgroundColor = UIColor(red:0.87, green:0.94, blue:0.85, alpha:1.00)
      textColor = UIColor(red:0.24, green:0.46, blue:0.24, alpha:1.00)
    case .info:
      borderColor = UIColor(red:0.74, green:0.91, blue:0.95, alpha:1.00)
      backgroundColor = UIColor(red:0.85, green:0.93, blue:0.97, alpha:1.00)
      textColor = UIColor(red:0.19, green:0.44, blue:0.56, alpha:1.00)
    case .warning:
      borderColor = UIColor(red:0.98, green:0.92, blue:0.80, alpha:1.00)
      backgroundColor = UIColor(red:0.99, green:0.97, blue:0.89, alpha:1.00)
      textColor = UIColor(red:0.54, green:0.42, blue:0.23, alpha:1.00)
    case .error:
      borderColor = UIColor(red:0.92, green:0.80, blue:0.82, alpha:1.00)
      backgroundColor = UIColor(red:0.95, green:0.87, blue:0.87, alpha:1.00)
      textColor = UIColor(red:0.66, green:0.27, blue:0.26, alpha:1.00)
    }
    
    var imageName: String
    switch DTMessageBar.style {
    case .standard:
      imageName = type.description
    case .emoji:
      imageName = "\(type.description)_emoji"
    }
    
    
    layer.borderColor = borderColor.cgColor
    self.backgroundColor = backgroundColor
    messageLabel.textColor = textColor
    typeImageView.image = imageWithName(imageName)
  }
  
}
