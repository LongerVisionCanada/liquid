# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) do |repo_name|
  "https://github.com/#{repo_name}.git"
end

gemspec

group :benchmark, :test do
  gem 'benchmark-ips'
  gem 'memory_profiler'

  install_if -> { RUBY_PLATFORM !~ /mingw|mswin|java/ && RUBY_ENGINE != 'truffleruby' } do
    gem 'stackprof'
  end
end

group :test do
  gem 'rubocop', '~> 0.74.0', require: false

  platform :mri, :truffleruby do
    gem 'liquid-c', github: 'Shopify/liquid-c', ref: '7ba926791ef8411984d0f3e41c6353fd716041c6'
  end
end
