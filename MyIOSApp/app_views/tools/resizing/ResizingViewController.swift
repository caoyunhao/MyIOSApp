//
//  ResizingViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/17.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import Photos
import CoreImage
import MobileCoreServices

class ResizingViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editSwitch: UISwitch!
    
    @IBOutlet weak var targetWidthTextField: UITextField!
    @IBOutlet weak var targetHeightTextField: UITextField!
    @IBOutlet weak var keepRatioSwitch: UISwitch!
    
    @IBOutlet weak var imageOriginSizeLabel: UILabel!
    @IBOutlet weak var imageConvertedSizeLabel: UILabel!
    @IBOutlet weak var imageOriginDataSizeLabel: UILabel!
    @IBOutlet weak var imageConvertedDataSizeLabel: UILabel!
    
    @IBOutlet weak var whileOpenLabel: UILabel!
    @IBOutlet weak var imageOriginTextLabel: UILabel!
    @IBOutlet weak var imageConvertedTextLabel: UILabel!
    @IBOutlet weak var keepOriginRatioLabel: UILabel!
    
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var rotate90Button: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var openAlbumButton: UIButton!
    
    @IBOutlet weak var gifFramesCountPreSecondLabel: UILabel!
    @IBOutlet weak var gifOriginFramesCountPreSecondDisplay: UILabel!
    @IBOutlet weak var gifTargetFramesCountPreSecondDisplay: UITextField!
    
    @IBOutlet weak var imageInfoButton: UIButton!
    
    fileprivate var _image: CYHImage!
    private var selectedImage: UIImage!
    private var imageOriginData: Data!
    private var originRatio: Float!
    
    private var imageConvertedSize: CGSize!
    private var convertedImage: UIImage!
    
    private var picked: Bool =  false
    private var computed: Bool = false
    
    fileprivate var rotateRate: Int = 0
    
    private var photosHelper: PhotosPickerUtils!
    
    private var targetSize: CGSize? {
        return CGSize(width: Int(targetWidthTextField.text!)!, height: Int(targetHeightTextField.text!)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        title = "Resize Image"
        
        self.targetWidthTextField.delegate = self
        self.targetHeightTextField.delegate = self
        self.scrollView.delegate = self
        
        self.scrollView.addOnClickListener(target: self, action: #selector(self.tapClick(sender:)))
        
        self.setUI()
        
        photosHelper = PhotosPickerUtils(vc: self)
    }
    
    @objc func tapClick(sender:UIView){
        self.scrollView.endEditing(true)
    }
    
    @IBAction func pickFromAlbum() {
        photosHelper.pick {(image) in
            self.pickCallback(image: image)
        }
    }
    
    @IBAction func save(_ sender: AnyObject) {
        var image = self._image.resize(self.targetSize!)
        for _ in 0..<(self.rotateRate / 90) {
            image = image.rotateLeft90();
        }
        
        let s = gifTargetFramesCountPreSecondDisplay.text
        
        let d = Double(s!)

        ImageUtils.save(CYHImage(uiImages: image.images, duration: d ?? image.duration));
        
        AlertUtils.biAction(vc: self, message: "保存成功", leftTitle: "转到相册", rightTitle: "我知道了", leftAction: {
            SystemUtils.openPhotos();
        }, rightAction: nil)
    }
    
    @IBAction func resetImage(_ sender: AnyObject) {

    }
    
    @IBAction func rotateLeft90(_ sender: AnyObject) {
        self.rotateRate = (self.rotateRate + 90) % 360
        UIView.animate(withDuration: 0.3) {
            self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2 * Double(self.rotateRate / 90)))
        }
//        AlertUtils.simple(vc: self, message: "rotate left \(self.rotateRate)°")
    }
    
    fileprivate func pickCallback (image: CYHImage) {
        self._image = image
        self.imageOriginSizeLabel.text = format(size: image.size)
        handleNew(image: image)
    }
    
    fileprivate func saveCallback (localId: String) {
        //通过标志符获取对应的资源
        let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: [localId], options: nil)
        let asset = assetResult[0]
        
        AssetsUtils.handleImageData(of: asset) { (data) in
            self.imageConvertedDataSizeLabel.text = self.formatDataSize(size: data.count)
        }
    }
    
    func handleNew(image: CYHImage) {
        DLog(message: "handleNew")
        setImageView(image: image)
        
        let width = String(format: "%d", Int((image.size.width)))
        let height = String(format: "%d", Int((image.size.height)))
        
        self.targetWidthTextField.text = width
        self.targetHeightTextField.text = height
        self.setConvertPixel(width: width, height: height)
        
        self.originRatio = image.ratio
        self.computed = false
        
        self.gifOriginFramesCountPreSecondDisplay.text = String(format: "%.2f", image.duration)
    }
    
    func compute() {
        if self.checkImageConvertedSize() {
            DLog(message: "Converted Size: \(self.imageConvertedSize.debugDescription)")
            self.convertedImage = self.selectedImage.e_resize(size: self.imageConvertedSize!)
            self.computed = true
        } else {
            DLog(message: "checkImageConvertedSize = false")
        }
    }
    
    func setConvertPixel(width: String?, height: String?) {
        if width != nil && height != nil {
            self.imageConvertedSizeLabel.text = "\(width!)*\(height!)"
        } else {
            self.imageConvertedSizeLabel.text = "-"
        }
    }
    
    func sizeToString(width: String, height: String) -> String {
        return "\(width)*\(height)"
    }
    
    func format(size: CGSize?) -> String {
        guard let size = size else {
            return "-"
        }
        return String(format: "%d*%d", Int(size.width), Int(size.height))
    }
    
    func formatDataSize(size: Int) -> String {
        return String(format: "%d KB", size / 1024)
    }
    
    func checkImageConvertedSize() -> Bool {
        let widthText = self.targetWidthTextField.text
        let heightText = self.targetHeightTextField.text
        if widthText != nil && heightText != nil {
            if !widthText!.isEmpty && !heightText!.isEmpty {
                self.imageConvertedSize = CGSize(
                    width: CGFloat(Float(widthText!)!),
                    height: CGFloat(Float(heightText!)!)
                )
                return true
            }
        }
        return false
    }
    
    func setImageView(image: CYHImage) {
        DLog(message: "Set CYHImage")
        self.imageView.stopAnimating()
        self.imageView.animationImages = image.images
        self.imageView.animationDuration = image.duration
        self.imageView.animationRepeatCount = 0
        self.imageView.startAnimating()
    }
    
    func handleInput() {
        
    }
    
    @IBAction
    fileprivate func openPhotos() {
        SystemUtils.openPhotos()
    }
    
    @IBAction
    fileprivate func popImageInfo() {
        guard _image != nil else {
            pickFromAlbum()
            return
        }
        
        let vc = CommonUtils.loadNib(ofViewControllerType: TextFieldViewController.self) as! TextFieldViewController
        
        vc.text = _image.description
        vc.isPop = true
        vc.title = "Info"
        
        let nav = UINavigationController(rootViewController: vc);
        
        self.present(nav, animated: true)
    }
    
    fileprivate func alert(message: String) {
        AlertUtils.simple(vc: self, message: message)
    }
    
    fileprivate func setUI() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        //        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        for subview in self.scrollView.subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        scrollView.alwaysBounceVertical = true
        
        ConstraintUtil.alignCompletely(self.view, child: scrollView)
        //        ConstraintUtil.alignCompletely(scrollView, child: contentView)
        
        let contentView = scrollView!
        
        ConstraintUtil.alignTop(imageView, to: contentView)
        ConstraintUtil.alignLeft(imageView, to: contentView)
        ConstraintUtil.alignRight(imageView, to: contentView)
        ConstraintUtil.alignWidth(imageView, to: contentView)
        ConstraintUtil.setHeight(imageView, contentView.frame.size.width * 0.75)
        
