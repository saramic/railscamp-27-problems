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
	DEMO_ARG=Michael bundle exec ruby -I . -e 'require "worker_demo"; WorkerDemo.perform_async(ENV.fetch("DEMO_ARG"))'

.PHONY: clear-outbox
clear-outbox:
	bundle exec ruby -I . -e 'require "worker_demo"; Outbox.all.each{ WorkerOutbox.perform_async(_1.id) }'

.PHONY: count
count:
	bundle exec ruby app/main.rb

.PHONY: clean
clean:
	rm -f .session.key
	bundle exec rake db:drop db:create db:migrate

.PHONY: usage
usage:
	@echo
	@echo "Hi ${GREEN}${USER}!${NC} Welcome to ${RED}${CURRENT_DIR}${NC}"
	@echo
	@echo "Development"
	@echo
	@echo "${YELLOW}make sidekiq${NC}                     run sidekiq with a demo worker"
	@echo "${YELLOW}make sidekiq-web${NC}                 run sidekiq-web"
	@echo "${YELLOW}make irb${NC}                         run irb with worker loaded"
	@echo "${YELLOW}make demo${NC}                        run some demo jobs against sidekiq"
	@echo "${YELLOW}make count${NC}                       do a count of created models"
	@echo
	@echo "${YELLOW}make clean${NC}                       drop the db and delete any temporary files"
	@echo
	@echo "Rake targets"
	@echo
	@echo "${YELLOW}rake -T${NC}                          list targets"
	@echo "${YELLOW}rake db:create${NC}                   create the db"
	@echo "${YELLOW}rake db:migrate${NC}                  migrate the db"
	@echo "${YELLOW}rake 'db:new_migration[users]'${NC}   create a migration"
	@echo
	@echo "IRB"
	@echo
	@echo "${YELLOW}bundle exec irb -r ./app/main.rb${NC} list targets"
	@echo "${YELLOW}make clear-outbox${NC}                clear any outbox items"
	@echo
