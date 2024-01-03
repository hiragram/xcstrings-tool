import ArgumentParser
import Foundation

extension ParsableCommand {
    func createDirectoryIfNeeded(for inputURL: URL) throws {
        let directoryURL = if inputURL.isFileURL &&  inputURL.hasDirectoryPath {
            inputURL
        } else {
            inputURL.deletingLastPathComponent()
        }

        let fileManager = FileManager.default

        if !fileManager.fileExists(atPath: directoryURL.path(percentEncoded: false)) {
            note("Creating directory at \(directoryURL)")
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            note("Created directory at \(directoryURL)")
        } else {
            note("No need to create directory.")
        }
    }
}
