class Thing
  attr_accessor :thing_variable
  def initialize
    @thing_variable = "thing defined"
  end
  def do_something
    @thing_variable
  end
end
class Test
  def initialize
    @instance_variable = Thing.new
  end
  def public_method
    @instance_variable.do_something
  end
  protected
    def protected_method
      @instance_variable.do_something
    end
end

x = Test.new
another_thing = Thing.new
another_thing.thing_variable = "thing redefined"
meta = class << x; self; end
redefined = "blahblah"
meta.send(:define_method, :public_method) do
  redefined
end
meta.send(:define_method, :protected_method) do
  redefined
end

puts x.protected_method
