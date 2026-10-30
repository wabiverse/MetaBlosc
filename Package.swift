// swift-tools-version: 5.10
import PackageDescription

var bloscExclude: [String] = []
#if !os(Windows)
  bloscExclude = ["include/win32"]
#endif

let package = Package(
  name: "MetaBlosc",
  platforms: [
    .macOS(.v14),
    .visionOS(.v1),
    .iOS(.v17),
    .tvOS(.v17),
    .watchOS(.v10),
  ],
  products: [
    .library(
      name: "Blosc",
      type: .dynamic,
      targets: ["Blosc"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/wabiverse/MetaZStandard.git", from: "1.0.0"),
    .package(url: "https://github.com/wabiverse/MetaLZ4.git", from: "1.0.0"),
    .package(url: "https://github.com/the-swift-collective/zlib", from: "1.3.1"),
  ],
  targets: [
    .target(
      name: "Blosc",
      dependencies: [
        .product(name: "LZ4", package: "MetaLZ4"),
        .product(name: "ZStandard", package: "MetaZStandard"),
        .product(name: "ZLib", package: "zlib"),
      ],
      exclude: bloscExclude,
      publicHeadersPath: "include/blosc",
      cSettings: [
        .headerSearchPath("include"),
        .define("HAVE_LZ4", to: "1"),
        .define("_ALLOW_COMPILER_AND_STL_VERSION_MISMATCH", .when(platforms: [.windows])),
        .define("_ALLOW_KEYWORD_MACROS", to: "1", .when(platforms: [.windows])),
        .define("static_assert(_conditional, ...)", to: "", .when(platforms: [.windows])),
      ],
      linkerSettings: [
        .linkedLibrary("pthread", .when(platforms: [.linux, .openbsd])),
      ]
    ),
  ],
  cLanguageStandard: .gnu17,
  cxxLanguageStandard: .cxx17
)
