//
//  Validation.swift
//  iHiretech
//
//  Created by Admin on 07/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class Validation: NSObject
{

func validationForLogin(viewList : [UIView]) -> Array<Any>
{
    var viewsToReturn = [UIView]()
    if((viewList[0] as! FormFieldView).txtFieldName.text?.isEmpty)!
    {
        (viewList[0]as!  FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Enter Email Address",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        viewsToReturn.append(viewList[0])
    }
    else if (!(isValidEmail(testStr: (viewList[0]as!  FormFieldView).txtFieldName.text!)))
    {
        (viewList[0]as!  FormFieldView).txtFieldName.text = ""
        (viewList[0]as!  FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Enter Valid Email Address",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        viewsToReturn.append(viewList[0])
        
    }
    
    if((viewList[1]as!  FormFieldView).txtFieldName.text?.isEmpty)!
    {
        (viewList[1]as!  FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Enter Password",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        viewsToReturn.append(viewList[1])
    }
    else if(((viewList[1]as!  FormFieldView).txtFieldName.text?.characters.count)! < 6)
    {
        (viewList[1]as!  FormFieldView).txtFieldName.text = ""
        (viewList[1]as!  FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Password too small",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        viewsToReturn.append(viewList[1])
        
    }
    
    return  viewsToReturn
    
}
    
    func validationForSignup(viewList : [UIView]) -> Array<Any>
    {
        var viewsToReturn = [UIView]()
        if((viewList[0]as!  FormFieldView).txtFieldName.text?.isEmpty)!
        {
            (viewList[0]as!  FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Enter First Name",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            viewsToReturn.append(viewList[0])
        }
        if((viewList[1]as!  FormFieldView).txtFieldName.text?.isEmpty)!
        {
            (viewList[1]as!  FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Enter Last Name",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            viewsToReturn.append(viewList[1])
        }
        
        if((viewList[2]as!  FormFieldView).txtFieldName.text?.isEmpty)!
        {
            (viewList[2]as!  FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Enter Email Address",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            viewsToReturn.append(viewList[2])
        }
        else if (!(isValidEmail(testStr: (viewList[2]as!  FormFieldView).txtFieldName.text!)))
        {
            (viewList[2]as!  FormFieldView).txtFieldName.text = ""
            (viewList[2]as!  FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Enter Valid Email Address",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            viewsToReturn.append(viewList[2])
            
        }
        
        if((viewList[3]as!  FormFieldView).txtFieldName.text?.isEmpty)!
        {
            (viewList[3]as!  FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Enter Password",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            viewsToReturn.append(viewList[3])
        }
        else if(((viewList[3]as!  FormFieldView).txtFieldName.text?.characters.count)! < 6)
        {
            (viewList[3]as! FormFieldView).txtFieldName.text = ""
            (viewList[3]as! FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Password too small",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            viewsToReturn.append(viewList[3])
        }
        
        if((viewList[4]as! FormFieldView).txtFieldName.text?.isEmpty)!
        {
            (viewList[4]as! FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Re-Enter Password",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            viewsToReturn.append(viewList[4])
        }
        
          return  viewsToReturn
    }
    
    func validationForChangePassword(viewList : [UIView]) -> Array<Any>
    {
        var viewsToReturn = [UIView]()
        
        if((viewList[0]as!  FormFieldView).txtFieldName.text?.isEmpty)!
        {
            (viewList[0]as!  FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Enter Password",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            viewsToReturn.append(viewList[0])
        }
        else if(((viewList[0]as!  FormFieldView).txtFieldName.text?.characters.count)! < 6)
        {
            (viewList[0]as!  FormFieldView).txtFieldName.text = ""
            (viewList[0]as!  FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Password too small",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            viewsToReturn.append(viewList[0])
        }
    
        if((viewList[1]as!  FormFieldView).txtFieldName.text?.isEmpty)!
        {
            (viewList[1]as!  FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Enter Password",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            viewsToReturn.append(viewList[1])
        }
        else if(((viewList[1]as!  FormFieldView).txtFieldName.text?.characters.count)! < 6)
        {
            (viewList[1]as!  FormFieldView).txtFieldName.text = ""
            (viewList[1]as!  FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Password too small",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            viewsToReturn.append(viewList[1])
         }
        
        if((viewList[2]as!  FormFieldView).txtFieldName.text?.isEmpty)!
        {
            (viewList[2]as!  FormFieldView).txtFieldName.attributedPlaceholder = NSMutableAttributedString(string: "Enter Password",attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            viewsToReturn.append(viewList[2])
        }
       
        
          return  viewsToReturn
 }


func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func matchesForRegexInText(regex: String, text: String) -> [String] {
    do {
        let regex = try NSRegularExpression(pattern: regex, options: [])
        let nsString = text as NSString
        let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { nsString.substring(with: $0.range)}
    } catch let error as NSError {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

}

