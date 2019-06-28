//
//  CPRadiogroupTableViewCell.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/6/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPRadiogroupTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var questionnumber: UILabel!
    @IBOutlet weak var Question: UILabel!
    @IBOutlet weak var RadioTable: UITableView!
    
    
    var items = [""]
    var answr = [RadioAnswers]()
    var qcodee : String!
    var qnumber : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        RadioTable.delegate = self
        RadioTable.dataSource = self
        
        self.RadioTable.register(UINib(nibName: "CPRadioCellTableViewCell", bundle: nil), forCellReuseIdentifier: "RadioCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioCell", for: indexPath) as! CPRadioCellTableViewCell
        cell.Answerlable.text = items[indexPath.row]
        cell.RadioCheckimage.image = UIImage(named: "radioicon_unselect")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! CPRadioCellTableViewCell
        
        if cell.RadioCheckimage.image == UIImage(named: "radioicon_unselect") {
            cell.RadioCheckimage.image = UIImage(named: "radioicon_select")
            
            answr.append(RadioAnswers(number: "\(indexPath.row)", answer: "\(items[indexPath.row])", qcode: qcodee))
            
            answr.removeAll { (RadioAnswers) -> Bool in
                RadioAnswers.number != "\(indexPath.row)" && RadioAnswers.qcode == qcodee
            }
            
            for i in 0...((answr.count) - 1) {
                
                 print("current available answer :: \(answr[i].number) && \(answr[i].answer)")
                
            }
            
            for cell in tableView.visibleCells {
                guard let visibleCell = cell as? CPRadioCellTableViewCell else { return }
                let path = tableView.indexPath(for: visibleCell)
                if path?.row == indexPath.row {
                    
                } else {
                    visibleCell.RadioCheckimage.image = UIImage(named: "radioicon_unselect")
                }

                
            }
            
        } else if cell.RadioCheckimage.image == UIImage(named: "radioicon_select") {
            cell.RadioCheckimage.image = UIImage(named: "radioicon_unselect")
            
            
            for i in 0...((answr.count) - 1) {
                
                print("current available answer :: \(answr[i].number) && \(answr[i].answer)")
                
            }
            
            if answr.isEmpty == false {
                
                    let results = answr.filter {  $0.number == "\(indexPath.row)" }
                    print("occurences :: \(results.count)")
                
                if results.count != 0 {
                    
                   answr.removeAll()
                    
                    for cell in tableView.visibleCells {
                        guard let visibleCell = cell as? CPRadioCellTableViewCell else { return }
                        
                            visibleCell.RadioCheckimage.image = UIImage(named: "radioicon_unselect")
                        
                        
                    }
                    
                }

    
            }
        }
    

    }
}


class RadioAnswers {
    var number = String()
    var answer = String()
    var qcode = String()
    
    init(number:String, answer:String, qcode:String){
        self.number = number
        self.answer = answer
        self.qcode = qcode
    }
}
