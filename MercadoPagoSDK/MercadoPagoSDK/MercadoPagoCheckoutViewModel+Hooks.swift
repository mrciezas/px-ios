//
//  MercadoPagoCheckoutViewModel+Hooks.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 11/28/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//
import Foundation
extension MercadoPagoCheckoutViewModel {

    func shouldShowHook(hookStep: PXHookStep) -> Bool {

        guard let hookSelected = MercadoPagoCheckoutViewModel.flowPreference.getHookForStep(hookStep: hookStep) else {
            return false
        }

        _ = copyViewModelAndAssignToCheckoutStore()

        if let shouldSkip = hookSelected.shouldSkipHook?(hookStore: PXCheckoutStore.sharedInstance), shouldSkip {
            self.continueFrom(hook: hookSelected.hookForStep())
            return false
        }

        switch hookStep {
        case .BEFORE_PAYMENT_METHOD_CONFIG:
            return shouldShowHook1()
        case .AFTER_PAYMENT_METHOD_CONFIG:
            return shouldShowHook2()
        case .BEFORE_PAYMENT:
            return shouldShowHook3()
        }
    }

    func shouldShowHook1() -> Bool {
        return paymentOptionSelected != nil
    }

    func shouldShowHook2() -> Bool {
        guard let pm = self.paymentData.getPaymentMethod() else {
            return false
        }

        if pm.isCreditCard && !(paymentData.hasPayerCost() && paymentData.hasToken()) {
            return false
        }

        if (pm.isDebitCard || pm.isPrepaidCard) && !paymentData.hasToken() {
            return false
        }

        if pm.isPayerInfoRequired && paymentData.getPayer().identification == nil {
            return false
        }
        return true
    }

    func shouldShowHook3() -> Bool {
        return readyToPay
    }

    public func wentBackFrom(hook: PXHookStep) {
        MercadoPagoCheckoutViewModel.flowPreference.addHookToHooksToShow(hookStep: hook)
    }

    public func continueFrom(hook: PXHookStep) {
        MercadoPagoCheckoutViewModel.flowPreference.removeHookFromHooksToShow(hookStep: hook)
    }

    public func updateCheckoutModelAfterBeforeConfigHook(paymentOptionSelected: PaymentMethodOption) {
        resetInformation()
        resetPaymentOptionSelectedWith(newPaymentOptionSelected: paymentOptionSelected)
    }
}
