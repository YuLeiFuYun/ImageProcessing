//
//  YUWrapper.swift
//  ImageProcessing
//
//  Created by 玉垒浮云 on 2024/3/18.
//

import UIKit

// 定义一个泛型结构体 YUWrapper，它将作为一个通用包装器，能够包装任何类型。
struct YUWrapper<Base> {
    let base: Base // 保存被包装的原始值
    init(_ base: Base) {
        self.base = base // 初始化时将原始值保存到属性中
    }
}

// 定义一个空的协议 YUCompatible，用于标记类类型（引用类型）的对象可以使用 YUWrapper 进行扩展。
protocol YUCompatible: AnyObject { }

// 定义一个空的协议 YUCompatibleValue，用于标记值类型的对象可以使用 YUWrapper 进行扩展。
protocol YUCompatibleValue { }

// 为 YUCompatible 协议扩展一个计算属性 yu，这使得任何遵循 YUCompatible 的类型（即类）都能通过 .yu 访问其包装器 YUWrapper 实例。
extension YUCompatible {
    var yu: YUWrapper<Self> {
        YUWrapper(self)
    }
    
    // 提供一个静态属性 yu，允许通过类型本身访问 YUWrapper，而不是类型的实例。
    static var yu: YUWrapper<Self>.Type {
        YUWrapper<Self>.self
    }
}

// 为 YUCompatibleValue 协议扩展一个计算属性 yu，这使得任何遵循 YUCompatibleValue 的类型（即值类型）也能通过 .yu 访问其包装器 YUWrapper 实例。
extension YUCompatibleValue {
    var yu: YUWrapper<Self> {
        YUWrapper(self)
    }
}

// 让 UIImage 类遵循 YUCompatible 协议，这意味着 UIImage 及其实例现在可以访问 .yu 属性，从而使用 YUWrapper 中定义的功能。
extension UIImage: YUCompatible { }

// 让 UIImageView 类遵循 YUCompatible 协议。
extension UIImageView: YUCompatible { }

// 让 CGSize 和 CGRect 这两个结构体遵循 YUCompatibleValue 协议。
extension CGSize: YUCompatibleValue { }
extension CGRect: YUCompatibleValue { }
