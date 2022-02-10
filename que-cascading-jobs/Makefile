.DEFAULT_GOAL := usage

# user and repo
USER        = $$(whoami)
CURRENT_DIR = $(notdir $(shell pwd))

# terminal colours
RED     = \033[0;31m
GREEN   = \033[0;32m
YELLOW  = \033[0;33m
NC      = \033[0m

.PHONY: que
que:
	bundle exec que

.PHONY: que-web
que-web:
	bundle exec rackup

.PHONY: rubocop
rubocop:
	bundle exec rubocop

.PHONY: rubocop-fix
rubocop-fix:
	bundle exec rubocop -A

.PHONY: check-tools
check-tools:
	bundle

.PHONY: build
build: check-tools rubocop

.PHONY: irb
irb:
	bundle exec irb -I app -I config

.PHONY: demo
demo: check-tools
	bundle exec ruby -I app -I config -e 'require "environment"; CreateUser.enqueue("Michael")'
	bundle exec ruby -I app -I config -e 'require "environment"; CreateUser.enqueue("Sam")'
	bundle exec ruby -I app -I config -e 'require "environment"; CreateUser.enqueue("Tilly")'

.PHONY: count
count:
	bundle exec ruby -I app -I config -e 'require "environment"; [User, EmailSend].each{|model| pp model.all }'

.PHONY: clean
clean:
	bundle exec rake db:drop db:create db:migrate

.PHONY: usage
usage:
	@echo
	@echo "Hi ${GREEN}${USER}!${NC} Welcome to ${RED}${CURRENT_DIR}${NC}"
	@echo
	@echo "Development"
	@echo
	@echo "${YELLOW}make que${NC}                        run que"
	@echo "${YELLOW}make que-web${NC}                    run que-web"
	@echo "${YELLOW}make build${NC}                      run irb with worker loaded"
	@echo
	@echo "${YELLOW}make demo${NC}                       run a demo to create 3 users"
	@echo "${YELLOW}make count${NC}                      display models in db"
	@echo "${YELLOW}make irb${NC}                        run irb"
	@echo
	@echo "${YELLOW}make clean${NC}                      clean and migrate"
	@echo
	@echo "${YELLOW}rake 'db:new_migration[users]'${NC}  create a migration"
	@echo
