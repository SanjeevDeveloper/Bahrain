//
//  BusinessCalenderInteractor.swift
//  iBeauty
//
//  Created by Nitesh Chauhan on 4/3/18.
//  Copyright (c) 2018 Kashish Verma. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol BusinessCalenderBusinessLogic
{
  func hitListBusinessAppointmentsApi(offset:Int, timeStamp:Int64)
  func hitDeleteAppoinmentApi(id: String, indexPath:Int)
}

protocol BusinessCalenderDataStore
{
  //var name: String { get set }
}

class BusinessCalenderInteractor: BusinessCalenderBusinessLogic, BusinessCalenderDataStore
{
    
    
  var presenter: BusinessCalenderPresentationLogic?
  var worker: BusinessCalenderWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func hitListBusinessAppointmentsApi(offset:Int, timeStamp:Int64)
  {
   
    worker = BusinessCalenderWorker()
    worker?.getListBusinessAppointments(offset: offset, timeStamp: timeStamp, apiResponse: { (response) in
        if response.code == 404 {
            CommonFunctions.sharedInstance.showSessionExpireAlert()
        }
        else {
            self.presenter?.presentResponse(response: response)
        }
    })
  }
    
    func hitDeleteAppoinmentApi(id: String, indexPath:Int) {
        worker = BusinessCalenderWorker()
        worker?.deleteAppoinmentApi(id: id, apiResponse: { (response) in
            if response.code == 200{
                self.presenter?.presentDeleteResponse(response: response, index: indexPath)
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
            
            
        })
    }
}
