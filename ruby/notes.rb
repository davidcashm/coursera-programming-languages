class A

  def m2 (x,y)
    z = 7
    if x > y
      false
    else
      x+y*z
    end #if
  end #method

  def m1
    34
  end
  
  def m3 x
    x.abs * 2 + self.m1 # Can actually just use m1 here - self is implicit
  end

  def m4
    # @ makes an instance variable
    # It can't even be accessed by other A objects
    @foo = 0
  end

  def foo
    # @foo will be nil if not yet initialized
    @foo
  end
  
  def m5 x
    # Here, if @foo is uninitialized, += will give an error
    @foo += x
  end

  # initialize is special - called by Class.new
  # Can provide default function argument values
  def initialize(f=0)
    @foo = f
  end

  # static class variables start with @@
  @@bar = 23
  # Constants start with a capital
  Foo = 11

  # Class methods (a.k.a. static methods) start with self
  def self.my_static_method(x)
    print @@bar
    print Foo
    print 22
    print "Done static method\n"
  end

  private # All following methods only callable by self
          # (Default is public; protected also exists)
  def bar
    42
  end

  def baz
    43
  end

  # infix + automatically looks for a + method on lhs
  public
  def + x
    self.foo + x.foo
  end

end #class

a = A.new
print a.m1 # 34
print a.m2(2,4) # 30
print a.m3(-3)

a.m4
a.m5 3
a.m5 4
print a.foo

b = A.new(23)
print b.foo

A.my_static_method(1)

print a + b

### Everything is an object
3 + 4 # 7
3.+(4) # 7
-5.abs # 5
3.nonzero? # 3
0.nonzero? # nil.  Note that false and nil evaluate to false.  
                   # Everything else evaluates to true in bool context
nil.nil? # true
0.nil? # false

# Global methods get added to Object, which all objects inherit
# from
public
def foobar
  print "Hello from Object\n"
end

a.foobar


### Reflection

# Most useful in irb
3.methods # All methods callable from 3
3.class # What is its class
3.methods - nil.methods # List of methods on 3 that are not in nil


### Dynamic class changes
class A
  def new_method
    print "I didn't used to be in A"
  end
end

a.new_method


### Arrays

a = [2,3,9,7]
a[0] # 2
a[4] # nil
a[-1] # 7
a[6] = 14 # Now a contains [2,3,9,7,nil,nil,14]
a[5] = "hello"
b = a + [1,2,3]
c = Array.new(3) { 0 } # [0, 0, 0] (Default is nil)
d = Array.new(3) {|i| -i} # [0, -1, -2]
d.pop
d.push 12
d.shift
d.unshift 19

# Array (shallow) copy:
e = d + []

[1,2,3,4].each {|i| puts (i*i)}

### Blocks
# 1) Almost like closures
# 2) Put between braces, or betwee do/end
# 3) Can optionally pass 1 block with any message
3.times { puts "hi" }
[1,2,3].each {puts "hi"}
[1,2,3].each {|x| puts x}

a= Array.new(5) {|i| 4*(i+1)}
a.each {|x| puts (x*2)}
b = a.map {|x| x * 2} # Creates a new array

a.all? # true - checks that all elements are true
a.all? {|x| x > 2} # false
# a.inject -> fold
# a.select -> filter

# Using blocks - call yield
def silly a
  (yield a) + (yield 42)
end

silly(5){ |b| b*2 } # 94
# Can ask block_given?

# Note: blocks aren't quite first-class - can't store it, return it, etc.
# Can call "lambda {block}" to get a first class closure
#

# Hashes:
x = {}
x["foo"] = "bar"
x[false] = 3
x.keys
x.values
y = {"a"=>1, "b"=>2}

my_range = 1..10

### Subclassing
class B < A
  def m1
    35
  end
end

new_b = B.new
new_b.is_a? A # true
new_b.instance_of? A # false

### Mixins

# Defined with "module"
# Can only have methods that refer to self
# Rules for method lookup:
# 1) Look in class
# 2) Then mixins included in that class
#     (Later includes shadow earlier ones)
# 3) Then superclass (recursively)
module Barfer
  def bar
    puts (self.foo + self.foo)
  end
end

class Foo
  include Barfer
  def foo
    "Hello world"
  end
end

newfoo = Foo.new
newfoo.bar

# Common mixins:
# Comparable: Defines <,>,=,etc. in terms of <=>
# Enumerable: Defines iterators (map, find, etc.) in terms of each
