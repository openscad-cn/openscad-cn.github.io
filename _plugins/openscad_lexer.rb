# _plugins/openscad.rb
require 'rouge'

module Rouge
  module Lexers
    class OpenSCAD < RegexLexer
      title "OpenSCAD"
      desc "OpenSCAD 3D CAD modeling language"
      tag 'openscad'
      aliases 'scad'
      filenames '*.scad'
      mimetypes 'text/x-openscad'

      def self.keywords
        @keywords ||= %w(
          module function if else for intersection_for assign let echo assert
        )
      end

      def self.builtins
        @builtins ||= %w(
          cube sphere cylinder cone translate rotate scale union difference intersection 
          mirror color minkowski render hull resize
        )
      end

      state :root do
        rule %r/\s+/, Text::Whitespace
        rule %r(//.*$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
        
        # 字符串
        rule %r/"(\\.|[^"\\])*"/, Str

        # 数字
        rule %r/\b\d+(\.\d+)?([eE][+-]?\d+)?\b/, Num

        # 内置函数、模块等
        rule %r/\b(#{self.builtins.join('|')})\b/, Name::Builtin

        # 关键字
        rule %r/\b(#{self.keywords.join('|')})\b/, Keyword

        # 标识符
        rule %r/[a-zA-Z_]\w*/, Name::Other

        # 符号
        rule %r/[{}[\]();,]/, Punctuation
        rule %r/[+\-*\/=<>!&|~%^:?]/, Operator
      end
    end
  end
end
