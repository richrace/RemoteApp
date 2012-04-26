# Author::    Christoph Olszowka, Modifications by Richard Race (rcr8)
# License::   MIT Licence

require 'helpers/application_helper'
# Representation of a XBMC JSON RPC method
# Changes were made to: invoke method, and below line 75.
class XbmcConnect::Command
  include ApplicationHelper
  # Needed for creating the methods/namespaces.
  attr_reader :command, :namespace, :method_name, :original_method, :description

  # Initializes a new command from the meta data hash given in JSONRPC.Introspect
  def initialize(command_meta)
    @command_meta = command_meta.with_indifferent_access
    @description = command_meta[:description]
    @command = command_meta[:command]
    parse_command!
  end

  # This is the method the Commands call, hence the need for the Callback and 
  # params. Even though the Synchronous method doesn't need a callback, it 
  # needs the constant from XbmcConnect (NOCALLB) to ensure it is what the
  # developer wants.
  def invoke(callback, params={})
    if XbmcConnect::NOCALLB == callback
      res = XbmcConnect.sync_connect(command, params)
      return res
    else
      XbmcConnect.async_connect(callback, command, params)
    end
  end
  
  # The ruby class name this command should end up in
  def klass_name
    "XbmcConnect::#{namespace}"
  end
  
  private

  # Extract the namespace and method names from the given JSON RPC raw command name
  def parse_command!
    @namespace, @original_method = command.split('.')
    @method_name = to_underscore(original_method)
  end

  # Will create the corresponding class for namespace if not defined yet
  # and also define the given method
  def define_method!
    begin
      klass = constantize(klass_name)
    rescue NameError => err
      eval("#{klass_name} = Class.new")
      klass = constantize(klass_name)
    end
  
    # Need to assign instance to local var because "self" is out of scope inside the method definition
    command_object = self
    # Define class method in corresponding namespace class
    klass.metaclass.send(:define_method, method_name.to_sym) do |*args|
      command_object.invoke(*args)
    end
  end

  # Will return the subcollection "xyz" from the response for "get_xyz" commands when
  # the collection is present, or just the result collection otherwise.
  def process_result(result)
    if method_name =~ /^get_(.+)/ and (collection = result[$1.gsub('_', '')]).present?
      return collection
    else
      return result
    end
  end
  

  # Richard Race ------- Added code below this line.
  
  # Needed to convert CamelCase to_underscore for this to work.
  # Code modified from - http://stackoverflow.com/questions/1509915/converting-camel-case-to-underscore-case-in-ruby
  def to_underscore(text)
    unless text.nil? || text.empty?
      n = text.gsub(/(.)([A-Z])/,'\1_\2')
      n.downcase
    end
  end
  
  # Required by this class; does not work without it.
  # Taken from Rails Active Record - MIT Licence
  # http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-constantize
  # GitHub = http://bit.ly/A9Hy1k (source code) https://github.com/rails/rails
  def constantize(camel_cased_word)
    names = camel_cased_word.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end

end