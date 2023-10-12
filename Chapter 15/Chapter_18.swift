/*
 Chapter - 18
 Networking in iOS Apps
 */

import UIKit
import Foundation
import SystemConfiguration
import AVFoundation

open class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
        
    }
    
    class func isServerConnect(webSiteToPing: String?, completionHandler: @escaping (Bool) -> Void) {
        
        // 1. Check the Internet Connection
        guard isConnectedToNetwork() else {
            completionHandler(false)
            return
        }
        
        // 2. Check the Server Connection
        var webAddress = "https://www.xyz.com" // Your Server base URL
        if let _ = webSiteToPing {
            webAddress = webSiteToPing!
        }
        
        guard let url = URL(string: webAddress) else {
            completionHandler(false)
            print("could not create url from: \(webAddress)")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil || response == nil {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        })
        
        task.resume()
    }
    
}

//  Below Code will work only with Alamofire Framework (A Custom library)

struct Login: Encodable {
    let email: String
    let password: String
}

let login = Login(email: "test@test.test", password: "Password")

AF.request("https://samplesiteurl.org/post",
           method: .post,
           parameters: login,
           encoder: JSONParameterEncoder.default
           headers: headers).response { response in
            debugPrint(response)
           }

AF.request("https://samplesiteurl.org/get")
    .validate(statusCode: 200..<300)
    .validate(contentType: ["application/json"])
    .responseData { response in
        switch response.result {
        case .success:
            print("Validation Successful")
        case let .failure(error):
            print(error)
        }
    }

let imageView = UIImageView(frame: frame)
let url = URL(string: "https://sampleImagesite.org/image/png")!
imageView.af.setImage(withURL: url)

let pImage = UIImage(named: "placeholder.png")
imageView.af.setImage(withURL: url, placeholderImage: pImage)

let imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .fifo,
        maximumActiveDownloads: 4,
        imageCache: AutoPurgingImageCache()
    )

let downloader = ImageDownloader()
   let urlRequest = URLRequest(url: URL(string: "https://sampleImagesite.org/image/jpeg")!)

   downloader.download(urlRequest) { response in
       print(response.request)
       print(response.response)
       debugPrint(response.result)

       if case .success(let image) = response.result {
           print(image)
       }
   }

class Download: UIViewController
{

// URL session
fileprivate var operations = [Int: DownloadOperation]()
private let queue: OperationQueue = {
            let _queue = OperationQueue()
            _queue.name = "download"
            _queue.maxConcurrentOperationCount = 1
            return _queue
        }()


func addDownload(_ url: URL) -> DownloadOperation
{
     let operation = DownloadOperation(session: session, url: url)
     operations[operation.task.taskIdentifier] = operation
     queue.addOperation(operation)
     return operation
}
 
func cancelAll()
{
     queue.cancelAllOperations()
}

lazy var session: URLSession = {
            let config = URLSessionConfiguration.default
            return URLSession(configuration: config, delegate: self, delegateQueue: nil)
}()

}

extension Download: URLSessionDownloadDelegate
{
 
func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
{
    operations[downloadTask.taskId]?.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
}
 
func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
{
   operations[downloadTask.taskIdentifier]?.urlSession(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
 }
}
 
// MARK: URLSessionTaskDelegate methods
extension Download: URLSessionTaskDelegate {
 
func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
{
    let key = task.taskIdentifier
            operations[key]?.urlSession(session, task: task, didCompleteWithError: error)
            operations.removeValue(forKey: key)
}








