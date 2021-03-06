//
//  Bech32.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// Base32 address format
/// [BIP-0173](https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki)
class Bech32 {
    private let characters = "qpzry9x8gf2tvdw0s3jn54khce6mua7l".map(String.init)
    private let generator = [0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3]
    private let separator = "1"
    private let checksumLength = 6

    func polymod(values: Data) -> Int {
        var chk = 1
        for v in values.bytes {
            let b = chk >> 25
            chk = (chk & 0x1ffffff) << 5 ^ Int(v)
            generator.enumerated().forEach { (i, g) in
                if (b >> i) & 1 != 0 {
                    chk ^= g
                }
            }
        }
        return chk
    }

    func expand(hrp: String) -> Data {
        let data = hrp.data(using: .utf8)!
        let bytes = data.map { $0 >> 5 } + [0] + data.map { $0 & 31 }
        return Data(bytes)
    }

    func createChecksum(hrp: String, data: Data) -> Data {
        let values = expand(hrp: hrp) + data
        let mod = polymod(values: values + Array(repeating: 0, count: checksumLength)) ^ 1
        let checksum = (0..<checksumLength).map { (mod >> (5 * (5 - $0))) & 31 }
        return Data(checksum.map(UInt8.init))
    }

    func verifyChecksum(hrp: String, data: Data) -> Bool {
        return polymod(values: expand(hrp: hrp) + data) == 1
    }
}

// MARK: - Encode & Decode
extension Bech32 {
    func encode(hrp: String, data: Data) -> String {
        let checksum = createChecksum(hrp: hrp, data: data)
        return hrp + separator + (data + checksum).map { characters[Int($0)] }.joined()
    }

    func decode(bech32: String) -> (hrp: String, data: Data)? {
        if bech32.count > 90 {
            return nil
        }

        if bech32 != bech32.lowercased() && bech32 != bech32.uppercased() {
            return nil
        }

        guard !(bech32.utf8.contains { $0 < 33 || $0 > 126 }) else {
            return nil
        }

        guard let indexOfSeparator = bech32.lastIndex(of: Character(separator)) else {
            return nil
        }
        let posOfSeparator = bech32.distance(from: bech32.startIndex, to: indexOfSeparator)
        if posOfSeparator < 1 || posOfSeparator + checksumLength + 1 > bech32.count {
            return nil
        }

        let hrp = String(bech32.prefix(posOfSeparator)).lowercased()
        var data = Data()
        for char in bech32.dropFirst(hrp.count + 1) {
            guard let pos = characters.firstIndex(of: String(char).lowercased()) else {
                return nil
            }
            data.append(UInt8(pos))
        }

        guard verifyChecksum(hrp: hrp, data: data) else {
            return nil
        }

        return (hrp: hrp, data: data.dropLast(checksumLength))
    }
}
