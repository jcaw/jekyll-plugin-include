jekyll-plugin-include
=====================

A Jekyll liquid tag plugin which allows includes directly from plugins' `_include` directories, with optional ability to override with files present in site includes_dir (if they exist).

Normally, Jekyll's `include` tag can only search for files in the site's single configured includes directory (and that of the *theme* plugin, if it using one). That means that if a plugin wants to provide you with a template/fragment via includes, the best it can do is ask you to copy it into your own repo manually.

This plugin then makes it easy to use includes that ship *with* a plugin directly *from* a plugin. And if a modified version of the file is provided in the site's own includes directory, it can intelligently use that one instead!

And for plugin developers, this provides a way to ship and use includes without leaning on the user to manage the unmodified files themselves.

# Requirements

* Jekyll static site generator
* A build process that runs somewhere other than Github pages (as this is a custom plugin)

# Installation

You can add a Rubygems-hosted Jekyll plugin (like this one) to your site by either adding adding it to your `_config` or to your `Gemfile`. you can also use it in your own gem-based plugin by adding it to your gemspec.

## gemfile install (recommended)

Add to the `jekyll_plugins` group in your `Gemfile`.

```ruby
group :jekyll_plugins do
  gem "jekyll-plugin-include"
end
```

## Jekyll `_config` install (not recommended)

Add it to the array `plugins` in your `_config.yml`:
```yaml
plugins:
  - jekyll-plugin-include
```

## For use in your own gem-based plugin (gemspec)

Add something like this to your gemspec
```ruby
spec.add_runtime_dependency "jekyll-plugin-include", ">= 0.1.0"
```
# Usage

Syntax note: quotes are required for arguments with spaces, and whitespace after the `:` is acceptable

This plugin provides a single custom Jekyll Liquid tag which provides enhanced include-like functionality, so it will look a lot like the standard `include`.

In this example with the `jekyll-podcast` plugin, this will function much like Jekyll's normal `include` (inserting the rendered contents of `includefile.html`), but will look in the `_includes` directory of the specified plugin if it doesn't find the file in the site's configured includes directory.

```liquid
{% plugin_include _plugin:"jekyll-podcast" _file: "podcast_feed_episode_content_encoded.html" %}
```

It is also possible to *force* this plugin to skip the site's configured includes directory completely and look exclusively in the plugin's `_includes` directory with the `allow_override` parameter:

```liquid
{% plugin_include _plugin:"jekyll-podcast" _file: "podcast_feed_misc.xml" allow_override: false %}
```

## Include parameters

Any parameters passed to the include besides `_plugin` and `_file` will be passed through as-is and will be available as `include.param_name` in the file.

```liquid
{% plugin_include _plugin:"jekyll-podcast" _file: "podcast_feed_asset_path.html" assetpath:/assets/imgs/some_image.png %}
```

# Github Pages

Github pages won't compile your custom ruby code, so you need to compile sites like this one elsewhere and then upload them to Github pages in their finished form. You can do this on your local machine, but also via services like [Travis CI](https://jekyllrb.com/docs/continuous-integration/travis-ci/).

# Testing

* syntax: a .rubocop.yml is provided. `rubocop lib/jekyll/plugin-include.rb`

# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/decipher-media/jekyll-plugin-include.

# License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

# Credits

By [Christopher Peterson](https://chrispeterson.info) for [Decipher Media](https://github.com/decipher-media/jekyll-plugin-include) and based mostly on the [original code](https://github.com/jekyll/jekyll/blob/master/lib/jekyll/tags/include.rb) for the Jekyll include tag.
