# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mage-hand"
  s.version = "0.4.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Steven Hammond"]
  s.date = "2012-03-16"
  s.description = "mage-hand is a ghostly hand that reaches across the internet to access the Obsidian Portal API."
  s.email = "shammond@northpub.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc",
    "TODO"
  ]
  s.files = [
    ".document",
    ".rvmrc",
    "CHANGELOG",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "TODO",
    "VERSION",
    "lib/mage-hand-user.rb",
    "lib/mage-hand.rb",
    "lib/ob_port/base.rb",
    "lib/ob_port/campaign.rb",
    "lib/ob_port/client.rb",
    "lib/ob_port/errors.rb",
    "lib/ob_port/user.rb",
    "lib/ob_port/wiki_page.rb",
    "mage-hand.gemspec",
    "test/helper.rb",
    "test/test_base.rb",
    "test/test_campaign.rb",
    "test/test_client.rb",
    "test/test_mage_hand_controller.rb",
    "test/test_mage_hand_user.rb"
  ]
  s.homepage = "http://github.com/shammond42/mage-hand"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.19"
  s.summary = "Ruby wrapper around the Obsidian Portal API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<oauth>, [">= 0.4.4"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.0"])
      s.add_development_dependency(%q<mocha>, [">= 0.9.8"])
      s.add_development_dependency(%q<webmock>, [">= 1.6.2"])
      s.add_runtime_dependency(%q<oauth>, [">= 0.4.4"])
    else
      s.add_dependency(%q<oauth>, [">= 0.4.4"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.1.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.0"])
      s.add_dependency(%q<mocha>, [">= 0.9.8"])
      s.add_dependency(%q<webmock>, [">= 1.6.2"])
      s.add_dependency(%q<oauth>, [">= 0.4.4"])
    end
  else
    s.add_dependency(%q<oauth>, [">= 0.4.4"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.1.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.0"])
    s.add_dependency(%q<mocha>, [">= 0.9.8"])
    s.add_dependency(%q<webmock>, [">= 1.6.2"])
    s.add_dependency(%q<oauth>, [">= 0.4.4"])
  end
end

