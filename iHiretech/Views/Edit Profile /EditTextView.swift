//
//  EditTextView.swift
//  iHiretech
//
//  Created by Admin on 31/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class EditTextView: UIView , UITextFieldDelegate{

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var borderView: UIView!
    @IBOutlet var detailTextField: UITextField!
    var view : UIView!
    
    @IBInspectable var placeholder : String? {
        get {
            return detailTextField.placeholder
        }
        set(placeholder) {
            detailTextField.attributedPlaceholder = NSMutableAttributedString(string: placeholder!,attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 67/255, green: 67/255, blue: 69/255, alpha: 1)])
        }
    }
    
    @IBInspectable var text : String? {
        get {
            return lblTitle.text
        }
        set(text) {
            lblTitle.text = text
        }
    }

 

    
    
    override func draw(_ rect: CGRect)
    {
        //  lbl_PlaceHolderTxt.isHidden = true
        detailTextField.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldTextChanged(sender:)),
            name:NSNotification.Name.UITextFieldTextDidChange,
            object: nil
        )
        
    }
    func xibSetup() {
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        self.borderView.layer.borderWidth = 1
        self.borderView.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        //        let bundle = Bundle(for: type(of: self))
        let bundle = Bundle(for: self.classForCoder)
        //        let className = NSStringFromClass(self.classForCoder)
        let nib = UINib(nibName: "EditTextView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    @objc func textFieldTextChanged(sender : UITextField)
    {
        if(detailTextField.text?.isEmpty)!
        {
            
        }
        else
        {
            
        }
    }

}
