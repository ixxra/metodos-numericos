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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script type="text/x-mathjax-config">
      MathJax.Hub.Config({
        tex2jax: { inlineMath: [["$","$"],["\\\\(","\\\\)"]] }
      });
    </script>
    <script src="https://google-code-prettify.googlecode.com/svn/loader/run_prettify.js?skin=sons-of-obsidian"></script>
    <script type="text/javascript"
      src="http://localhost:8000/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
    </script>
  </head>
  <body>
'''

#src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">

LOCALE = {'theorem' => "Teorema", 'exercise' => "Ejercicio", 
    'definition' => "Definición", 'remark' => "Comentario"}


puts PREAMBLE

ARGF.each do |line|
    env = nil
    line = CGI.escapeHTML(line)
    line.gsub!(/\\emph{([^}]*)}/, '<em>\1</em>')
    line.gsub!(/\\textbf{([^}]*)}/, '<strong>\1</strong>')
    line.gsub!(/\\textbackslash+/, "\\")

    if line =~ /\\documentclass/
        puts "<section class=\"container\">"
    elsif line =~ /\\usepackage/
        #do nothing... silently pass
    elsif line =~ /\\input/
        #pass
    elsif line =~ /\\maketitle/
        #pass
    elsif line =~ /\\begin{document}/
        puts "<header><h1>Notas de Análisis Numérico</h1></header>"
    elsif match = line.match(/\\begin{itemize}/)
        puts "<ul>"
    elsif match = line.match(/\\end{itemize}/)
        puts "</ul>"
    elsif match = line.match(/\\item/)
        puts line.gsub(/\\item (.*)/, '  <li>\1</li>')
    elsif match = line.match(/\\begin{pyconcode}/)
        puts "<pre>"
        puts "  <code>"
    elsif match = line.match(/\\begin{pythoncode}/)
        puts "<pre class=\"prettyprint lang-python linenums\">"
        puts "  <code>"
    elsif match = line.match(/\\end{pyconcode}/)
        puts "  </code>"
        puts "</pre>"
    elsif match = line.match(/\\end{pythoncode}/)
        puts " </code>"
        puts "</pre>"
    elsif match = line.match(/\\begin{(\w+)}/)
        env = match.captures[0]
        if env == "theorem"
            puts "  <div class=\"#{env} panel panel-primary\">"
        elsif env == "exercise"
            puts "  <div class=\"#{env} panel panel-success\">"
        else
            puts "  <div class=\"#{env} panel panel-default\">"
        end
        puts "    <div class=\"panel-heading\">"
        puts "      <h3 class=\"panel-title\">#{LOCALE[env]}</h3>"
        puts "    </div>"
        puts "    <div class=\"panel-body\">"
    elsif match = line.match(/\\end{(\w+)}/)
        puts "    </div>"
        puts "  </div>"
    elsif match = line.match(/\\section{(.+)}/)
        head = match.captures[0]
        if got_section
            puts "</p>"
            puts "</section>"
        else
            got_section = true
        end
        got_section = true
        puts "<section>"
        puts "  <header><h2>#{head}</h2></header>"
        puts "  <p>"
    elsif match = line.match(/\\subsection{(.+)}/)
        if got_subsection
            puts "</p>"
            puts "</section>"
        else
            got_subsection = true
        end
        head = match.captures[0]
        puts "<section class=\"subsection\">"
        puts "  <header><h3>#{head}</h3></header>"
        puts "  <p>"
    elsif match = line.match(/\\subsubsection{(.+)}/)
        if got_subsubsection
            puts "</p>"
            puts "</section>"
        else
            got_subsubsection = true
        end
        head = match.captures[0]
        puts "<section class=\"subsubsubsection\">"
        puts "  <header><h4>#{head}</h4></header>"
        puts "  <p>"
    else
        puts line
    end
end

if got_section
    puts "</section>"
end

puts "  </section>"
puts "</body>"
puts "</html>"
