//
//  ListTableViewCell.swift
//  Fast Foodz
//
//  Created by Jeff on 2021/8/6.
//

import Foundation
import UIKit

class ListTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var info: UILabel!
    
    var seperator: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .londonSky
        return line
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title.textColor = .deepIndigo
        self.info.textColor = .lilacGrey
        self.icon.image = self.icon.image?.withRenderingMode(.alwaysTemplate)
        self.icon.tintColor = .clear

        addSubview(seperator)
        NSLayoutConstraint.activate([
            seperator.bottomAnchor.constraint(equalTo:bottomAnchor, constant: 0),
            seperator.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            seperator.rightAnchor.constraint(equalTo: rightAnchor, constant: -12),
            seperator.heightAnchor.constraint(equalToConstant: 2)
            ])
    }
    
    func createMask(with hole: CGRect, in cell: ListTableViewCell, and image: UIImage){
        let resizeImage = image.resizeImage(newWidth: 32)
        let size = CGSize(width: cell.frame.width, height: cell.frame.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        let p = UIBezierPath(rect: cell.bounds)
        UIColor.black.setFill()
        p.fill()
        let cp = UIBezierPath(rect: hole)
        cp.fill(with: CGBlendMode.clear, alpha: 1.0)
        resizeImage.draw(at: CGPoint(x: hole.minX, y: hole.minY))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let maskLayer = CALayer()
        maskLayer.contents = img!.cgImage
        maskLayer.frame = cell.bounds
        cell.layer.mask = maskLayer
    }
}


extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage {

        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
