
FLUTTER_VERSION?=3.3.10
FLUTTER?=fvm flutter
REPOSITORIES?=lib/ test/
RUN_VERSION?=--debug
RUN_WEB?=chrome
PLATEFORMS_WEB?=web
RENDERER_WEB?=html
RUN_DESKTOP?=macos
PLATEFORMS_DESKTOP?=macos,linux,windows

GREEN_COLOR=\033[32m
NO_COLOR=\033[0m

define print_color_message
	@echo "$(GREEN_COLOR)$(1)$(NO_COLOR)";
endef

##
## ---------------------------------------------------------------
## Install
## ---------------------------------------------------------------
##

.PHONY: install
install: ## Install environment
	@$(call print_color_message,"Install environment")
	fvm install $(FLUTTER_VERSION)
	fvm use $(FLUTTER_VERSION)
	$(FLUTTER) pub global activate devtools

##
## ---------------------------------------------------------------
## Flutter
## ---------------------------------------------------------------
##

##
## ---------------------------------------------------------------
## Dart & Flutter
## ---------------------------------------------------------------
##

.PHONY: clean
clean: ## Clear cache
	@$(call print_color_message,"Clear cache")
	$(FLUTTER) clean

.PHONY: dependencies
dependencies: ## Update dependencies
	@$(call print_color_message,"Update dependencies")
	$(FLUTTER) pub get

.PHONY: format
format: ## Format code by default lib directory
	@$(call print_color_message,"Format code by default lib directory")
	dart format $(REPOSITORIES)

.PHONY: analyze
analyze: ## Analyze Dart code of the project
	@$(call print_color_message,"Analyze Dart code of the project")
	$(FLUTTER) analyze .

.PHONY: format-analyze
format-analyze: format analyze ## Format & Analyze Dart code of the project

.PHONY: test
test: ## Run all tests
	$(FLUTTER) test \
		--coverage \
		--test-randomize-ordering-seed random \
		--reporter expanded

.PHONY: devtools
devtools: ## Serving DevTools
	@$(call print_color_message,"Serving DevTools")
	$(FLUTTER) pub global run devtools

.PHONY: show-dependencies
show-dependencies: ## Show dependencies tree
	@$(call print_color_message,"Show dependencies tree")
	$(FLUTTER) pub deps

.PHONY: outdated
outdated: ## Check the version of packages
	@$(call print_color_message,"Check the version of packages")
	$(FLUTTER) pub outdated --color

##
## ---------------------------------------------------------------
## Android & Ios
## ---------------------------------------------------------------
##

##
## ---------------------------------------------------------------
## Mobile
## ---------------------------------------------------------------
##

.PHONY: run
run: ## Run application by default debug version
	@$(call print_color_message,"Run application by default debug version")
	$(FLUTTER) run $(RUN_VERSION)

##
## ---------------------------------------------------------------
## Desktop
## ---------------------------------------------------------------
##

.PHONY: enable-macos
enable-macos: ## Enable macos
	@$(call print_color_message,"Enable macos")
	$(FLUTTER) config --enable-macos-desktop

.PHONY: enable-windows
enable-windows: ## Enable windows
	@$(call print_color_message,"Enable windows")
	$(FLUTTER) config --enable-windows-desktop

.PHONY: enable-linux
enable-linux: ## enable linux
	@$(call print_color_message,"Enable linux")
	$(FLUTTER) config --enable-linux-desktop

.PHONY: create-desktop
create-desktop: ## Add desktop support by default on macos, linux & windows
	@$(call print_color_message,"Add desktop support by default on macos, linux & windows")
	$(FLUTTER) create --platforms=$(PLATEFORMS_DESKTOP) .

.PHONY: run-desktop
run-desktop: ## Run application on desktop by default debug version on macos
	@$(call print_color_message,"Run application on desktop by default debug version on macos")
	$(FLUTTER) run $(RUN_VERSION) -d $(RUN_DESKTOP)

##
## ---------------------------------------------------------------
## Web
## ---------------------------------------------------------------
##

.PHONY: enable-web
enable-web: ## Enable web
	@$(call print_color_message,"Enable web")
	$(FLUTTER) config --enable-web

.PHONY: create-web
create-web: ## Add web by default on web
	@$(call print_color_message,"Add web by default on web")
	$(FLUTTER) create --platforms=$(PLATEFORMS_WEB) .

.PHONY: run-web
run-web: ## Run application on web by default on chrome
	@$(call print_color_message,"Run application on web by default on chrome")
	$(FLUTTER) run $(RUN_VERSION) -d $(RUN_WEB) --web-renderer $(RENDERER_WEB)

.PHONY: build-web
build-web: ## Build on web by default on web
	@$(call print_color_message,"Build on web by default on web")
	$(FLUTTER) build $(PLATEFORMS_WEB) --web-renderer $(RENDERER_WEB)

#
# ----------------------------------------------------------------
# Help
# ----------------------------------------------------------------
#

.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN_COLOR)%-30s$(NO_COLOR) %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
