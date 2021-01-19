```objectivec
import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "test";
    }
    
    init() {
        super.init(nibName: "TestViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func alert(sender: UIButton) {
        
        
        var apperanceLabel: UILabel
        if #available(iOS 9.0, *) {
            apperanceLabel = UILabel.appearanceWhenContainedInInstancesOfClasses([UIAlertController.self])
        } else {
            apperanceLabel = UILabel.my_appearanceWhenContainedIn(UIAlertController.self)
        }
        apperanceLabel.appearanceFont = UIFont.boldSystemFontOfSize(14)
        
        let alertController = UIAlertController(title: "选择发布的内容", message: "", preferredStyle: .ActionSheet)
        
        let rect = CGRect(x: -10, y: -5, width: UIScreen.mainScreen().bounds.width, height: 300)
        
        let customView = UIImageView(frame: rect)
        customView.image = UIImage(named: "Community_action_sheet_background_image")
        customView.contentMode = .ScaleToFill
        alertController.view.addSubview(customView)
        alertController.view.sendSubviewToBack(customView)
        let color = UIColor(red: 59 / 255.0, green: 80 / 255.0, blue: 105 / 255.0, alpha: 1.0)
        let attributes = NSMutableAttributedString(string: "选择发布的内容")
//        attributes.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(14), range: NSMakeRange(0, attributes.length))
        attributes.addAttributes([NSForegroundColorAttributeName : color], range: NSMakeRange(0, attributes.length))
        alertController.setValue(attributes, forKey: "attributedTitle")
        let ok = UIAlertAction(title: "拍一张照片", style: .Default, handler: { (action) -> Void in
            print("Ok Button Pressed")
        })
        let picture = UIAlertAction(title: "相册照片", style: .Default, handler: { (action) -> Void in
            print("Ok Button Pressed")
        })
        let cancel = UIAlertAction(title: "取消", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Button Pressed")
        })
        let delete = UIAlertAction(title: "路线", style: .Destructive) { (action) -> Void in
            print("Delete Button Pressed")
        }
        
        let image = UIImage(named: "action_sheet_creama_image_icon")
        ok.setValue(image?.imageWithRenderingMode(.AlwaysOriginal), forKey: "image")
        ok.setValue(color, forKey: "titleTextColor")
        cancel.setValue(color, forKey: "titleTextColor")
        
        let image2 = UIImage(named: "action_sheet_photo_image_icon")
        picture.setValue(image2?.imageWithRenderingMode(.AlwaysOriginal), forKey: "image")
        picture.setValue(color, forKey: "titleTextColor")
        
        let image3 = UIImage(named: "action_sheet_line_image_icon")
        delete.setValue(image3?.imageWithRenderingMode(.AlwaysOriginal), forKey: "image")
        delete.setValue(color, forKey: "titleTextColor")
        
        let viewController = UIViewController()
       // viewController.view.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        cancel.setValue(viewController, forKey: "contentViewController")
        
        let alert = UIAlertController(title: "hello", message: "adaa", preferredStyle: .ActionSheet)
        alert.addAction(delete)
        picture.setValue(alert, forKey: "alertController")
        
        
      //  printLog("action:::\(delete)")
//        let height:NSLayoutConstraint =
//            NSLayoutConstraint(item: alertController.view,
//                               attribute: NSLayoutAttribute.Height,
//                               relatedBy: NSLayoutRelation.Equal,
//                               toItem: nil,
//                               attribute: NSLayoutAttribute.NotAnAttribute,
//                               multiplier: 1,
//                               constant: 260)
//                alertController.view.addConstraint(height);
        alertController.addAction(ok)
        alertController.addAction(picture)
        alertController.addAction(cancel)
        alertController.addAction(delete)
        
        
        presentViewController(alertController, animated: true, completion: nil)
    }

}

extension TestViewController {
    
    
    @IBAction func alertSheet(sender: UIButton) {
        print("action")
    }
}
```