//        ConstraintUtil.align(whileOpenLabel, below: imageView, where: contentView, offset: 20)
//        ConstraintUtil.alignLeft(whileOpenLabel, to: contentView, offset: 20)
        
//        ConstraintUtil.alignCenterY(editSwitch, to: whileOpenLabel, where: contentView)
//        ConstraintUtil.alignRight(editSwitch, to: contentView, where: contentView, offset: 20)
        // gif label
        ConstraintUtil.align(gifFramesCountPreSecondLabel, below: imageView, where: contentView, offset: 20)
        ConstraintUtil.alignLeft(gifFramesCountPreSecondLabel, to: contentView, offset: 20)
        
        // gif origin
        ConstraintUtil.alignRight(gifOriginFramesCountPreSecondDisplay, at: gifFramesCountPreSecondLabel, where: contentView, offset: 20)
        ConstraintUtil.alignCenterY(gifOriginFramesCountPreSecondDisplay, to: gifFramesCountPreSecondLabel, where: contentView)
        
        // gif target
        ConstraintUtil.alignRight(gifTargetFramesCountPreSecondDisplay, at: gifOriginFramesCountPreSecondDisplay, where: contentView, offset: 20)
        ConstraintUtil.alignCenterY(gifTargetFramesCountPreSecondDisplay, to: gifOriginFramesCountPreSecondDisplay, where: contentView)
        ConstraintUtil.setWidth(gifTargetFramesCountPreSecondDisplay, 100)
        
        // selectImageButton
        ConstraintUtil.align(selectImageButton, below: gifFramesCountPreSecondLabel, where: contentView, offset: 20)
        ConstraintUtil.alignLeft(selectImageButton, to: contentView, offset: 20)
        
        // resetButton
        ConstraintUtil.alignRight(resetButton, at: selectImageButton, where: contentView, offset: 20)
        ConstraintUtil.alignCenterY(resetButton, to: selectImageButton, where: contentView)
        
        // rotate90Button
        ConstraintUtil.alignCenterY(rotate90Button, to: selectImageButton, where: contentView)
        ConstraintUtil.alignRight(rotate90Button, to: contentView, where: contentView, offset: 20)
        
        let labelWidth = (contentView.frame.size.width - imageConvertedTextLabel.frame.size.width - 120) / 2.0
        DLog(message: labelWidth)
        
        // origin label
        ConstraintUtil.align(imageOriginTextLabel, below: selectImageButton, where: contentView, offset: 20)
        ConstraintUtil.alignLeft(imageOriginTextLabel, to: contentView, offset: 20)
        
        ConstraintUtil.alignCenterY(imageOriginDataSizeLabel, to: imageOriginTextLabel, where: contentView)
        ConstraintUtil.alignRight(imageOriginDataSizeLabel, to: contentView, offset: 20)
        ConstraintUtil.setWidth(imageOriginDataSizeLabel, labelWidth)
        
        ConstraintUtil.alignCenterY(imageOriginSizeLabel, to: imageOriginTextLabel, where: contentView)
        ConstraintUtil.alignLeft(imageOriginSizeLabel, at: imageOriginDataSizeLabel, where: contentView)
        ConstraintUtil.setWidth(imageOriginSizeLabel, labelWidth)
        
        // converted label
        ConstraintUtil.align(imageConvertedTextLabel, below: imageOriginTextLabel, where: contentView, offset: 20)
        ConstraintUtil.alignLeft(imageConvertedTextLabel, to: contentView, offset: 20)
        
        ConstraintUtil.alignCenterY(imageConvertedDataSizeLabel, to: imageConvertedTextLabel, where: contentView)
        ConstraintUtil.alignRight(imageConvertedDataSizeLabel, to: contentView, offset: 20)
        ConstraintUtil.setWidth(imageConvertedDataSizeLabel, labelWidth)
        
        ConstraintUtil.alignCenterY(imageConvertedSizeLabel, to: imageConvertedTextLabel, where: contentView)
        ConstraintUtil.alignLeft(imageConvertedSizeLabel, at: imageConvertedDataSizeLabel, where: contentView)
        ConstraintUtil.setWidth(imageConvertedSizeLabel, labelWidth)
        
        let textFieldWidth = (contentView.frame.size.width - 120) / 2.0
        
        ConstraintUtil.align(targetWidthTextField, below: imageConvertedTextLabel, where: contentView, offset: 20)
        ConstraintUtil.alignLeft(targetWidthTextField, to: contentView, offset: 20)
        ConstraintUtil.setWidth(targetWidthTextField, textFieldWidth, where: contentView)
        
        ConstraintUtil.alignCenterY(targetHeightTextField, to: targetWidthTextField, where: contentView)
        ConstraintUtil.alignRight(targetHeightTextField, to: contentView, offset: 20)
        ConstraintUtil.setWidth(targetHeightTextField, textFieldWidth, where: contentView)
        
        ConstraintUtil.align(keepOriginRatioLabel, below: targetWidthTextField, where: contentView, offset: 20)
        ConstraintUtil.alignLeft(keepOriginRatioLabel, to: contentView, offset: 20)
        
        ConstraintUtil.alignCenterY(keepRatioSwitch, to: keepOriginRatioLabel, where: contentView)
        ConstraintUtil.alignRight(keepRatioSwitch, to: contentView, offset: 20)
        
        // open album button
        ConstraintUtil.align(openAlbumButton, below: keepRatioSwitch, where: contentView, offset: 20)
        ConstraintUtil.alignRight(openAlbumButton, to: contentView, offset: 20)
        
        ConstraintUtil.align(imageInfoButton, below: keepOriginRatioLabel, where: contentView, offset: 20)
        ConstraintUtil.alignLeft(imageInfoButton, to: contentView, offset: 20)
        // save button
        
        ConstraintUtil.alignLeft(saveButton, at: openAlbumButton, where: contentView, offset: 20)
        ConstraintUtil.alignCenterY(saveButton, to: openAlbumButton, where: contentView)
        
        ConstraintUtil.alignBottom(openAlbumButton, to: contentView, offset: 20)
        
        scrollView.canCancelContentTouches = true
        scrollView.delaysContentTouches = false
        
        DLog(message: "scrollView.frame.size  \(scrollView.frame.size)")
        DLog(message: "scrollView.contentSize \(scrollView.contentSize)")
        DLog(message: "contentView.frame.size \(contentView.frame.size)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ResizingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 获取完整字符串
        let newText = String(NSString(string: textField.text!).replacingCharacters(in: range, with: string))
        if let ratio = self.originRatio {
            if self.keepRatioSwitch.isOn {
                if textField == self.targetWidthTextField {
                    if !newText.isEmpty {
                        let ret = Float(newText)! / ratio
                        let retText = String(format: "%d", Int(ceil(ret)))
                        self.targetHeightTextField.text = retText
                        setConvertPixel(width: newText, height: retText)
                    } else {
                        self.targetHeightTextField.text = ""
                        setConvertPixel(width: nil, height: nil)
                    }
                } else {
                    if !newText.isEmpty {
                        let ret = Float(newText)! * ratio
                        let retText = String(format: "%d", Int(ceil(ret)))
                        self.targetWidthTextField.text = retText
                        setConvertPixel(width: retText, height: newText)
                    } else {
                        self.targetWidthTextField.text = ""
                        setConvertPixel(width: nil, height: nil)
                    }
                }
            } else {
                if textField == self.targetWidthTextField {
                    if !newText.isEmpty {
                        setConvertPixel(width: newText, height: self.targetHeightTextField.text)
                    } else {
                        setConvertPixel(width: nil, height: nil)
                    }
                } else {
                    if !newText.isEmpty {
                        setConvertPixel(width: self.targetWidthTextField.text, height: newText)
                    } else {
                        setConvertPixel(width: nil, height: nil)
                    }
                }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame.origin.y = -220
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame.origin.y = 0
        })
    }
}

extension ResizingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.endEditing(true)
    }
}
