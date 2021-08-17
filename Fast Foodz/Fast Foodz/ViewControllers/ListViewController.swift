//
//  ListViewController.swift
//  Fast Foodz
//
//  Created by Jeff on 2021/8/4.
//

import UIKit

class ListViewController: YelpDataViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    private var gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let nib = UINib.init(nibName: "ListTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ListTableViewCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets(top: -420,left: 0,bottom: -450,right: 0)
        
        self.tableView.backgroundColor = .clear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as! ListTableViewCell
        let place = self.places[indexPath.row]
        cell.icon.image = UIImage(named: place.category)
        cell.title.text = place.name
        
        // set info attributed string
        let str = "$$$$ • \(place.distance) miles"
        let myMutableString = NSMutableAttributedString(string: str)
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lilacGrey, range: NSRange(location:0, length:str.count))
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.pickleGreen, range: NSRange(location:0, length:place.price.count))
        cell.info.attributedText = myMutableString
        
        // set arrow
        let arrow = UIImageView(image: UIImage(named: "chevron"))
        arrow.image = arrow.image?.withRenderingMode(.alwaysTemplate)
        arrow.tintColor = .deepIndigo
        cell.accessoryView = arrow
        
        // set background
        let selectColor = UIView()
        selectColor.backgroundColor = .powderBlue
        cell.selectedBackgroundView = selectColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.performSegue(withIdentifier: "showDetail", sender: self.places[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// =========================
//
// Color gradient
//
// =========================
extension ListViewController{
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if gradientLayer.superlayer != nil {
            gradientLayer.removeFromSuperlayer()
        }

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.colors = UIColor.gradientColors
        gradientLayer.frame = self.view.bounds
        let backgroundView = UIView(frame: self.view.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        self.tableView.backgroundView = backgroundView
                
    }
    
    func invertMask(_ image: UIImage) -> UIImage?
    {
        guard let inputMaskImage = CIImage(image: image),
            let backgroundImageFilter = CIFilter(name: "CIConstantColorGenerator", parameters: [kCIInputColorKey: CIColor.black]),
            let inputColorFilter = CIFilter(name: "CIConstantColorGenerator", parameters: [kCIInputColorKey: CIColor.clear]),
            let inputImage = inputColorFilter.outputImage,
            let backgroundImage = backgroundImageFilter.outputImage,
            let filter = CIFilter(name: "CIBlendWithAlphaMask", parameters: [kCIInputImageKey: inputImage, kCIInputBackgroundImageKey: backgroundImage, kCIInputMaskImageKey: inputMaskImage]),
            let filterOutput = filter.outputImage,
            let outputImage = CIContext().createCGImage(filterOutput, from: inputMaskImage.extent) else { return nil }
        let finalOutputImage = UIImage(cgImage: outputImage)
        return finalOutputImage
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let myCell = cell as? ListTableViewCell{
            myCell.layoutIfNeeded()
            let hole = myCell.icon.frame.integral
            let image = self.invertMask(myCell.icon.image!)
            myCell.createMask(with: hole, in: myCell, and: image!)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .white
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 500
    }
}
