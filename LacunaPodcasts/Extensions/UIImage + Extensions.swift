//
//  UIImage + Extensions.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-01.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

extension UIImage {
    
    var averageColor: UIColor? {
        
        // convert image to Core Image
        guard let inputImage = CIImage(image: self) else { return nil }
        
        // create an extent vector (a frame with width and height of our current input image)
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)
        
        // create a CIAreaAverage filter so we can pull the average colour from the image later
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        // a bitmap consisting of (r, g, b, a) values
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])

        // render output image into a 1 by 1 image supplying it our bitmap to update the values
        // ie. the rgba of the 1 by 1 image will fill out the bitmap array
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)
        
        // convert our bitmap image of r, g, b, a to a UIColor
        return UIColor(red: CGFloat(bitmap[0]) / 255,
                       green: CGFloat(bitmap[1]) / 255,
                       blue: CGFloat(bitmap[2]) / 255,
                       alpha: CGFloat(bitmap[3]) / 255)
    }
    
}

extension UIImageView {
    public func roundCorners(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        //self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}
