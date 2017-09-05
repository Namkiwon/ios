//
//  ViewController.swift
//  chatting3
//
//  Created by 남기원 on 2017. 8. 7..
//  Copyright © 2017년 namkiwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,StreamDelegate, UITextViewDelegate {
  

    var host_address = " ****.****.***.**"   // ip address
    let host_port = 10000
    var input : InputStream?
    var output : OutputStream?
    var containerOry : CGFloat?
    var receiveheight : CGFloat?
    var p : CGFloat = 100
    var overline : Bool = false
    let namae = "남기원\n"
    var keyboardheight : CGFloat?
    var containersize :CGFloat?
    var upkeyboardsize : CGFloat?
    var saveoffset : CGFloat?
    
    
    @IBOutlet weak var containerheight: NSLayoutConstraint!
   
    @IBOutlet weak var containerbottom: NSLayoutConstraint!
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var receivemessage: UITextView!
  
    var containerVC : containerViewController?
    let containerSegueName = "sender"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { if segue.identifier == containerSegueName { containerVC = segue.destination as? containerViewController } }
  


    
    override func viewDidLoad() {
       self.containerVC?.receivemessage = self.receivemessage
        
        receivemessage.addSubview(container)
      receivemessage.scrollIndicatorInsets = UIEdgeInsetsMake(100, 0, 45, 2)
    
        
        receivemessage.contentSize.height = p
      //        self.view.addSubview(receivemessage)
        
        self.receivemessage.text = ""
        
        self.containerVC?.containerheight = self.containerheight
        self.containerVC?.text.delegate = self
        
       self.containerOry = container.frame.origin.y
        self.receiveheight = receivemessage.frame.size.height
        receivemessage.isEditable = false
       
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Stream.getStreamsToHost(withName: host_address, port: host_port, inputStream: &input,outputStream: &output)
        output!.open()
        self.containerVC?.output = output
        input?.delegate = self
        let myRunLoop = RunLoop.current
        input?.schedule(in: myRunLoop, forMode: .defaultRunLoopMode)
        input!.open()
        
      
        ///////// 터치핸들러 등록/////
        let tap = UITapGestureRecognizer(target : self, action: #selector(receivemessagetouch))
            view.addGestureRecognizer(tap)
    }
    func receivemessagetouch(){
    self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /////////////스트림 핸들러////////////////////
    
    
    var const : [NSLayoutConstraint] = []
    var preheight : CGFloat = 0
    var inc:CGFloat = 5
    
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        
        switch (eventCode) {
        case Stream.Event.hasBytesAvailable :
            let iStream = aStream as! InputStream
            let buffersize = 1024
            var buffer = [UInt8](repeating :0, count : buffersize)
            iStream.read(&buffer, maxLength: buffersize)
            let msg = String(bytes: buffer, encoding: String.Encoding.utf8)
            
            if let s = msg{
               
            var str = s
            str = str.replacingOccurrences(of: "\0", with: "")
            let endindex = str.endIndex
            let lastindex = str.index(before: endindex)
            str.remove(at: lastindex)
            print(str)
            print("adfasdfasdf \(receivemessage.contentOffset.y)")
                
                // 말풍선 만들기//////////////////////////////
                
                let textbox = UITextView()
                textbox.translatesAutoresizingMaskIntoConstraints = false
                textbox.isEditable = false
                textbox.isScrollEnabled = false
                textbox.layer.cornerRadius = 10.0  // 코너 라운딩
                textbox.font = UIFont.systemFont(ofSize: 13)
                textbox.text = str
                
               textbox.text = textbox.text.replacingOccurrences(of: (self.containerVC?.myname)! + " : ", with: "")
              
               
              
               // textbox.frame.origin.y = CGFloat(p)
                textbox.frame.size.width = 300
                textbox.sizeToFit()
                print("pre textbox height\(textbox.frame.size.height)")///////
                self.receivemessage.addSubview(textbox)
                 receivemessage.bringSubview(toFront: container) // 컨테이너는 항상 상위뷰로 해준다
                                                                // 여러 뷰들이 추가 된다 하더라도 그때마다 호출
                if(s.hasPrefix((self.containerVC?.myname)!)){
                    textbox.backgroundColor = UIColor.yellow
                   
                    let right = textbox.trailingAnchor.constraint(equalTo: self.receivemessage.trailingAnchor, constant: receivemessage.frame.maxX - 20)
                    let top = textbox.topAnchor.constraint(equalTo: self.receivemessage.topAnchor, constant: CGFloat(p))
                    let width = textbox.widthAnchor.constraint(equalToConstant: textbox.contentSize.width)
                    let height = textbox.heightAnchor.constraint(equalToConstant: textbox.contentSize.height)
               
                    const = [right,width,top,height]
                    NSLayoutConstraint.activate(const)
              
                    textbox.sizeToFit()
                }
                else{textbox.backgroundColor = UIColor.white
                    
                    let left = textbox.leadingAnchor.constraint(equalTo: self.receivemessage.leadingAnchor, constant : 20)
                    let top = textbox.topAnchor.constraint(equalTo: self.receivemessage.topAnchor, constant: CGFloat(p))
                    let width = textbox.widthAnchor.constraint(equalToConstant: textbox.contentSize.width)
                    let height = textbox.heightAnchor.constraint(equalToConstant: textbox.contentSize.height)
                    const = [left,width,top,height]
                    NSLayoutConstraint.activate(const)
                }
            
                print("textbox height\(textbox.frame.size.height)")
                print("textbox content \(textbox.contentSize.height)")
                print("asdfasdfasdfasfd\(self.receivemessage.contentOffset.y)")
                print("contentsizeheight = \(receivemessage.contentSize.height)")
                print("receivemessageheight = \(receivemessage.bounds.size.height)")
                print("컨테이너 높이\(container.frame.height)")
                // 대화 내용 추가에 대한 컨텐츠사이즈 update
                self.receivemessage.contentSize.height += textbox.frame.size.height + 5
                // 다음 대화내용 위치 update
                p += (textbox.frame.height + 5)
                
            }
            
            print("컨테이너 위치\(container.frame.origin.y)")
            print("바운드\(self.receivemessage.bounds.size.height)")
            print("바운드 올진\(self.receivemessage.bounds.origin.y)")
            print("컨테이너 제약\(self.containerbottom.constant)")
            
            
            
            if(self.p) > (self.receivemessage.bounds.size.height  - (self.containerbottom.constant + self.container.frame.height)){
                let bottom = (self.p)-(self.receivemessage.bounds.size.height - (self.containerbottom.constant + self.container.frame.height))
                self.receivemessage.setContentOffset(CGPoint(x: 0, y: bottom), animated: false)
                
            }
            
        default:
            return
        }
    }
  //////////////////////////////////////
    
    
    
    
////////////////키보드 조작/////////////////////
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 키보드 옵저버 등록
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(notification:)),
            name: .UIKeyboardWillShow,
            object: nil
        )
      
        
        // 키보드 옵저버 등록
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(notification:)),
            name: .UIKeyboardWillHide,
            object: nil
        )
    }
    
    
    func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        let animationDuration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animationCurve = UIViewAnimationOptions(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).uintValue << 16)
        let frameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print(frameEnd)
        
        UIView.animate(
            withDuration: animationDuration,
            delay: 0.0,
            options: [.beginFromCurrentState, animationCurve],
            animations: {
            
            self.containerbottom.constant = (self.view.bounds.maxY - self.view.window!.convert(frameEnd, to: self.view).minY)
                
                //키보드 높이 구하기
                self.keyboardheight = (self.view.bounds.maxY - self.view.window!.convert(frameEnd, to: self.view).minY)
                
                /////////키보드 올라올때///////
            if(notification.name._rawValue == "UIKeyboardWillShowNotification"){
                self.upkeyboardsize = self.keyboardheight!
                // 리시버 콘텐츠 크기가 리시버 크기보다 클때
                if(self.p > self.receiveheight! ){
                
                    let move = self.receivemessage.contentOffset.y + self.upkeyboardsize!
                    self.receivemessage.setContentOffset(CGPoint(x: 0, y: move ), animated: false)
                    
                    if( self.receivemessage.contentOffset.y > (self.p - (self.receiveheight! - (self.keyboardheight! + self.containerheight.constant)) - (self.keyboardheight!))){
                        print("찾았다 시발")
                        self.saveoffset = self.receivemessage.contentOffset.y
                        
                    }
                }
                
                // 리시버 콘텐츠 크기가 리시버 보단 작지만 (리시버사이즈-키보드) 보다 클때
                if(self.receiveheight! > self.p && self.p > self.receiveheight!-(self.view.bounds.maxY - self.view.window!.convert(frameEnd, to: self.view).minY + self.container.frame.height)){
                    
                    let bottom = (self.p)-(self.receivemessage.bounds.size.height - (self.containerbottom.constant + self.container.frame.height))
                    
                    self.receivemessage.setContentOffset(CGPoint(x: 0, y: bottom ), animated: false)
                }
                }
                
                ///////키보드 내려갈때//////
            if(notification.name._rawValue == "UIKeyboardWillHideNotification"){
             print("키보드 높이 \(self.keyboardheight!)")
                if(self.receivemessage.contentOffset.y < self.upkeyboardsize!){
                    self.receivemessage.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                }
                
                if( self.receivemessage.contentOffset.y >= self.upkeyboardsize!){
                    let move = self.receivemessage.contentOffset.y - self.upkeyboardsize!
                    self.receivemessage.setContentOffset(CGPoint(x: 0, y: move), animated: false)
 
                }

            }
                // 키보드 유무에 따른 스크롤 범위 지정
                self.receivemessage.scrollIndicatorInsets = UIEdgeInsetsMake(100, 0, self.keyboardheight! + self.container.frame.height, 2)
                self.receivemessage.contentSize.height = self.p + self.container.frame.height + self.keyboardheight!
                
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
//    func keyboardWillHide(notification: Notification) {
//        guard let userInfo = notification.userInfo else {
//            return}
//        let frameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       // super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
      

    }
    ////////////////////////키보드 조작 끝/////////////////////////

    
    
    
    /////////////////////텍스트 뷰 조작/////////////////
    func textViewDidChange(_ textView: UITextView) {
        print("contentoffset\(receivemessage.contentOffset.y)")
        print("컨테이너 올진\(container.frame.origin.y)")
        print("pp \(self.p)")
       
        
        if(self.containerVC?.text.text == ""){
        self.containerheight.constant = 45
        }    // 문자열이 없으면 다시 원래 크기로 복원ㄴ
   
        
    
       
        
        
        if((self.containerVC?.text.contentSize.height)! < 136){
             self.containersize = containerheight.constant
            self.containerheight.constant = (self.containerVC?.text.contentSize.height)! + 5
             self.receivemessage.setContentOffset(CGPoint(x : 0, y : self.receivemessage.contentOffset.y + (containerheight.constant - self.containersize!)), animated: false)
            
        
            
        self.receivemessage.contentSize.height = self.p + self.containerheight.constant  + self.keyboardheight!
            
            print("컨테이너 크기\(container.frame.size.height)")
            
            self.receivemessage.scrollIndicatorInsets = UIEdgeInsetsMake(100, 0, self.keyboardheight! + self.containerheight.constant, 2)
        
        }// 콘텐트 사이즈가 4줄 이하일때만 콘테이너 사이즈를 조정  containerheight 는 오토레이아웃의 바텀 constraint
        

        let bottom = (self.containerVC?.text.contentSize.height)!-(self.containerVC?.text.bounds.size.height)!
        self.containerVC?.text.setContentOffset(CGPoint(x: 0, y: bottom ), animated: false)
       
      
    }
    
    



}
 
