// swift-tools-version:5.7
import PackageDescription



let commonSwiftSettings: [SwiftSetting] = [
	.unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
	//	.unsafeFlags(["-Xfrontend", "-warn-concurrency", "-Xfrontend", "-enable-actor-data-race-checks"])
]


let package = Package(
	name: "OfficeModel",
	platforms: [
		.macOS(.v12)
	],
	products: {
		var ret = [Product]()
		ret.append(.library(name: "OfficeModelCore", targets: ["OfficeModelCore"]))
		ret.append(.library(name: "OfficeModel", targets: ["OfficeModel"/* contains exported "Core" */]))
		return ret
	}(),
	dependencies: {
		var ret = [Package.Dependency]()
		ret.append(.package(url: "https://github.com/Frizlab/generic-json.git",  from: "3.0.0"))
		ret.append(.package(url: "https://github.com/Frizlab/swift-email.git",   from: "0.2.1"))
		ret.append(.package(url: "https://github.com/Frizlab/UnwrapOrThrow.git", from: "1.0.0-beta"))
		ret.append(.package(url: "https://github.com/mxcl/LegibleError.git",     from: "1.0.0"))
		return ret
	}(),
	targets: {
		var ret = [Target]()
		/* I’d have loved to have this called "Core", but Xcode is not really ready for a target name different than the library (import not seen by IDE but compilation pass). */
		ret.append(.target(name: "OfficeModelCore", dependencies: ["UnwrapOrThrow"], swiftSettings: commonSwiftSettings))
		ret.append(.target(
			name: "OfficeModel",
			dependencies: {
				var ret = [Target.Dependency]()
				ret.append(.product(name: "Email",         package: "swift-email"))
				ret.append(.product(name: "GenericJSON",   package: "generic-json"))
				ret.append(.product(name: "LegibleError",  package: "LegibleError"))
				ret.append(.product(name: "UnwrapOrThrow", package: "UnwrapOrThrow"))
				ret.append(.target(name: "OfficeModelCore"))
				return ret
			}(),
			swiftSettings: commonSwiftSettings
		))
		ret.append(.testTarget(name: "OfficeModelTests", dependencies: ["OfficeModelCore", "OfficeModel"]))
		return ret
	}()
)
