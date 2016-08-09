//
//  SocketManger.swift
//  Socket
//
//  Created by 李世洋 on 16/8/7.
//  Copyright © 2016年 李世洋. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

private let HOST = "192.168.1.100"
private let PORT: UInt16 = 5000
private let TIMEOUT: Double = -1


protocol SocketMangerDelegate {
    func socketdidConnectToHost(sock: SocketManger, host: String, port: UInt16)
    func socketDidDisconnectWithError(sock: SocketManger, err: NSError?)
    func sockedidReadData(sock: SocketManger, data: NSData, tag: Int)
}

public class SocketManger {

    var socket: GCDAsyncSocket?
    var delegate: SocketMangerDelegate?
    
    init() {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        socket = GCDAsyncSocket(delegate: self, delegateQueue: queue)
    }
    
    static let manger: SocketManger = {
        
        return SocketManger()
    }()
    
    class func shareManger() -> SocketManger
    {
        return manger
    }
    
    /**
     开始链接
     */
    public func startConnect() {
        
        do {
            try socket?.connectToHost(HOST, onPort: PORT, withTimeout: TIMEOUT)
            
        } catch {
            print(error)
        }
    }
 
    public func sendMessage(message: String) {
         let temp = message.dataUsingEncoding(NSUTF8StringEncoding)
        socket?.writeData(temp!, withTimeout: TIMEOUT, tag: 0)
        
    }
    
}


extension SocketManger: GCDAsyncSocketDelegate
{
    /**
     于服务器连接成功会调用
     
     - parameter sock: 当前 Socket
     - parameter host: IP
     - parameter port: 端口
     */
    @objc public func socket(sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        
        
        delegate?.socketdidConnectToHost(self, host: host, port: port)
        sock.readDataWithTimeout(TIMEOUT, tag: 0)
    }
    
    /**
     与服务器断开连接调用
     
     - parameter sock: 当前 Socket
     - parameter err:  错误信息
     */
    @objc public func socketDidDisconnect(sock: GCDAsyncSocket, withError err: NSError?) {
        
        delegate?.socketDidDisconnectWithError(self, err: err)
        startConnect()
    }
    
    
    /**
     接收到服务器发来的消息调用
     
     - parameter sock: 当前 Socket
     - parameter data: 服务器发来的消息
     - parameter tag:  暂时无用
     */
    @objc public func socket(sock: GCDAsyncSocket, didReadData data: NSData, withTag tag: Int) {
        
       
        delegate?.sockedidReadData(self, data: data, tag: tag)
        sock.readDataWithTimeout(TIMEOUT, tag: 0)
        
    }
}