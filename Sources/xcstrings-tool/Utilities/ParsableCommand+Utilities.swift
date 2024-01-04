import ArgumentParser
import Foundation

extension ParsableCommand {
    func createDirectoryIfNeeded(for inputURL: URL) throws {
        let directoryURL = if inputURL.isFileURL &&  inputURL.hasDirectoryPath {
            inputURL
        } else {
            inputURL.deletingLastPathComponent()
        }

        note("createDirectoryIfNeeded argument: \(inputURL)")
        note("createDirectoryIfNeeded directoryURL: \(directoryURL)")

        let fileManager = FileManager.default

        var isDirectory: ObjCBool = false
        fileManager.fileExists(atPath: directoryURL.path(percentEncoded: false), isDirectory: &isDirectory)

        try! fileManager.contentsOfDirectory(atPath: directoryURL.path(percentEncoded: false)).forEach({ content in
            print("content: \(content)")
        })

        if !fileManager.fileExists(atPath: directoryURL.path(percentEncoded: false), isDirectory: &isDirectory) {
            note("isDirectory: \(isDirectory)")
            note("Creating directory at \(directoryURL)")
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            note("Created directory at \(directoryURL)")
        } else {
            note("isDirectory: \(isDirectory)")
            note("No need to create directory.")
        }
    }
}
