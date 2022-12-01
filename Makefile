LIB = 1

default:
	@ \
	cat ./Makefile | \
	grep '^[^ 	]\+:' | \
	sed 's|:$$||g'

git:
	git config core.hooksPath "$$(pwd)/git/hooks"