# require 'erb'

# <%= ruby code will execute and show output %>

# <% ruby code will execute but not show output %>

require "erb"

meaning_of_life = 42

question = "The Answer to the Ultimate Question of Life, the Universe, and Everything is <%= meaning_of_life %>"
template = ERB.new question

results = template.result(binding)
puts results
