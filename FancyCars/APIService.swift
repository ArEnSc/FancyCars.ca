//
//  APIService.swift
//  FancyCars
//
//  Created by Michael Chung on 4/24/19.
//  Copyright © 2019 Michael Chung. All rights reserved.
//
import Foundation
class APIServiceMock {
    
    // Lets pretend we are a server using this mock service
    // Lets assume server doesn't produce errors in this case so no error handling
    // Lets assume that the server is a file.json
    // Lets assume that the availible service is also availible.json
    var pageSize:Int = 10
    var serverLag:Double = 0.5
    
    typealias CompleteBlock<T> = (T)->()
    
    func getAllCars(completeBlock:@escaping CompleteBlock<[Car]>) {
        DispatchQueue.global().asyncAfter(wallDeadline: .now() + serverLag) { [completeBlock] in
            do {
                guard let file = Bundle.main.url(forResource: "cars", withExtension: "json") else { return }
                let data = try Data(contentsOf: file)

                let result = try JSONDecoder().decode([Car].self, from: data)
                completeBlock(result)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func page(cars:[Car],currentPage:Int,pageSize:Int) -> [Car] {
        // Pretend to be server and return pages
        let rangeEnd = currentPage * pageSize
        let rangeStart = rangeEnd - pageSize
        var result:[Car] = []
        if (rangeEnd > cars.count) {
            if rangeStart > cars.count {
                result = []
            } else {
                result = Array(cars[rangeStart...])
            }
        } else {
            result = Array(cars[rangeStart ..< rangeEnd])
        }
        return result
    }
    
    func getCarsPage(page:Int, completeBlock:@escaping CompleteBlock<[Car]>) {
        DispatchQueue.global().asyncAfter(wallDeadline: .now() + serverLag) { [weak self,completeBlock] in
            do {
                guard let file = Bundle.main.url(forResource: "cars", withExtension: "json") else { return }
                let data = try Data(contentsOf: file)
                var result = try JSONDecoder().decode([Car].self, from: data)
                
                for (index, car) in result.enumerated() {
                    
                    self?.isAvailible(with: car.id, completeBlock: { (availible) in
                        var car = car
                        car.available = availible.available
                        result[index] = car
                    })
                }
                
                
                completeBlock(result)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func isAvailible(with id:Int, completeBlock:@escaping CompleteBlock<Availability>) {
        DispatchQueue.main.sync {
            do {
            guard let file = Bundle.main.url(forResource: "availible", withExtension: "json") else { return }
            // read json file and get status
            let data = try Data(contentsOf: file)
            var result = try JSONDecoder().decode([Availability].self, from: data)
                
                for i in result {
                    if i.id == id {
                        completeBlock(i)
                        break
                    }
                }
                
            } catch {
                
            }
        }
    }
}
