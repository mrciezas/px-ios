//
//  PXPaymentMethodIconComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 12/21/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

public class PXPaymentMethodIconComponent: NSObject, PXComponetizable {
    var props: PXPaymentMethodIconProps
    
    init(props: PXPaymentMethodIconProps) {
        self.props = props
    }
    public func render() -> UIView {
        return PXPaymentMethodIconRenderer().render(component: self)
    }
}

class PXPaymentMethodIconProps: NSObject {
    var paymentMethodIcon: UIImage
    
    init(paymentMethodIcon: UIImage) {
        self.paymentMethodIcon = paymentMethodIcon
    }
}
