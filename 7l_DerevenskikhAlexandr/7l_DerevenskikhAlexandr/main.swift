//
//  main.swift
//  7l_DerevenskikhAlexandr
//
//  Created by Aleksandr Derevenskih on 14.04.2022.
//

import Foundation

// Программа получает url в качестве параметра и пытается скачать JSON-обьект по этому URL
// результат печатает на экране (stdout)
// По заданию - пришлось много гуглить и пробовать разные варианты, чтобы программа не завершалась до того как URLSession
// отработает, остановился аж на варианте с async\await и DispatchGroup. Так как всякое это пробовал - из жизненного цикла
// не стал удалять кучи print - пусть побудут.
// Так же непонятно, какие ошибки бросает URLSession и jsonObject - к какому-то объекту Error привести не смог -
// решил проверять на сам факт и перебрасывать из своего enum


// MARK: - ParserErrors
enum ParserErrors: Error {
    case invalidUrl(String)
    case downloadError
    case jsonParseError
    case noResult
}

// MARK: - UrlObjectLoader
final class UrlObjectLoader {
    let url: URL

    init(_ address: String) throws {
        guard let safeUrl = URL.init(string: address) else {
            throw ParserErrors.invalidUrl(address)
        }
        url = safeUrl
    }

    public func getData() async throws -> Any {
        let session = URLSession.shared

        let data = try? await session.data(from: url)
        guard let data = data else {
            throw ParserErrors.downloadError
        }

        let json = try? JSONSerialization.jsonObject(with: data.0, options: [])
        guard let json = json else {
            throw ParserErrors.jsonParseError
        }

        return json
    }

}

// MARK: - main entry

let address = CommandLine.argc > 1 ? CommandLine.arguments[1] :  "https://itunes.apple.com/search?term=dark+tranquillity&entity=album"

let group = DispatchGroup()
group.enter()

Task {
    defer {
        print("task leave")
        group.leave()
    }
    print("task run")
    do {
        print("task urlloader start")
        let urlObjectLoader = try UrlObjectLoader(address)

        print("task session start")
        let json = try await urlObjectLoader.getData()

        print(json)
    } catch {
        switch error {
        case ParserErrors.invalidUrl(let message):
            print("Invalid url: \(message)")
        case ParserErrors.downloadError:
            print("download from url failed")
        case ParserErrors.jsonParseError:
            print("This not json object")
        default:
            print("Runtime exception")
            print(error)
        }
    }
}

group.wait()
print("end")


