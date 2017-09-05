//
//  containerViewController.swift
//  chatting3
//
//  Created by 남기원 on 2017. 8. 7..
//  Copyright © 2017년 namkiwon. All rights reserved.
//

import UIKit

class containerViewController: UIViewController {
    var output : OutputStream?
    var hasname : Bool = false
    var myname : String?
    var keyboardheight : CGFloat?
    var receivemessage : UITextView?
    var p : CGFloat?
  
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var text: UITextView!
    var containerheight : NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        text.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func textViewDidChange(_ textView: UITextView) {
//        textView.frame.size.height = textView.contentSize.height
//       self.send.frame.size.height = textView.contentSize.height
//        
//        
//    }
    
    @IBAction func sendbutton(_ sender: UIButton) {
        if(text.text != ""){
        if(hasname == false){
        myname = text.text
            hasname = true
        }
        let msg = text.text! + "\n"
        guard ( self.output != nil) else {return }
        let outData = msg.data(using: .utf8)
        outData?.withUnsafeBytes({ (p: UnsafePointer<UInt8>) -> Void in
            self.output?.write(p, maxLength: (outData?.count)!)
        })
        text.text = ""
        containerheight.constant = 45
        
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
