//
//  ViewController.swift
//  RActionSheet
//
//  Created by ray on 2017/8/15.
//  Copyright © 2017年 ray. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var label: UILabel!
    var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel.init(frame: CGRect.init(x: 0, y: 100, width: RScreenW, height: 30))
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "点击屏幕"
        label.numberOfLines = 1
        self.view.addSubview(label)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let sheet = RActionSheet.init(delegate: self, cancelTitle: "取消", otherTitles: "查看详情","拍照","相册选择")
        sheet.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension ViewController: RActionSheetDelegate{
    func actionSheet(actionSheet: RActionSheet, clickedButtonAtIndex index: Int) {
        print(index)
    }
}
