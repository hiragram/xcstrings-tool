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
        let command = Command.buildCommand(
            displayName: "XCStringsTool: Generate Swift code for ‘\(file.path.lastComponent)‘",
            executable: try context.tool(named: "xcstrings-tool").path,
            arguments: [
                file.path,
                context.outputPath(for: file)
            ],
            inputFiles: [
                file.path
            ],
            outputFiles: [
                context.outputPath(for: file)
            ]
        )

        print("commandinfo", command)

        return command
    }
}

private extension PluginContextProtocol {
    var outputDirectory: Path {
        pluginWorkDirectory.appending(subpath: "GeneratedFiles")
    }

    func outputPath(for file: File) -> Path {
        outputDirectory.appending("\(file.path.stem).swift")
    }
}

