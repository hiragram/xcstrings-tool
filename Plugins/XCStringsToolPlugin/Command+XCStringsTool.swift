import Foundation
import PackagePlugin

protocol PluginContextProtocol {
    var pluginWorkDirectory: PackagePlugin.Path { get }
    func tool(named name: String) throws -> PluginContext.Tool
}

extension PluginContext: PluginContextProtocol { }

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin
extension XcodePluginContext: PluginContextProtocol {}
#endif

extension Command {
    static func xcstringstool(for file: File, using context: PluginContextProtocol) throws -> Command {
        let isRunningOnXcodeCloud = ProcessInfo.processInfo.environment["CI_XCODE_CLOUD"] == "TRUE"

        let displayName = "XCStringsTool: Generate Swift code for ‘\(file.path.lastComponent)‘"
        let executablePath = try context.tool(named: "xcstrings-tool").path
        let arguments: [CustomStringConvertible] = [
            file.path,
            context.outputPath(for: file)
        ]

        if isRunningOnXcodeCloud {
            print("mowamowa: XcodeCloud!")
            return .prebuildCommand(
                displayName: displayName,
                executable: executablePath,
                arguments: arguments,
                outputFilesDirectory: context.outputDirectory
            )
        } else {
            print("mowamowa: Not XcodeCloud!")
            return .buildCommand(
                displayName: displayName,
                executable: executablePath,
                arguments: arguments,
                inputFiles: [
                    file.path
                ],
                outputFiles: [
                    context.outputPath(for: file)
                ]
            )
        }
    }
}

private extension PluginContextProtocol {
    var outputDirectory: Path {
        pluginWorkDirectory.appending(subpath: "XCStringsTool")
    }

    func outputPath(for file: File) -> Path {
        outputDirectory.appending("\(file.path.stem).swift")
    }
}

