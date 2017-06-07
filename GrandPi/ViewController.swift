//
//  ViewController.swift
//  GrandPi
//
//  Created by Nicolas Suarez-Canton Trueba on 6/7/17.
//  Copyright © 2017 Nicolas Suarez-Canton Trueba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var nPointsInside = 0
    var nIterations = 0
    
    var monteCarloGraph: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var computeMonteCarloButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        button.setTitle("Calculate", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(dispatchMonteCarlo), for: .touchUpInside)
        
        return button
    }()
    
    var interationsSlider: UISlider = {
        let slider = UISlider(frame: CGRect(x: 0, y: 0, width:280, height: 20))
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 100
        slider.maximumValue = 10000
        slider.isContinuous = true
        slider.value = 50
        slider.tintColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        slider.layer.cornerRadius = 5
        slider.layer.masksToBounds = true
        return slider
    }()
    
    var iterationsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var piLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nIterations = Int(interationsSlider.value)
        
        view.backgroundColor = UIColor.white
        view.addSubview(monteCarloGraph)
        view.addSubview(computeMonteCarloButton)
        view.addSubview(interationsSlider)

        iterationsLabel.text = String(Int(interationsSlider.value))
        view.addSubview(iterationsLabel)
        view.addSubview(piLabel)
        
        setMonteCarloGraph()
        setComputeMonteCarloButton()
        setIterationsSlider()
        setIterationsLabel()
        setPiLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setMonteCarloGraph() {
        monteCarloGraph.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        monteCarloGraph.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        monteCarloGraph.widthAnchor.constraint(equalToConstant: 300).isActive = true
        monteCarloGraph.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func setComputeMonteCarloButton() {
        computeMonteCarloButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        computeMonteCarloButton.topAnchor.constraint(equalTo: monteCarloGraph.bottomAnchor, constant: 12).isActive = true
        computeMonteCarloButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        computeMonteCarloButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setIterationsSlider() {
        interationsSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        interationsSlider.topAnchor.constraint(equalTo: computeMonteCarloButton.bottomAnchor, constant: 12).isActive = true
        interationsSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        interationsSlider.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setIterationsLabel () {
        iterationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iterationsLabel.topAnchor.constraint(equalTo: interationsSlider.bottomAnchor, constant: 6).isActive = true
        iterationsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        iterationsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setPiLabel () {
        piLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        piLabel.topAnchor.constraint(equalTo: monteCarloGraph.topAnchor, constant: -48).isActive = true
        piLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        piLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func dispatchMonteCarlo() {
        
        for view in monteCarloGraph.subviews{
            view.removeFromSuperview()
        }
        
        nPointsInside = 0
        
        let background = DispatchQueue.global()
        let start = DispatchTime.now()
        background.async {
            self.computeMonteCarlo(iterations: self.nIterations)
        }
        
        
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime)
        print("Elapsed time: \(timeInterval) nanoseconds")
    }
    
    func sliderValueDidChange() {
        nIterations = Int(interationsSlider.value)
        iterationsLabel.text = String(Int(interationsSlider.value))
    }
    
    func computeMonteCarlo(iterations: Int) {
        
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
        
            let (x, y) = (drand48() * 2 - 1, drand48() * 2 - 1)
            let point = UIView(frame: CGRect(x: 3 * (x + 1) * 50, y: 3 * (y + 1) * 50, width: 3, height: 3))
            
            if x * x + y * y <= 1 {
                nPointsInside += 1
                point.backgroundColor = UIColor.red
            } else {
                point.backgroundColor = UIColor.blue
            }
            
            DispatchQueue.main.async {
                self.monteCarloGraph.addSubview(point)
                let pi = 4.0 * Double(self.nPointsInside) / Double(self.nIterations)
                self.piLabel.text = String(pi)
            }
        }
    }
    
    func computeMonteCarloSerial(iterations: Int) {
        for _ in 0...iterations {
        
            let (x, y) = (drand48() * 2 - 1, drand48() * 2 - 1)
            let point = UIView(frame: CGRect(x: 3 * (x + 1) * 50, y: 3 * (y + 1) * 50, width: 3, height: 3))
            
            if x * x + y * y <= 1 {
                nPointsInside += 1
                point.backgroundColor = UIColor.red
            } else {
                point.backgroundColor = UIColor.blue
            }
            
            monteCarloGraph.addSubview(point)
        }
    }
}

