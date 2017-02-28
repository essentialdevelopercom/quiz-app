//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var summary = ""
    private var answers = [PresentableAnswer]()

    convenience init(summary: String, answers: [PresentableAnswer]) {
        self.init()
        self.summary = summary
        self.answers = answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = summary
        tableView.register(CorrectAnswerCell.self)
        tableView.register(WrongAnswerCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
        if answer.wrongAnswer == nil {
            return correctAnswerCell(for: answer)
        }
        return wrongAnswerCell(for: answer)
    }
    
    private func correctAnswerCell(for answer: PresentableAnswer) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CorrectAnswerCell.self)!
        cell.questionLabel.text = answer.question
        cell.answerLabel.text = answer.answer
        return cell
    }
    
    private func wrongAnswerCell(for answer: PresentableAnswer) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(WrongAnswerCell.self)!
        cell.questionLabel.text = answer.question
        cell.correctAnswerLabel.text = answer.answer
        cell.wrongAnswerLabel.text = answer.wrongAnswer
        return cell
    }

}
