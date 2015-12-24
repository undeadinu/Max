import PackageDescription

let package = Package(
    name: "Max",
    dependencies: [
       .Package(url: "https://github.com/Colton/Open.git",
                majorVersion: 1),
       .Package(url: "https://github.com/kylef/Commander.git",
                majorVersion: 0)
   ]
)
