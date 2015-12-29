DEBUGDIR=.build/debug/Max
RELEASEDIR=.build/release/Max

debug:
	@swift build --clean
	@swift build

release:
	@swift build --clean
	@swift build --configuration release

install-dev:
	swift build
	cp $(DEBUGDIR) /usr/local/bin/Max

install-release:
	@swift build --clean
	@swift build --configuration release
	@cp $(RELEASEDIR) /usr/local/bin/Max
