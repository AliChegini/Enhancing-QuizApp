//
//  QuestionProvider.swift
//  TrueFalseStarter
//
//  Created by Ehsan on 20/11/2017.
//  Copyright © 2017 Treehouse. All rights reserved.
//

struct QuestionStructure {
    let question: String
    let option1: String
    let option2: String
    let option3: String
    let option4: String?
    let correctAnswer: String
    
    init(question: String, option1: String, option2: String, option3: String, option4: String? = nil, correctAnswer: String) {
        self.question = question
        self.option1 = option1
        self.option2 = option2
        self.option3 = option3
        self.option4 = option4
        self.correctAnswer = correctAnswer
    }
    
}

struct QuestionProvider {
    let questions = [
        QuestionStructure(question: "This was the only US President to serve more than two consecutive terms.", option1: "George Washington", option2: "Franklin D. Roosevelt", option3: "Woodrow Wilson", option4: "Andrew Jackson", correctAnswer: "Franklin D. Roosevelt"),
        QuestionStructure(question: "Which of the following countries has the most residents?", option1: "Nigeria", option2: "Russia", option3: "Iran", option4: "Vietnam", correctAnswer: "Nigeria"),
        QuestionStructure(question: "In what year was the United Nations founded?", option1: "1918", option2: "1919", option3: "1945", option4: "1954", correctAnswer: "1945"),
        QuestionStructure(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?", option1: "Paris", option2: "Washington D.C.", option3: "New York City", option4: "Boston", correctAnswer: "New York City"),
        QuestionStructure(question: "Which nation produces the most oil?", option1: "Iran", option2: "Iraq", option3: "Brazil", option4: "Canada", correctAnswer: "Canada"),
        QuestionStructure(question: "Which country has most recently won consecutive World Cups in Soccer?", option1: "Italy", option2: "Brazil", option3: "Argetina", option4: "Spain", correctAnswer: "Brazil"),
        QuestionStructure(question: "Which of the following rivers is longest?", option1: "Yangtze", option2: "Mississippi", option3: "Congo", option4: "Mekong", correctAnswer: "Mississippi"),
        QuestionStructure(question: "Which city is the oldest?", option1: "Mexico City", option2: "Cape Town", option3: "San Juan", option4: "Sydney", correctAnswer: "Mexico City"),
        QuestionStructure(question: "Which country was the first to allow women to vote in national elections?", option1: "Poland", option2: "United States", option3: "Sweden", option4: "Senegal", correctAnswer: "Poland"),
        QuestionStructure(question: "Which of these countries won the most medals in the 2012 Summer Games?", option1: "France", option2: "Germany", option3: "Japan", option4: "Great Britain", correctAnswer: "Great Britain"),
        QuestionStructure(question: "Which of these countries won the last world cup?", option1: "France", option2: "Germany", option3: "Japan", correctAnswer: "Germany")
    ]
    
    func selectQuestion(randomNumber: Int) -> QuestionStructure{
         return questions[randomNumber]
    }
    
}



