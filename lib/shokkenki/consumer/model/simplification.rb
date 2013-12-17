require 'active_support/core_ext/string/inflections'

module Shokkenki
  module Consumer
    module Model
      module Simplification
        def simplify name
          name.to_s.
            strip.
            demodulize.
            gsub(' ', '_').
            gsub(/\W/, '').
            underscore.
            to_sym if name
        end
      end
    end
  end
end