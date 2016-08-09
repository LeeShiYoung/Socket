//
//  ViewController.swift
//  Socket
//
//  Created by 李世洋 on 16/7/30.
//  Copyright © 2016年 李世洋. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var socketManger: SocketManger?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socketManger = SocketManger.shareManger()
    
        socketManger?.delegate = self
        socketManger!.startConnect()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        socketManger?.sendMessage("发送消息")
    }
}

extension ViewController: SocketMangerDelegate
{
    func socketdidConnectToHost(sock: SocketManger, host: String, port: UInt16) {
        print("链接成功")
        print("host: \(host)\nport \(port)")
    }
    
    func sockedidReadData(sock: SocketManger, data: NSData, tag: Int) {
        let read = NSString(data: data, encoding: NSUTF8StringEncoding)
        print("收到服务器响应 \(read)")
    }
    
    func socketDidDisconnectWithError(sock: SocketManger, err: NSError?) {
        print("断开链接")
    }
}

