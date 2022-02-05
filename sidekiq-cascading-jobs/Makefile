.DEFAULT_GOAL := usage

# user and repo
USER        = $$(whoami)
CURRENT_DIR = $(notdir $(shell pwd))

# terminal colours
RED     = \033[0;31m
GREEN   = \033[0;32m
YELLOW  = \033[0;33m
NC      = \033[0m

.session.key:
	bundle exec ruby -e 'require "securerandom"; File.open(".session.key", "w"){|f|\
    f.write(SecureRandom.hex(32))}'

.PHONY: sidekiq-web
sidekiq-web: .session.key
	bundle exec rackup

.PHONY: check-tools
check-tools:
	echo -e "checking that redis is up and running: redis-cli ping"
	echo $(or $(shell redis-cli ping), $(error "Redis not running, connection refused"))

.PHONY: rubocop
rubocop:
	bundle exec rubocop

.PHONY: rubocop-fix
rubocop-fix:
	bundle exec rubocop -A

.PHONY: build
build: check-tools rubocop

.PHONY: sidekiq
sidekiq: check-tools
	bundle exec sidekiq --require ./worker_demo.rb

.PHONY: irb
irb: check-tools
	@echo "run ${GREEN}bundle exec irb -r ./worker_demo.rb${NC}"

.PHONY: demo
demo: check-tools
	bundle exec ruby -I . -e 'require "worker_demo"; WorkerDemo.perform_async("hello")'

.PHONY: usage
usage:
	@echo
	@echo "Hi ${GREEN}${USER}!${NC} Welcome to ${RED}${CURRENT_DIR}${NC}"
	@echo
	@echo "Development"
	@echo
	@echo "${YELLOW}make sidekiq${NC}         run sidekiq with a demo worker"
	@echo "${YELLOW}make sidekiq-web${NC}     run sidekiq-web"
	@echo "${YELLOW}make irb${NC}             run irb with worker loaded"
	@echo "${YELLOW}make demo${NC}            run some demo jobs against sidekiq"
	@echo
