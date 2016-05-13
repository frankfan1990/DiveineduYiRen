//
//  StatusCode.swift
//  DivYiRen
//
//  Created by frankfan on 16/4/28.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import Foundation

enum StatusCode:Int{

    case success = 101
    case username_banned = 102
    case request_invalid = 999
    
    case register_success = 200
    case name_occupy = 201
    case confirmCode_incorrect = 202
    
    case login_success = 300
    case password_wrong = 301
    case confirmCode_incorrect2 = 302
    case user_forbid = 303
    case network_error = 304
    
    
    case logout_success = 400
    case unlogin2 = 401
    case session_error = 402
    case dataBase_error = 403
    
    case get_or_add_success = 500
    case ready_confirm = 501
    case block = 502
    case user_non_existent = 503
    case unlogin = 504
    case session_error2 = 505
    case duplication_add = 506
    
    case send_sucess = 600
    case send_fail = 601
    case session_invail = 602
    case message_formatterError = 603
    
    case offline_message_ok = 700
    
    
    
   static func reasonPhraseForStatusCode(code:StatusCode)->String{
        
        switch code {
        case .login_success:
            return "登陆成功"
        case .password_wrong:
            return "密码错误"
        case .confirmCode_incorrect:
            return "验证码错误"
        case .user_forbid:
            return "被封禁"
        case .network_error:
            return "网络错误"
        case .logout_success:
            return "注销成功"
        case .session_error:
            return "会话失败"
        case .dataBase_error:
            return "数据库错误"
        case .get_or_add_success:
            return "操作成功"
        case .ready_confirm:
            return "等待验证"
        case .block:
            return "被拉黑"
        case .confirmCode_incorrect2:
            return "验证码错误"
        case .user_non_existent:
            return "用户不存在"
        case .session_error2:
            return "会话失败"
        case .send_sucess:
            return "发送成功"
        case .send_fail:
            return "发送失败"
        case .message_formatterError:
            return "消息格式错误"
        case .offline_message_ok:
            return "离线消息获取成功"
        case .unlogin:
            return "没有登录"
        case .unlogin2:
            return "没有登录"
        case .duplication_add:
            return "请勿重复添加"
        case .session_invail:
            return "会话无效"
        default:
            return ""
        }
        
    }
    
    
    
    
}