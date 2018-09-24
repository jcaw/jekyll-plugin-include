
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll_plugin_include/version"

Gem::Specification.new do |spec|
  spec.name          = "jekyll-plugin-include"
  spec.version       = Jekyll::PluginInclude::VERSION
  spec.authors       = ["Decipher Media"]
  spec.email         = ["deciphermediatv@gmail.com"]
  spec.summary       = %q{A Jekyll liquid tag plugin which allows includes directly from plugins' _include directories, with optional ability to override with equivalently-named files present in site includes_dir (if they exist).}
  spec.description   = %q{A Jekyll liquid tag plugin which allows includes directly from plugins' `_include` directories, with optional ability to override with files present in site includes_dir (if they exist).

Normally, Jekyll's `include` tag can only search for files in the site's single configured includes directory (and that of the *theme* plugin, if it using one). That means that if a plugin wants to provide you with a template/fragment via includes, the best it can do is ask you to copy it into your own repo manually.

This plugin then makes it easy to use includes that ship *with* a plugin directly *from* a plugin. And if a modified version of the file is provided in the site's own includes directory, it can intelligently use that one instead!

And for plugin developers, this provides a way to ship and use includes without leaning on the user to manage the unmodified files themselves.}
  spec.homepage      = "https://github.com/decipher-media/jekyll-plugin-include"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "jekyll", ['>= 3.8', '< 4.0']

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.59.1"
end
