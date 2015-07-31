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
//  Largely based on this stackoverflow question: http://stackoverflow.com/questions/26121827/uploading-file-with-parameters-using-alamofire/28467829//

import Foundation
import Alamofire

private struct ButterflyFileUploadInfo {
    var name: String?
    var mimeType: String?
    var fileName: String?
    var url: NSURL?
    var data: NSData?
    
    init( name: String, withFileURL url: NSURL, withMimeType mimeType: String? = nil ) {
        self.name = name
        self.url = url
        self.fileName = name
        self.mimeType = "application/octet-stream"
        if mimeType != nil {
            self.mimeType = mimeType!
        }
        if let _name = url.lastPathComponent {
            fileName = _name
        }
        if mimeType == nil, let _extension = url.pathExtension {
            switch _extension.lowercaseString {
                
            case "jpeg", "jpg":
                self.mimeType = "image/jpeg"
                
            case "png":
                self.mimeType = "image/png"
                
            default:
                self.mimeType = "application/octet-stream"
            }
        }
    }
    
    init( name: String, withData data: NSData, withMimeType mimeType: String ) {
        self.name = name
        self.data = data
        self.fileName = name
        self.mimeType = mimeType
    }
}

public class ButterflyFileUploader {
    
    private var parameters = [String:String]()
    private var files = [ButterflyFileUploadInfo]()
    private var headers = [String:String]()
    
    public func setValue( value: String, forParameter parameter: String ) {
        parameters[parameter] = value
    }
    
    public func setValue( value: String, forHeader header: String ) {
        headers[header] = value
    }
    
    public func addParametersFrom( #map: [String:String] ) {
        for (key,value) in map {
            parameters[key] = value
        }
    }
    
    public func addHeadersFrom( #map: [String:String] ) {
        for (key,value) in map {
            headers[key] = value
        }
    }
    
    ///
    /// Upload only one or multiple files with file URL.
    ///
    public func addFileURL( url: NSURL, withName name: String, withMimeType mimeType:String? = nil ) {
        files.append( ButterflyFileUploadInfo( name: name, withFileURL: url, withMimeType: mimeType ) )
    }
    
    /// 
    public func addFileData( data: NSData, withName name: String, withMimeType mimeType:String = "application/octet-stream" ) {
        files.append( ButterflyFileUploadInfo( name: name, withData: data, withMimeType: mimeType ) )
    }
    
    public func uploadFile( request sourceRequest: NSURLRequest? ) -> Request? {
        var request = sourceRequest!.mutableCopy() as! NSMutableURLRequest
        let boundary = "FileUploader-boundary-\(arc4random())-\(arc4random())"
        request.setValue( "multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let data = NSMutableData()
        
        for (name, value) in headers {
            request.setValue(value, forHTTPHeaderField: name)
        }
        
        // Amazon S3 (probably others) wont take parameters after files, so we put them first
        for (key, value) in parameters {
            data.appendData("\r\n--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            data.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        
        for fileUploadInfo in files {
            data.appendData( "\r\n--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)! )
            data.appendData( "Content-Disposition: form-data; name=\"\(fileUploadInfo.name)\"; filename=\"\(fileUploadInfo.fileName)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            data.appendData( "Content-Type: \(fileUploadInfo.mimeType)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            if fileUploadInfo.data != nil {
                data.appendData( fileUploadInfo.data! )
            }
            else if fileUploadInfo.url != nil, let fileData = NSData(contentsOfURL: fileUploadInfo.url!) {
                data.appendData( fileData )
            }
            else { // ToDo: report error
                return nil
            }
        }
        
        data.appendData("\r\n--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        return Alamofire.upload( request, data: data )
    }
    
}
