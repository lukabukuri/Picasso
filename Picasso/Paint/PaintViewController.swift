

import UIKit

class PaintViewController: BaseViewController {
    
    
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    var lastPoint = CGPoint.zero
    var color = UIColor.black
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
              let settingsController = navController.topViewController as? SettingsViewController else {
            return
        }
        settingsController.delegate = self
        settingsController.brush = brushWidth
        settingsController.opacity = opacity
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        settingsController.red = red
        settingsController.green = green
        settingsController.blue = blue
    }
    
    // MARK: - Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    @IBAction func resetPressed(_ sender: Any) {
        mainImageView.image = nil
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        guard let image = mainImageView.image else {
            return
        }
        
        
        
        
        
        let alert = UIAlertController(title: "Where do you want to save image?", message: "You can save it on your iphone's gallery or inside app's gallery", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "iPhone's Gallery", style: .default, handler: { [unowned self] action in
            let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(activity, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "App's Gallery", style: .default, handler: { [unowned self] action in
            saveImage(image: image)
            
        }))
        alert.addAction(UIAlertAction(title: "Both", style: .cancel, handler: { [unowned self] action in
            let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(activity, animated: true)
            saveImage(image: image)
        }))
        
        self.present(alert, animated: true)
        
    }
    
    func saveImage( image: UIImage) {
        
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent("\(fileName).png")
        print(fileURL)
        guard let data = image.pngData() else { return }
        
        do {
            try data.write(to: fileURL)
            navigationController?.popViewController(animated: true)
        } catch let error {
            print("saving file with error", error)
        }
        
    }
    
    
    @IBAction func pencilPressed(_ sender: UIButton) {
        guard let pencil = Pencil(tag: sender.tag) else {
            return
        }
        color = pencil.color
        if pencil == .eraser {
            opacity = 1.0
        }
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: view.bounds)
        
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        
        UIGraphicsEndImageContext()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        swiped = false
        lastPoint = touch.location(in: view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        swiped = true
        let currentPoint = touch.location(in: view)
        drawLine(from: lastPoint, to: currentPoint)
        
        lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLine(from: lastPoint, to: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        tempImageView?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
}

// MARK: - SettingsViewControllerDelegate

extension PaintViewController: SettingsViewControllerDelegate {
    func settingsViewControllerFinished(_ settingsViewController: SettingsViewController) {
        brushWidth = settingsViewController.brush
        opacity = settingsViewController.opacity
        color = UIColor(red: settingsViewController.red,
                        green: settingsViewController.green,
                        blue: settingsViewController.blue,
                        alpha: opacity)
        dismiss(animated: true)
    }
}

