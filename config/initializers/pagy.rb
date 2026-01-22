puts "Pagy Initializer Loaded!"
require 'pagy/extras/metadata'
require 'pagy/extras/overflow'
require 'pagy/extras/headers'

Pagy::DEFAULT[:items]    = 6
Pagy::DEFAULT[:overflow] = :empty_page  