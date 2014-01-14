#!/usr/bin/env ruby
require 'cgi'


got_section = false
got_subsection = false
got_subsubsection = false

PREAMBLE = '''<!DOCTYPE html>
<document>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
    <script type="text/x-mathjax-config">
      MathJax.Hub.Config({
        tex2jax: { inlineMath: [["$","$"],["\\\\(","\\\\)"]] }
      });
    </script>
    <script type="text/javascript"
      src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
    </script>
  </head>
  <body>
'''

puts PREAMBLE

ARGF.each do |line|
    env = nil
    line = CGI.escapeHTML(line)
    line.gsub!(/\\emph{([^}]*)}/, '<em>\1</em>')
    if match = line.match(/\\begin{itemize}/)
        puts "<ul>"
    elsif match = line.match(/\\end{itemize}/)
        puts "</ul>"
    elsif match = line.match(/\\item/)
        puts line.gsub(/\\item (.*)/, '  <li>\1</li>')
    elsif match = line.match(/\\begin{pyconcode}/)
        puts "<pre>"
        puts "  <code>"
    elsif match = line.match(/\\end{pyconcode}/)
        puts "  </code>"
        puts "</pre>"
    elsif match = line.match(/\\begin{(\w+)}/)
        env = match.captures[0]
        puts "  <div class=\"#{env} panel panel-default\">"
        puts "    <div class=\"panel-heading\">"
        puts "      <h3 class=\"panel-title\">#{env}</h3>"
        puts "    </div>"
        puts "    <div class=\"panel-body\">"
    elsif match = line.match(/\\end{(\w+)}/)
        puts "    </div>"
        puts "  </div>"
    elsif match = line.match(/\\section{(.+)}/)
        head = match.captures[0]
        if got_section
            puts "</section>"
        else
            got_section = true
        end
        got_section = true
        puts "<section>"
        puts "  <header><h1>#{head}</h1></header>"
    elsif match = line.match(/\\subsection{(.+)}/)
        if got_subsection
            puts "</section>"
        else
            got_subsection = true
        end
        head = match.captures[0]
        puts "<section class=\"subsection\">"
        puts "  <header><h2>#{head}</h2></header>"
    elsif match = line.match(/\\subsubsection{(.+)}/)
        if got_subsubsection
            puts "</section>"
        else
            got_subsubsection = true
        end
        head = match.captures[0]
        puts "<section class=\"subsubsubsection\">"
        puts "  <header><h3>#{head}</h3></header>"
    else
        puts line
    end
end
if got_section
    puts "</section>"
end

puts "  </body>"
puts "</html>"
