//
//  MWLogger.swift
//  Edwin
//
//  Created by Vegard Solheim Theriault on 01/04/15.
//  Copyright (c) 2015 Wrong Bag. All rights reserved.
//

import Foundation

private let shouldSaveToLogFile = true
private let logQueue = dispatch_queue_create("Log Queue", DISPATCH_QUEUE_SERIAL)

// Enable a call like MWLog() to simply print a new line
func MWLog(filePath: String = __FILE__, functionName: String = __FUNCTION__, lineNumber: Int = __LINE__) {
    MWLog("", filePath: filePath, functionName: functionName, lineNumber: lineNumber)
}

func MWLog(message: String, filePath: String = __FILE__, functionName: String = __FUNCTION__, lineNumber: Int = __LINE__) {
    dispatch_async(logQueue, { () -> Void in
        let date = NSDate()
        
        var milliseconds = date.timeIntervalSince1970 as Double
        milliseconds -= floor(milliseconds)
        let tensOfASecond = Int(milliseconds * 10000)
        
        // Adding extra "0"s to the milliseconds if necessary
        var tensOfASecondString = "\(tensOfASecond)"
        while countElements(tensOfASecondString) < 4 {
            tensOfASecondString = "0" + tensOfASecondString
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH.mm.ss"
        let dateString = dateFormatter.stringFromDate(date)
        
        let printString = String(format: "l:%-5d %-25s  %-45s  %@",
            lineNumber,
            COpaquePointer(filePath.lastPathComponent.cStringUsingEncoding(NSUTF8StringEncoding)!),
            COpaquePointer(functionName.cStringUsingEncoding(NSUTF8StringEncoding)!),
            message)
        
        println("\(dateString).\(tensOfASecondString) \(printString)")
    });
}

