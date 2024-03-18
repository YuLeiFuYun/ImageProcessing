//
//  ViewController.swift
//  ImageProcessing
//
//  Created by 玉垒浮云 on 2024/3/18.
//

import UIKit

enum ImageProcessingOption {
    case roundedImage
    case resize
    case crop
    case backgroundDecode
    case downsample
}

class ViewController: UIViewController {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 360),
            imageView.heightAnchor.constraint(equalToConstant: 360),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return imageView
    }()
    
    var imageViews: [UIImageView] = []
    
    var option: ImageProcessingOption = .roundedImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageProcessing(option: .roundedImage)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        switch option {
        case .roundedImage:
            imageViews.forEach { imageView in
                // 在 imageView 有确定的 size 之后再调用
                imageView.yu.setImage(.panda, cornerRadius: .heightFraction(0.5))
            }
        case .resize:
            imageView.image = .panda.yu.resize(to: CGSize(width: 500, height: 500), for: .aspectFit)
            print(imageView.image?.size ?? .zero)
        case .crop:
            imageView.image = .panda.yu.crop(to: CGSize(width: 1600, height: 800), anchorOn: .zero)
        case .backgroundDecode:
            DispatchQueue.global().async {
                let decodedImage: UIImage = .panda.yu.decoded
                DispatchQueue.main.async {
                    self.imageView.image = decodedImage
                }
            }
        case .downsample:
            let image: UIImage = .panda
            imageView.image = UIImage.yu.downsample(data: image.pngData()!, to: imageView.bounds.size)
        }
    }
    
    func imageProcessing(option: ImageProcessingOption) {
        self.option = option
        switch option {
        case .roundedImage:
            roundedImage()
        case .resize:
            resize()
        case .crop:
            crop()
        case .backgroundDecode:
            backgroundDecode()
        case .downsample:
            downsample()
        }
    }
    
    func downsample() {
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemPink
    }
    
    func crop() {
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemPink
    }
    
    func resize() {
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemPink
    }
    
    func backgroundDecode() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func roundedImage() {
        let contentModes: [UIView.ContentMode] = [.scaleAspectFit, .scaleAspectFill]
        for i in 0..<2 {
            let label = UILabel()
            label.text = i == 0 ? "contentMode = .scaleAspectFit" : "contentMode = .scaleAspectFill"
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(100 + 360 * i)),
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
            let imageView = UIImageView()
            imageView.contentMode = contentModes[i]
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.backgroundColor = .systemPink
            view.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 300),
                imageView.heightAnchor.constraint(equalToConstant: 300)
            ])
            imageViews.append(imageView)
        }
    }
}

#Preview("ViewController", traits: .defaultLayout, body: {
    ViewController()
})
