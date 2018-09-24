require "jekyll_plugin_include/version"
# rubocop:disable Metrics/MethodLength

module Jekyll
  module PluginInclude
    class Tag < Liquid::Tag
      VARIABLE_SYNTAX = /
          (?<variable>[^{]*(\{\{\s*[\w\-\.]+\s*(\|.*)?\}\}[^\s{}]*)+)
          (?<params>.*)
       /x

      def initialize(tagname, content, tokens)
        super

        @attributes = { '_allow_override' => 'true' }
        content.scan(::Liquid::TagAttributes) do |key, value|
          # Strip quotes from around attribute values
          @attributes[key] = value.gsub(/^['"]|['"]$/, '')
        end

        gem_root = Gem::Specification.find_by_name(@attributes['_plugin']).gem_dir
        @gem_includes = File.join(gem_root, '_includes')
        @site_root = Jekyll.configuration({})['source']
        @site_includes_dir = File.join(
          @site_root,
          Jekyll.configuration({})['includes_dir']
        )
      end

      def render(context)
        searchpath = if @attributes['_allow_override'] == 'true'
                       [
                         @site_includes_dir,
                         @gem_includes,
                       ]
                     else
                       [
                         @gem_includes,
                         @site_includes_dir,
                       ]
                     end

        file = render_variable(
          context,
          @attributes['_file']
        ) || @attributes['_file']

        # Pass on the include params minus ours
        pass_params = @attributes
        pass_params.delete('_plugin')
        pass_params.delete('_file')
        pass_params.delete('_allow_override')
        context['include'] = pass_params

        file = findfile(searchpath, file)
        if file.nil?
          raise 'podcast_include could not find the file '\
            "\"#{@attributes['_file']}\"."
        else
          f = File.read(file, context.registers[:site].file_read_opts)
          partial = Liquid::Template.parse(f)
          partial.render!(context)
        end
      end

      # Render the variable if required (@see https://goo.gl/N5sMV3)
      def render_variable(context, var)
        return unless var.match(VARIABLE_SYNTAX)

        partial = context.registers[:site]
                         .liquid_renderer
                         .file('(variable)')
                         .parse(var)
        return partial.render!(context)
      end

      def findfile(path, filename)
        file = nil

        path.each do |dir|
          testfile = File.join(dir, filename)
          if File.file?(testfile)
            file = testfile
            break
          end
        end

        return file
      end

      Liquid::Template.register_tag 'plugin_include', self
    end
  end
end

# rubocop:enable Metrics/MethodLength
