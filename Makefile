
TESTS = test/*.js
REPORTER = spec
BENCHMARKS = benchmark/*.js

#
# Tests
# 

test: test-node test-browser 

test-node: 
	@printf "\n  ==> [Node.js]"
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--require ./test/bootstrap \
		--reporter $(REPORTER) \
		$(TESTS)

test-browser: build
	@printf "\n  ==> [Phantom.Js]"
	@./node_modules/.bin/mocha-phantomjs \
		--R ${REPORTER} \
		./test/browser/index.html

test-cov: lib-cov
	@DRIP_COV=1 NODE_ENV=test ./node_modules/.bin/mocha \
		--require ./test/bootstrap \
		--reporter html-cov \
		$(TESTS) \
		> coverage.html
	$(MAKE) clean-cov

#
# Components
# 

build: components lib/*
	@./node_modules/.bin/component-build --dev

components: component.json
	@./node_modules/.bin/component-install --dev

#
# Coverage
# 

lib-cov:
	@rm -rf lib-cov
	@jscoverage lib lib-cov

#
# Benchmarks
# 

bench:
	@matcha $(BENCHMARKS)

#
# Clean up
# 

clean: clean-components clean-cov

clean-components:
	@rm -rf build
	@rm -rf components

clean-cov:
	@rm -rf lib-cov
	@rm -f coverage.html


.PHONY: clean clean-components clean-cov test test-cov test-node test-browser lib-cov bench
