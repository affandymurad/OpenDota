//
//  ViewPresenter.swift
//  OpenDota
//
//  Created by docotel on 24/09/20.
//  Copyright © 2020 Affandy Murad. All rights reserved.
//

import Foundation
import UIKit

class ViewPresenter: BasePresenter<MainDelegates>{
    var rolesList: [DotaElement] = []
    
    func getRolesList() {
        self.view.taskDidBegin()
        let url = URL(string: "https://api.opendota.com/api/herostats")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                self.view.taskDidError(txt: error?.localizedDescription ?? "Unknown")
                return
            }
            
            do {
                let dota = try JSONDecoder().decode(Dota.self, from: data!)
                self.rolesList = dota
                self.view.loadRolesList(roles: self.rolesList)
            }  catch DecodingError.keyNotFound(let key, let context) {
                self.view.taskDidFinish()
                self.view.taskDidError(txt: "could not find key \(key) in JSON: \(context.debugDescription)")
            } catch DecodingError.valueNotFound(let type, let context) {
                self.view.taskDidFinish()
                self.view.taskDidError(txt: "could not find type \(type) in JSON: \(context.debugDescription)")
            } catch DecodingError.typeMismatch(let type, let context) {
                self.view.taskDidFinish()
                self.view.taskDidError(txt: "type mismatch for type \(type) in JSON: \(context.debugDescription)")
            } catch DecodingError.dataCorrupted(let context) {
                self.view.taskDidFinish()
                self.view.taskDidError(txt: "data found to be corrupted in JSON: \(context.debugDescription)")
            } catch let error as NSError {
                self.view.taskDidFinish()
                self.view.taskDidError(txt: "Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
            }
        })
        task.resume()
        
    }
    
}

protocol MainDelegates: BaseDelegate {
    func loadRolesList(roles: [DotaElement])
}
