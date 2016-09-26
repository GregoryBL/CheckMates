//
//  AwesomeTextField.swift
//  AwesomeTextField
//
//  Created by MacBookPro on 22.07.15.
//  Copyright (c) 2015 MacBookPro. All rights reserved.
//

import UIKit

@IBDesignable

class AwesomeTextField: UITextField {
    
    @IBInspectable var underLineWidth : CGFloat = 2.0
    @IBInspectable var underLineColor : UIColor = UIColor.black
    @IBInspectable var underLineAlphaBefore : CGFloat = 0.5
    @IBInspectable var underLineAlphaAfter : CGFloat = 1
    
    @IBInspectable var placeholderTextColor : UIColor = UIColor.gray
    
    @IBInspectable var animationDuration : TimeInterval = 0.35
    
    let scaleCoeff : CGFloat = 0.75
    let textInsetX : CGFloat = 1.5
    let placeholderAlphaAfter : CGFloat = 0.85
    let placeholderAlphaBefore : CGFloat = 0.5
    
    var placeholderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var underlineView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var isLifted = false
    
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        self.drawLine()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AwesomeTextField.didBeginChangeText), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(AwesomeTextField.didChangeText), name: NSNotification.Name.UITextFieldTextDidChange, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(AwesomeTextField.didEndChangeText), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
        
    }
    
    func drawLine() {
        
        let underLine = UIView(frame:CGRect(x: 0, y: self.frame.size.height - self.underLineWidth, width: self.frame.size.width, height: self.underLineWidth))
        
        underLine.backgroundColor = self.underLineColor
        underLine.alpha = self.underLineAlphaBefore
        
        self.underlineView = underLine
        
        self.addSubview(self.underlineView)
        
    }
    
    override func drawPlaceholder(in rect: CGRect) {
        
        super.drawPlaceholder(in: rect)
        
        self.placeholderLabel = UILabel(frame: CGRect(x: rect.origin.x, y: self.underLineWidth, width: rect.size.width, height: self.font!.pointSize))
        self.placeholderLabel.center = CGPoint(x: self.placeholderLabel.center.x, y: self.frame.size.height - self.underlineView.frame.size.height - self.placeholderLabel.frame.size.height / 2)
        self.placeholderLabel.text = self.placeholder
        self.placeholder = nil
        
        self.placeholderLabel.font = UIFont(name: self.font!.fontName, size: self.font!.pointSize)
        
        self.placeholderLabel.textColor = self.placeholderTextColor
        self.placeholderLabel.alpha = self.placeholderAlphaBefore
        
        self.addSubview(self.placeholderLabel)
        self.bringSubview(toFront: self.placeholderLabel)
        
    }
    
    func drawPlaceholderIfTextExistInRect(_ rect: CGRect) {
        
        self.placeholderLabel = UILabel(frame: CGRect(x: rect.origin.x, y: self.underLineWidth, width: rect.size.width, height: self.font!.pointSize))
        self.placeholderLabel.transform = CGAffineTransform(scaleX: self.scaleCoeff, y: self.scaleCoeff)
        self.placeholderLabel.center = CGPoint(x: self.placeholderLabel.center.x * self.scaleCoeff, y: 0 + self.placeholderLabel.frame.size.height)
        self.placeholderLabel.text = self.placeholder
        self.placeholder = nil
        
        self.placeholderLabel.font = UIFont(name: self.font!.fontName, size: self.font!.pointSize)
        
        self.placeholderLabel.textColor = self.placeholderTextColor
        self.placeholderLabel.alpha = self.placeholderAlphaAfter
        self.isLifted = true
        
        self.addSubview(self.placeholderLabel)
        self.bringSubview(toFront: self.placeholderLabel)
        
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
        
        if self.placeholder != nil {
            self.drawPlaceholderIfTextExistInRect(rect)
        }
        
        self.textAlignment = .left
        self.contentVerticalAlignment = .bottom
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        let insetForY = self.underLineWidth + 2.0
        self.textAlignment = .left
        self.contentVerticalAlignment = .bottom
        return bounds.insetBy(dx: self.textInsetX, dy: insetForY)
        
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        let insetForY = self.underLineWidth + 2.0
        self.textAlignment = .left
        self.contentVerticalAlignment = .bottom
        return bounds.insetBy(dx: self.textInsetX, dy: insetForY)
    }
    
    // MARK: - Delegate
    
    func didBeginChangeText() {
        
        if !self.isLifted {
            UIView.animate(withDuration: self.animationDuration, animations: { () -> Void in
                self.placeholderLabel.transform = CGAffineTransform(scaleX: self.scaleCoeff, y: self.scaleCoeff)
                self.placeholderLabel.alpha = self.placeholderAlphaAfter
                self.placeholderLabel.center = CGPoint(x: self.placeholderLabel.center.x * self.scaleCoeff, y: 0 + self.placeholderLabel.frame.size.height)
                
                self.underlineView.alpha = self.underLineAlphaAfter
                
                }, completion: { (finished) -> Void in
                    if finished {
                        self.isLifted = true
                    }
            })
        } else {
            UIView.animate(withDuration: self.animationDuration, animations: { () -> Void in
                self.underlineView.alpha = self.underLineAlphaAfter
            })
        }
        
    }
    
    func didChangeText() {
        
    }
    
    func didEndChangeText() {
        
        if self.isLifted && self.text!.isEmpty {
            UIView.animate(withDuration: self.animationDuration, animations: { () -> Void in
                
                self.placeholderLabel.alpha = self.placeholderAlphaBefore
                self.placeholderLabel.center = CGPoint(x: self.placeholderLabel.center.x / self.scaleCoeff, y: self.frame.size.height - self.underlineView.frame.size.height - self.placeholderLabel.frame.size.height / 2.0 - 2.0)
                self.placeholderLabel.transform = CGAffineTransform.identity
                
                self.underlineView.alpha = self.underLineAlphaBefore
                
                }, completion: { (finished) -> Void in
                    if finished {
                        self.isLifted = false
                    }
            })
        } else {
            UIView.animate(withDuration: self.animationDuration, animations: { () -> Void in
                self.underlineView.alpha = self.underLineAlphaBefore
            })
        }
        
    }
    
    // MARK: - Dealloc
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
