class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      define_method("#{name}") { instance_variable_get("@#{name}") }

      define_method("#{name}=") do |arg|
        instance_variable_set("@#{name}", arg)
      end
    end
  end

end

# I just need to make a method that will turn my_attr_accessor :monkey
# into def monkey
#         @monkey
# =>   end

# and  def monkey=(arg)
# =>      @monkey = arg
# =>   end

