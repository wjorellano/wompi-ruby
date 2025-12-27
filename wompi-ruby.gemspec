# frozen_string_literal: true

require_relative "lib/wompi/version"

Gem::Specification.new do |spec|
  spec.name = "wompi-ruby"
  spec.version = Wompi::Ruby::VERSION
  spec.authors = ["wjorellano"]
  spec.email = ["wilmanjunior2001@gmail.com"]

  spec.summary = "Ruby SDK for Wompi Payment Gateway integration."
  spec.description = "A lightweight Ruby library to integrate Wompi payments, supporting PSE, Credit Cards, Nequi, and Payment Links."
  spec.homepage = "https://github.com/wjorellano/wompi-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  # Metadata for RubyGems
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/wjorellano/wompi-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/wjorellano/wompi-ruby/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/wjorellano/wompi-ruby/issues"

  # File management
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "faraday", "~> 2.0"
end