//
//  RActionSheet.swift
//  RActionSheet
//
//  Created by ray on 2017/8/15.
//  Copyright © 2017年 ray. All rights reserved.
//

import UIKit

//按钮高度
let BHEIGHT:CGFloat = 46

//取消按钮上面间隙的高度
let MARGIN:CGFloat = 8

//返回颜色方法
func RColor(_ r:CGFloat,_ g: CGFloat,_ b: CGFloat)->UIColor{
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}
//颜色生成图片
func createImage(_ color: UIColor)-> UIImage{
    let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}

//背景色
let BGCOLOR = RColor(237,240,242)

//分割线颜色
let SEPCOLOR = RColor(226, 226, 226)

//普通状态下的图片
let NORMAL_IMAGE = createImage(RColor(255,255,255))
//高亮状态下图片
let HIGH_IMAGE = createImage(RColor(242,242,242))

let RScreenW = UIScreen.main.bounds.width
let RScreenH = UIScreen.main.bounds.height
//字体
func RFont(_ size: CGFloat)->UIFont {return UIFont.init(name: "STHeitiSC-Light", size: size)!}

protocol RActionSheetDelegate: NSObjectProtocol {
    func actionSheet(actionSheet: RActionSheet, clickedButtonAtIndex index: Int)
}


class RActionSheet: UIView {

    
    weak var delegate: RActionSheetDelegate?
    weak var actionSheet: RActionSheet?
    weak var sheetView: UIView?
    var _tag: Int?
    
    init(delegate: RActionSheetDelegate, cancelTitle: String, otherTitles: String...) {
        super.init(frame: UIScreen.main.bounds)
        self.actionSheet = self
        
        self.delegate = delegate
        
        self.backgroundColor = UIColor.black
       ((UIApplication.shared.delegate?.window)!)?.addSubview(self)
        
        self.alpha = 0.0
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(coverClick))
        self.addGestureRecognizer(tap)
        
        
        
        let sheetView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: RScreenW, height: 0))
        sheetView.backgroundColor = BGCOLOR
        sheetView.alpha = 0.9
       ((UIApplication.shared.delegate?.window)!)?.addSubview(sheetView)
        self.sheetView = sheetView
        sheetView.isHidden = true
        
        _tag = 1
        
        if otherTitles.count != 0 {
            for title in otherTitles {
                self.btnTitle(title)
            }
        }
        var sheetViewFrame = sheetView.frame
        sheetViewFrame.size.height = BHEIGHT*CGFloat(_tag!) + MARGIN
        sheetView.frame = sheetViewFrame
        
        let cancelBtn =  UIButton.init(frame: CGRect.init(x: 0, y: sheetView.frame.size.height-BHEIGHT, width: RScreenW, height: BHEIGHT))
        
        cancelBtn.setBackgroundImage(NORMAL_IMAGE, for: UIControlState.normal)
        cancelBtn.setBackgroundImage(HIGH_IMAGE, for: UIControlState.highlighted)
        cancelBtn.setTitle(cancelTitle, for: UIControlState.normal)
        cancelBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        cancelBtn.titleLabel?.font = RFont(17)
        cancelBtn.tag = 0
        cancelBtn.addTarget(self, action: #selector(handleCancel(_:)), for: UIControlEvents.touchUpInside)
        sheetView.addSubview(cancelBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: 显示
    func show(){
        self.sheetView?.isHidden = false
        var sheetViewFrame = self.sheetView?.frame
        sheetViewFrame?.origin.y = RScreenH
        self.sheetView?.frame = sheetViewFrame!
        
        var newSheetViewFrame = self.sheetView?.frame
        newSheetViewFrame?.origin.y = RScreenH - (self.sheetView?.frame.size.height)!
        UIView.animate(withDuration: 0.3) { 
            self.sheetView?.frame = newSheetViewFrame!
            self.actionSheet?.alpha = 0.3
        }
    }
    //    MARK：btnTitle:
    func btnTitle(_ title: String) {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: BHEIGHT * CGFloat(_tag! - 1), width: RScreenW, height: BHEIGHT))
        btn.setBackgroundImage(NORMAL_IMAGE, for: UIControlState.normal)
        btn.setBackgroundImage(HIGH_IMAGE, for: UIControlState.highlighted)
        btn.setTitle(title, for: UIControlState.normal)
        btn.setTitleColor(UIColor.black, for: UIControlState.normal)
        btn.titleLabel?.font = RFont(17)
        btn.tag = _tag!
        btn.addTarget(self, action: #selector(handleCancel(_:)), for: UIControlEvents.touchUpInside)
        self.sheetView?.addSubview(btn)
        
        let line = UIView.init(frame: CGRect.init(x: 0, y: 0, width: RScreenW, height: 0.5))
        line.backgroundColor = SEPCOLOR
        btn.addSubview(line)
        _tag = _tag! + 1
    }
    
//    MARK: actionsheet点击事件
    func coverClick() {
        var sheetViewFrame = self.sheetView?.frame
        sheetViewFrame?.origin.y = RScreenH
        UIView.animate(withDuration: 0.2, animations: { 
            self.sheetView?.frame = sheetViewFrame!
            self.actionSheet?.alpha = 0.0
        }) { (finished) in
            self.actionSheet?.removeFromSuperview()
            self.sheetView?.removeFromSuperview()
        }
    }

//  MARK: handleCancel
    func handleCancel(_ btn: UIButton) {
        if btn.tag == 0 {
            self.coverClick()
            return
        }
        if self.delegate != nil {
            self.delegate?.actionSheet(actionSheet: self, clickedButtonAtIndex: btn.tag)
            self.coverClick()
        }
    }
    
}
