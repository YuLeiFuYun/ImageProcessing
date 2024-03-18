//
//  CGSize+Ex.swift
//  ImageProcessing
//
//  Created by 玉垒浮云 on 2024/3/18.
//

import CoreGraphics
import func AVFoundation.AVMakeRect

extension YUWrapper where Base == CGSize {
    var aspectRatio: CGFloat {
        base.height == 0.0 ? 1.0 : base.width / base.height
    }
    
    // resize 方法接受一个 desiredSize 和 contentMode 参数，返回调整后的 CGSize。
    func resize(to desiredSize: CGSize, for contentMode: ContentMode = .aspectFit) -> CGSize {
        var targetSize: CGSize
        switch contentMode {
        case .none:
            // 如果 contentMode 为 .none，则直接使用 desiredSize 作为目标尺寸。
            targetSize = desiredSize
        case .aspectFit:
            // 如果 contentMode 为 .aspectFit，使用 AVMakeRect 计算适合内部矩形的宽高比。
            // 这保证了尺寸调整后的大小将完全适应指定区域，同时保持原始的宽高比。
            let rect = AVFoundation.AVMakeRect(aspectRatio: base, insideRect: .init(origin: .zero, size: desiredSize))
            targetSize = rect.size
        case .aspectFill:
            // 如果 contentMode 为 .aspectFill，计算缩放因子以填充目标区域，同时保持原始的宽高比。
            // 这可能会导致目标尺寸超出 desiredSize 指定的范围。
            let scalingFactor = max(desiredSize.width / base.width, desiredSize.height / base.height)
            targetSize = CGSize(width: base.width * scalingFactor, height: base.height * scalingFactor)
        }
        
        return targetSize
    }
    
    // 计算给定尺寸和锚点的约束矩形。
    func constrainedRect(for size: CGSize, anchor: CGPoint) -> CGRect {
        // 确保锚点的x和y值位于[0, 1]的范围内，防止超出范围的值。
        let unifiedAnchor = CGPoint(x: anchor.x.clamped(to: 0.0...1.0),
                                    y: anchor.y.clamped(to: 0.0...1.0))
        
        // 计算裁剪矩形的起始点。基于锚点和目标尺寸与基础尺寸的关系进行计算。
        let x = unifiedAnchor.x * base.width - unifiedAnchor.x * size.width
        let y = unifiedAnchor.y * base.height - unifiedAnchor.y * size.height
        // 创建裁剪矩形。
        let r = CGRect(x: x, y: y, width: size.width, height: size.height)
        
        // 创建一个原点为(0, 0)，尺寸为基础尺寸的CGRect。
        let ori = CGRect(origin: .zero, size: base)
        // 返回两个矩形的交集，即最终的约束矩形。
        return ori.intersection(r)
    }
}

extension YUWrapper where Base == CGRect {
    // 根据给定的缩放比例，返回缩放后的CGRect。
    func scaled(_ scale: CGFloat) -> CGRect {
        CGRect(x: base.origin.x * scale, y: base.origin.y * scale, width: base.size.width * scale, height: base.size.height * scale)
    }
}

// 为所有可比较类型提供一个方法，将值限制在给定范围内。
private extension Comparable {
    // 将当前值限制在闭区间limits内。
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
