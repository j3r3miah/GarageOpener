// Created by jeremiah_boyle on 3/8/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

import Foundation

class ServiceFinder : NSObject, NetServiceDelegate {
  let service: NetService
  var ipAddress: String?
  
  init(serviceName: String) {
    service = NetService(domain: "local.", type: "_http._tcp.", name: serviceName)
    super.init()
    service.delegate = self
    service.resolve(withTimeout: TimeInterval(30))
  }
  
  func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
    print("Resolve error: ", sender, errorDict)
  }
  
  func netServiceDidResolveAddress(_ sender: NetService) {
    if let serviceIp = resolveIPv4(addresses: sender.addresses!) {
      print("Found IPV4:", serviceIp)
      self.ipAddress = serviceIp
    } else {
      print("Did not find IPV4 address")
    }
  }
  
  func resolveIPv4(addresses: [Data]) -> String? {
    var result: String?
    for addr in addresses {
      let data = addr as NSData
      var storage = sockaddr_storage()
      data.getBytes(&storage, length: MemoryLayout<sockaddr_storage>.size)
      if Int32(storage.ss_family) == AF_INET {
        let addr4 = withUnsafePointer(to: &storage) {
          $0.withMemoryRebound(to: sockaddr_in.self, capacity: 1) {
            $0.pointee
          }
        }
        if let ip = String(cString: inet_ntoa(addr4.sin_addr), encoding: .ascii) {
          result = ip
          break
        }
      }
    }
    return result
  }
}
