.DEFAULT_GOAL := usage

# user and repo
USER        = $$(whoami)
CURRENT_DIR = $(notdir $(shell pwd))

# terminal colours
RED     = \033[0;31m
GREEN   = \033[0;32m
YELLOW  = \033[0;33m
NC      = \033[0m

.PHONY: rubocop
rubocop:
	bundle exec rubocop

.PHONY: rubocop-fix
rubocop-fix:
	bundle exec rubocop -A

.PHONY: test
test:
	bundle exec rspec

.PHONY: build
build: rubocop test

.PHONY: demo
demo:
	bin/demo_math.rb one plus three_hundred

.PHONY: usage
usage:
	@echo
	@echo "Hi ${GREEN}${USER}!${NC} Welcome to ${RED}${CURRENT_DIR}${NC}"
	@echo
	@echo "Development"
	@echo
	@echo "${YELLOW}make rubocop${NC}      lint"
	@echo "${YELLOW}make rubocop-fix${NC}  lint fix"
	@echo "${YELLOW}make test${NC}         test"
	@echo "${YELLOW}make build${NC}        lint and test"
	@echo
	@echo "${YELLOW}make demo${NC}         run demo"
	@echo
