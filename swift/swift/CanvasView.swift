//
//  CanvasView.swift
//  swift
//
//  Created by keith on 2022/1/30.
//

import UIKit

class CanvasView: UIView {
    
    @objc public var pathColor: UIColor! = .black {
        didSet {

        }
    }
    
    private var path: UIBezierPath!
    private var pathArray: Array<UIBezierPath>! = []
    private var previousPoint: CGPoint! = CGPoint.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCanvas()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCanvas()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initCanvas()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for bezier: UIBezierPath? in pathArray {
            pathColor.set()
            bezier!.stroke()
        }
    }
    
    private func initCanvas() {
        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(pan))
        self.addGestureRecognizer(pan)
        
        self.path = UIBezierPath()
        self.path.lineJoinStyle = .round
    }
    
    @objc private func pan(pan: UIPanGestureRecognizer) {
        let currentPoint: CGPoint = pan.location(in: self)
        let midPoint = getMidPoint(p1: previousPoint, p2: currentPoint)
        if(pan.state == .began) {
            path = UIBezierPath()
            path.lineWidth = 20.0
            path.move(to: currentPoint)
            pathArray.append(path)
        }
        if(pan.state == .changed) {
            path.addQuadCurve(to: midPoint, controlPoint: previousPoint)
        }
        previousPoint = currentPoint
        self.setNeedsDisplay()
    }
    
    private func getMidPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x)/2, y: (p1.y + p2.y)/2)
    }
    
    func clear() {
        pathArray.removeAll()
        self.setNeedsDisplay()
    }
    
    func revoke() {
        pathArray.remove(at: pathArray.count - 1)
        self.setNeedsDisplay()
    }
    
    func saveImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0);
        self.layer.render(in: (UIGraphicsGetCurrentContext())!)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        let data = image.jpegData(compressionQuality: 0.8)
        return UIImage(data: data! )!
    }
}
