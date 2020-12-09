//
//  LUT.swift
//  LUTFilterExample
//
//  Created by Денис Данилюк on 01.11.2020.
//  Copyright © 2020 wangwenjie. All rights reserved.
//

import Foundation
import UIKit

public enum ColorCube {
    
    static func createBitmap(image: CGImage, colorSpace: CGColorSpace) -> UnsafeMutablePointer<UInt8>? {
        
        let width = image.width
        let height = image.height
        
        let bitsPerComponent = 8
        let bytesPerRow = width * 4
        
        let bitmapSize = bytesPerRow * height
        
        guard let data = malloc(bitmapSize) else {
            return nil
        }
        
        guard let context = CGContext(
                data: data,
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue,
                releaseCallback: nil,
                releaseInfo: nil) else {
            return nil
        }
        
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        return data.bindMemory(to: UInt8.self, capacity: bitmapSize)
    }
    
    
    public static func cubeData(lutImage: UIImage, dimension: Int, colorSpace: CGColorSpace) -> Data? {
        
        guard let cgImage = lutImage.cgImage else {
            return nil
        }
        
        guard let bitmap = createBitmap(image: cgImage, colorSpace: colorSpace) else {
            return nil
        }
        
        let width = cgImage.width
        let height = cgImage.height
        let rowNum = width / dimension
        let columnNum = height / dimension
        
        let dataSize = dimension * dimension * dimension * MemoryLayout<Float>.size * 4
        
        var array = Array<Float>(repeating: 0, count: dataSize)
        
        var bitmapOffest: Int = 0
        var z: Int = 0
        
        for _ in 0..<rowNum {
            for y in 0..<dimension {
                let tmp = z
                for _ in 0..<columnNum {
                    for x in 0..<dimension {
                        let dataOffset = (z * dimension * dimension + y * dimension + x) * 4
                        
                        let position = bitmap.advanced(by: bitmapOffest)
                        
                        array[dataOffset + 0] = Float(position.advanced(by: 0).pointee) / 255
                        array[dataOffset + 1] = Float(position.advanced(by: 1).pointee) / 255
                        array[dataOffset + 2] = Float(position.advanced(by: 2).pointee) / 255
                        array[dataOffset + 3] = Float(position.advanced(by: 3).pointee) / 255
                        
                        bitmapOffest += 4
                    }
                    z += 1
                }
                z = tmp
            }
            z += columnNum
        }
        free(bitmap)
        return Data(bytes: array, count: dataSize)
        
//        for _ in stride(from: 0, to: rowNum, by: 1) {
//            for y in stride(from: 0, to: dimension, by: 1) {
//                let tmp = z
//                for _ in stride(from: 0, to: columnNum, by: 1) {
//                    for x in stride(from: 0, to: dimension, by: 1) {
//                        
//                        let dataOffset = (z * dimension * dimension + y * dimension + x) * 4
//                        
//                        let position = bitmap
//                            .advanced(by: bitmapOffest)
//                        
//                        array[dataOffset + 0] = Float(position
//                                                        .advanced(by: 0)
//                                                        .pointee) / 255
//                        
//                        array[dataOffset + 1] = Float(position
//                                                        .advanced(by: 1)
//                                                        .pointee) / 255
//                        
//                        array[dataOffset + 2] = Float(position
//                                                        .advanced(by: 2)
//                                                        .pointee) / 255
//                        
//                        array[dataOffset + 3] = Float(position
//                                                        .advanced(by: 3)
//                                                        .pointee) / 255
//                        
//                        bitmapOffest += 4
//                        
//                    }
//                    z += 1
//                }
//                z = tmp
//            }
//            z += columnNum
//        }
//        
//        free(bitmap)
//        
//        let data = Data.init(bytes: array, count: dataSize)
//        return data
    }
}
