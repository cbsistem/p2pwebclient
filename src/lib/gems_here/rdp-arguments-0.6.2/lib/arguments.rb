#gem 'ruby2ruby', '= 1.1.9'
require 'ruby2ruby'

$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require 'arguments/class'

RUBY_VERSION.to_f >= 1.9 ? require( 'arguments/vm' ) : require( 'arguments/mri' )

module Arguments
  VERSION = '0.6.1'
  
  def self.names klass, method, am_self
    args = ast_for_method(klass, method, am_self).assoc(:args)
    args = args[1..-1]
    
    return [] if args.empty?# or args.last.is_a?(Symbol)
    if args.last.is_a?(Symbol)
     # no optionals, so don't pop them off the list
     vals = []
    else
     vals = args.pop[1..-1]
    end

    args.collect do |arg|
      if val = vals.find{ |v| v[1] == arg }
        [arg, Ruby2Ruby.new.process(val.last)]
      else
        [arg]
      end
    end
  end
end