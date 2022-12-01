default:
	@ \
	printf '%s\n' "targets:"; \
	cat ./Makefile | \
	grep '^[^ 	]\+:' | \
	sed 's|:$$||g'

git: .PHONY
	git config core.hooksPath "$$(pwd)/git/hooks"

.PHONY: