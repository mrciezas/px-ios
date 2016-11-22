//
//  PaymentMethodSearchItem.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 15/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

open class PaymentMethodSearchItem : Equatable {
    
    open var idPaymentMethodSearchItem : String!
    open var type : PaymentMethodSearchItemType!
    open var description : String!
    open var comment : String?
    open var childrenHeader : String?
    open var children : [PaymentMethodSearchItem] = []
    open var showIcon : Bool = false
    
    open class func fromJSON(_ json : NSDictionary) -> PaymentMethodSearchItem {
        let pmSearchItem = PaymentMethodSearchItem()
        
        if let _id = JSONHandler.attemptParseToString(json["id"]){
            pmSearchItem.idPaymentMethodSearchItem = _id
        }
        if let type = JSONHandler.attemptParseToString(json["type"]){
            pmSearchItem.type = PaymentMethodSearchItemType(rawValue:type)
        }
        if let description = JSONHandler.attemptParseToString(json["description"]){
            pmSearchItem.description = description
        }
        if let comment = JSONHandler.attemptParseToString(json["comment"]){
            pmSearchItem.comment = comment
        }
        if let showIcon = JSONHandler.attemptParseToBool(json["show_icon"]){
            pmSearchItem.showIcon = showIcon
        }
        if let childrenHeader = JSONHandler.attemptParseToString(json["children_header"]){
            pmSearchItem.childrenHeader = childrenHeader
        }
        
        var children = [PaymentMethodSearchItem]()
        if let childrenJson = json["children"] as? NSArray {
            for i in 0..<childrenJson.count {
                if let childJson = childrenJson[i] as? NSDictionary {
                    children.append(PaymentMethodSearchItem.fromJSON(childJson))
                }
            }
            pmSearchItem.children = children
        }
        
        return pmSearchItem
    }
    
    open func isOfflinePayment() -> Bool {
        return PaymentTypeId.offlinePayments().contains(self.idPaymentMethodSearchItem)
    }
    
    open func isBitcoin() -> Bool {
        return self.idPaymentMethodSearchItem.lowercased() == "bitcoin"
    }
    
    open func isPaymentMethod() -> Bool {
        return self.type == PaymentMethodSearchItemType.PAYMENT_METHOD
    }
    
    open func isPaymentType() -> Bool {
        return self.type == PaymentMethodSearchItemType.PAYMENT_TYPE
    }
    
}

public enum PaymentMethodSearchItemType : String {
    case GROUP = "group"
    case PAYMENT_TYPE = "payment_type"
    case PAYMENT_METHOD = "payment_method"
}

public func ==(obj1: PaymentMethodSearchItem, obj2: PaymentMethodSearchItem) -> Bool {
    let areEqual =
    obj1.idPaymentMethodSearchItem == obj2.idPaymentMethodSearchItem &&
    obj1.type == obj2.type &&
    obj1.description == obj2.description &&
    obj1.comment == obj2.comment &&
    obj1.childrenHeader == obj2.childrenHeader &&
    obj1.children == obj2.children &&
    obj1.showIcon == obj2.showIcon
    return areEqual
}