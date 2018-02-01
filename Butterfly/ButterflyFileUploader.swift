//
//  ButterflyFileUploader.swift
//  Butterfly
//
//  Created by Zhijie Huang on 15/7/30.
//
//  Copyright (c) 2015 Zhijie Huang <wongzigii@outlook.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//  Largely based on this stackoverflow question:
//  http://stackoverflow.com/questions/26121827/uploading-file-with-parameters-using-alamofire/28467829//

import Foundation
import Alamofire

private struct ButterflyFileUploadInfo {
    var name: String?
    var mimeType: String?
    var fileName: String?
    var url: URL?
    var data: Data?
    
    init( name: String, withFileURL url: URL, withMimeType mimeType: String? = nil ) {
        self.name = name
        self.url = url
        self.fileName = name
        self.mimeType = "application/octet-stream"
        if let mimeType = mimeType {
            self.mimeType = mimeType
        }
        
        let _name = url.lastPathComponent
        // if let _name = url.lastPathComponent {
            fileName = _name
        // }
        
        let _extension = url.pathExtension
        // if let _extension = url.pathExtension {
            switch _extension.lowercased() {
            case "jpeg", "jpg":
                self.mimeType = "image/jpeg"
                
            case "png":
                self.mimeType = "image/png"
                
            default:
                self.mimeType = "application/octet-stream"
            }
        // }
    }
    
    init( name: String, withData data: Data, withMimeType mimeType: String ) {
        self.name = name
        self.data = data
        self.fileName = name
        self.mimeType = mimeType
    }
}

private let sharedInstance = ButterflyFileUploader()

open class ButterflyFileUploader {
    
    /// The response received from the server, if any.
    open var response: HTTPURLResponse? { return self.startUploading(request: self.request)?.response }
    
    // MARK: - Private instance
    fileprivate var parameters = [String: String]()
    fileprivate var files = [ButterflyFileUploadInfo]()
    fileprivate var headers = [String: String]()
    
    // @discussion Make sure your serverURLString is valid before a further application.
    //             Call `setServerURLString` to replace the default "http://myserver.com/uploadFile" with your own's.
    open var serverURLString: String? = "http://myserver.com/uploadFile"
    
    ///
    /// Set uploader 's server URL
    ///
    /// @param     URL         The server URL.
    ///
    open func setServerURLString( _ URL: String ) {
        serverURLString = URL
    }
    
    open class var sharedUploader: ButterflyFileUploader {
        return sharedInstance;
    }
    
    ///
    /// @abstract Set the parameters of file content in the `Content-Disposition` HTTP header.
    ///
    /// @param    value        The value to associate with the file content in the `Content-Disposition` HTTP header.
    /// @param    parameter    The parameter to associate with the file content in the `Content-Disposition` HTTP header.
    ///
    open func setValue( _ value: String!, forParameter parameter: String ) {
        parameters[parameter] = value
    }
    
    ///
    /// @abstract Set the parameters of file content in the `Content-Disposition` HTTP header.
    ///
    /// @param    map          The key and value of map to associate with the file content in the `Content-Disposition` HTTP header.
    ///
    open func addParametersFrom( map: [String: String?] ) {
        for (key,value) in map {
            parameters[key] = value
        }
    }
    
    ///
    /// @abstract Sets the value of the given HTTP header field.
    /// @discussion If a value was previously set for the given header field, that value is replaced with the given value.
    /// Note that, in keeping with the HTTP RFC, HTTP header field names are case-insensitive.
    ///
    /// @param    value        The header field value.
    /// @param    header       The header field name (case-insensitive).
    ///
    open func setValue( _ value: String!, forHeader header: String ) {
        headers[header] = value
    }
    
    ///
    /// Set the parameters of file content in the `Content-Disposition` HTTP header.
    ///
    /// @param    value        The value to associate with the file content in the `Content-Disposition` HTTP header.
    ///
    /// @param    parameter    The parameter to associate with the file content in the `Content-Disposition` HTTP header.
    ///
    open func addHeadersFrom( map: [String: String?] ) {
        for (key,value) in map {
            headers[key] = value
        }
    }
    
    ///
    /// Add one file or multiple files with file URL to uploader.
    ///
    /// @param    url          The URL of the file whose content will be encoded into the multipart form data.
    ///
    /// @param    name         The name to associate with the file content in the `Content-Disposition` HTTP header.
    ///
    /// @param    mimeType     The MIME type to associate with the data in the `Content-Type` HTTP header.
    ///
    open func addFileURL( _ url: URL, withName name: String, withMimeType mimeType: String? = nil ) {
        files.append( ButterflyFileUploadInfo( name: name, withFileURL: url, withMimeType: mimeType ) )
    }
    
    ///
    /// Add one file or multiple files with NSData to uploader.
    ///
    /// @param    data         The data to encode into the multipart form data.
    ///
    /// @param    name         The name to associate with the file content in the `Content-Disposition` HTTP header.
    ///
    /// @param    mimeType     The MIME type to associate with the data in the `Content-Type` HTTP header.
    ///
    open func addFileData( _ data: Data, withName name: String, withMimeType mimeType: String = "application/octet-stream" ) {
        files.append( ButterflyFileUploadInfo( name: name, withData: data, withMimeType: mimeType ) )
    }
    
    lazy var request: NSMutableURLRequest = {
        var urlRequest = NSMutableURLRequest()
        urlRequest.httpMethod = "POST"
        urlRequest.url = URL(string: ButterflyFileUploader.sharedUploader.serverURLString!)
        return urlRequest
        }()
    
    // MARK: - Private Method
    
    internal func startUploading( request sourceRequest: NSURLRequest? ) -> Request? {
        var request = sourceRequest!.mutableCopy() as! URLRequest
        let boundary = "FileUploader-boundary-\(arc4random())-\(arc4random())"
        request.setValue( "multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var data = Data()
        
        for (name, value) in headers {
            request.setValue(value, forHTTPHeaderField: name)
        }
        
        // Amazon S3 (probably others) wont take parameters after files, so we put them first
        for (key, value) in parameters {
            data.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".data(using: String.Encoding.utf8)!)
        }
        
        for fileUploadInfo in files {
            data.append( "\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)! )
            data.append( "Content-Disposition: form-data; name=\"\(String(describing: fileUploadInfo.name))\"; filename=\"\(String(describing: fileUploadInfo.fileName))\"\r\n".data(using: String.Encoding.utf8)!)
            data.append( "Content-Type: \(String(describing: fileUploadInfo.mimeType) )\r\n\r\n".data(using: String.Encoding.utf8)!)
            if let fileData = fileUploadInfo.data {
                data.append( fileData )
            }
            else if let url = fileUploadInfo.url, let fileData = try? Data(contentsOf: url) {
                data.append( fileData )
            }
            else { // ToDo: report error
                return nil
            }
        }
        
        data.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        /// Start uploading
        return Alamofire.upload( data, with: request )
    }
    
    internal func upload() {
        ButterflyFileUploader.sharedUploader.startUploading(request: self.request)
    }
    
    // MARK: - Deinit
    deinit {
        
    }
}
