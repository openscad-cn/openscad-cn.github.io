require 'rouge'

module Rouge
  module Lexers
    class OpenSCAD < RegexLexer
      title "OpenSCAD"
      desc "The OpenSCAD programming language"
      tag 'openscad'
      filenames '*.scad'

      state :root do
        rule %r/\b(module|function|include|use|if|else|for|intersection_for)\b/, Keyword
        rule %r/\b(cube|sphere|cylinder|translate|rotate|scale|mirror|resize)\b/, Name::Builtin
        rule %r/\/\/.*/, Comment::Single
        rule %r/\d+\.\d+|\d+/, Num
        rule %r/".*?"/, Str
        rule %r/[;{},()]/, Punctuation
        rule %r/.*/, Text
      end
    end
  end
end
