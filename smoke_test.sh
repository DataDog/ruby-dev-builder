#!/bin/bash

# Expected to be run from ruby build directory, and assumes ruby-dev-builder repo is checked out at test_files/ folder

set -euo pipefail

make test-spec MSPECOPT=-j
make test-all TESTS="-j4"
ruby test_files/cli_test.rb

mv test_files/Gemfile .

ruby -e 'pp RbConfig::CONFIG'
ruby --yjit -e 'exit RubyVM::YJIT.enabled?'
ruby -ropen-uri -e 'puts URI.send(:open, "https://rubygems.org/") { |f| f.read(1024) }'

gem install json:2.2.0 --no-document

bundle install
bundle exec rake --version
ruby -e 'p RbConfig::CONFIG["cppflags"]; def Warning.warn(s); raise s; end; system RbConfig.ruby, "-e", "p :OK"'
