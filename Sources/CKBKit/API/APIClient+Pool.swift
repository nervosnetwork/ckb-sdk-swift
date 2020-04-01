//
//  APIClient+Pool.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import Combine
import CKBFoundation

public extension APIClient {
    func sendTransaction(transaction: Transaction) -> Future<H256, APIError> {
        load(APIRequest<H256>(method: "send_transaction", params: [transaction.param]))
    }

    func txPoolInfo() -> Future<TxPoolInfo, APIError> {
        load(APIRequest<TxPoolInfo>(method: "tx_pool_info", params: []))
    }
}
