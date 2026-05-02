# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "fileutils"
require_relative "lib/pixel_font_trie_ocr"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new
Rake.add_rakelib(File.join(__dir__, 'lib', 'tasks'))   

task default: %i[spec rubocop]
