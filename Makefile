DEBUGDIR=.build/debug/Max
RELEASEDIR=.build/release/Max

debug: # simple ```swift build``` in debug configuration
	@swift build --clean
	@swift build

release: # ```swift build``` in the release configuration
	@swift build --clean
	@swift build --configuration release

install-dev: # same as debug but also installs the executable to system. See $PATH
	@swift build
	@cp $(DEBUGDIR) /usr/local/bin/Max

install-release: # same as release but also installs the executable to system.
	@swift build --clean
	@swift build --configuration release
	@cp $(RELEASEDIR) /usr/local/bin/Max
