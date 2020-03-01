import UIKit

class RoundedImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 2.0
        layer.masksToBounds = false
        layer.borderColor = UIColor.init(named: "DarkBlue")!.cgColor
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
        layer.zPosition = -500;
    }
    
}
