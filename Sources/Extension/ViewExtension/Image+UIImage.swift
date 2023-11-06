//
//  Image+UIImage.swift
//
//
//  Created by Narumichi Kubo on 2023/11/06.
//

import SwiftUI

public extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        controller.view.layoutIfNeeded()
        let size = controller.sizeThatFits(in: CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        let view = controller.view
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
