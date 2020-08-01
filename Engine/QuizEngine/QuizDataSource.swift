//
//  QuizDataSource.swift
//  QuizEngine
//
//  Created by Vinicius Moreira Leal on 02/08/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public protocol QuizDataSource {
    associatedtype Question
    associatedtype Answer

    func answer(for question: Question, completion: @escaping (Answer) -> Void)
}
