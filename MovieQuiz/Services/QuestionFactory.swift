//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by semrumyantsev on 09.01.2025.
//

import Foundation


final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizeImageURL)
            }
            catch { 
                print ("Failed to load image")
            }
            let rating = Float(movie.rating) ?? 0
            let probablyRating: Float = Float.random(in: 7.5...9)
            let stringProbablyRating = String(format: "%.1f", probablyRating)
            let text = "Рейтинг этого фильма больше чем \(stringProbablyRating)?"
            let correctAnswer = rating > probablyRating
            
            let question = QuizQuestion(imageData: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
                
            }
        }
    }
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate? = nil) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
}
