//
//  DisplayPdfVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/14/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

  //      details_98_0_20200831053826_97.pdf
//http://urampos.com/khalil/images/details_98_0_20200831053826_97.pdf

import UIKit
import PDFKit
import JSSAlertView


class DisplayPdfVC: UIViewController, PDFDelegate, UIDocumentPickerDelegate {
    /**
     * This view is on the screen so that the PDFView is not blocked off
     */
    @IBOutlet weak var holdingView: UIView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    /**
  
     * A variable to hold onto the current page
     */
    var currentPage: Int = 0
    /**
     * The PDF Drawing View
     */
    var pdfView: PDFDrawingView!
    var pdfURL : URL!
    var stringurl : String!
    
    
    override func viewDidLoad() {
         indicator.startAnimating()
    }

    override func viewDidAppear(_ animated: Bool) {
     //   downloadPdf(fileUrl : "https://www.tutorialspoint.com/swift/swift_tutorial.pdf")
        print(stringurl)
         downloadPdf(fileUrl : stringurl!)
    }
    // MARK: These will all be called after a button is pressed
    // Changes the key to erasing
    @IBAction func changeToErase(_ sender: Any) {
        pdfView.drawingKey = PDFDrawingView.DrawingKeys.erase
    }
    // Changes the key to lasso
    @IBAction func changeToLasso(_ sender: Any){
        pdfView.drawingKey = PDFDrawingView.DrawingKeys.lasso
    }
    // Changes the key to drawing
    @IBAction func changeToScroll(_ sender: Any) {
        pdfView.drawingKey = PDFDrawingView.DrawingKeys.scroll
    }
    // Changes the key to text
    @IBAction func changeToText(_ sender: Any) {
        pdfView.drawingKey = PDFDrawingView.DrawingKeys.text
    }
    // Changes the key to highlight
    @IBAction func changeToHighlight(_ sender: Any) {
        pdfView.drawingKey = PDFDrawingView.DrawingKeys.highlight
    }
    // Changes the key to draw
    @IBAction func changeToDraw(_ sender: Any) {
        pdfView.drawingKey = PDFDrawingView.DrawingKeys.draw
    }
    
    @IBAction func saveAfterDraw(_ sender: Any) {
        let pdfData = self.pdfView.createPDF()
        let updatedDocument = PDFDocument(data: pdfData)
        updatedDocument?.write(to: pdfURL)

        let url = pdfURL
        var documentPicker: UIDocumentPickerViewController? = nil
        if let url = url {
            documentPicker = UIDocumentPickerViewController(url: url, in: .exportToService)
        }
        documentPicker?.delegate = self
        if let documentPicker = documentPicker {
            present(documentPicker, animated: true)
        }        //pdfView?.document.write(to: pdfURL , options: .atomicWrite)
        print("sayed : \(pdfURL)")
        JSSAlertView().success(self,title: "حسنا",text: "تم التحميل بنجاح")
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let myURL = urls.first else {
                return
            }
            print("export result : \(myURL)")
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
    }
    // MARK: Delegate methods being implemented
    func scrolled(to page: Int) {
        self.currentPage = page
    }
    func viewWasCreated() {
        return
    }
    ////
    func downloadPdf(fileUrl :String) {
            guard let url = URL(string: fileUrl) else { return }
            
            let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            
            let downloadTask = urlSession.downloadTask(with: url)
            downloadTask.resume()
        }
}
extension DisplayPdfVC:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            self.pdfURL = destinationURL
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
                if  let pdf = PDFDocument(url: self.pdfURL){
                    self.pdfView = PDFDrawingView(frame: self.holdingView.bounds, document: pdf, style: .vertical, delegate: self)
                    self.holdingView.addSubview(self.pdfView)
                    self.pdfView.drawingKey = PDFDrawingView.DrawingKeys.scroll
                }
            }
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}

