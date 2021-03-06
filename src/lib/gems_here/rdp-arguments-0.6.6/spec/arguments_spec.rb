require 'rubygems'
require 'benchmark'
require "#{ dir = File.dirname __FILE__ }/../lib/arguments"
require 'spec/autorun'

# TODO: Refactor specs for clarity and better coverage
describe Arguments do

  before do
    Object.send(:remove_const, 'Klass') rescue nil
    load "#{ dir }/klass.rb"
    load "#{ dir }/klass_big.rb"
    @instance = Klass.new
  end

  it "should not respond to named_arguments" do
    lambda { Klass.new.send( :named_arguments_for ) }.should raise_error( NoMethodError )
  end

  it "shouldn't break defaults" do
    @instance.two(1).should == [1, 2, Klass.new]
  end
  
  it "should allow passing named argument" do
    Klass.send( :named_arguments_for, :two )
    @instance.two(1, :three => 3).should == [1, 2, 3]
  end
  
  it "should raise ArgumentError if not passing required params" do
    Klass.send( :named_arguments_for, :two )
    error =
    begin 
      @instance.two( :three => 3 )
    rescue ArgumentError => e
      e
    end
    error.to_s.should == "passing `one` is required"
  end
  
  it "should override passed value with hash" do
    Klass.send( :named_arguments_for, :two )
    @instance.two( :one => nil ).should == [nil, 2, Klass.new]
  end

  it "should allow for class arguments" do
    Klass.send( :named_arguments_for, :defaults_with_class)
    @instance.defaults_with_class(1, 3).should == 3
    @instance.defaults_with_class(:a => 3).should == 3
    @instance.defaults_with_class().should == 3
  end

  it "should allow for class arguments in class methods" do
    Klass.send( :named_arguments_for, :'self.klass_defaults_with_class')
    Klass.klass_defaults_with_class(1, 4).should == 4
    Klass.klass_defaults_with_class(:a => 4).should == 4
    Klass.klass_defaults_with_class().should == 3
  end

  it "should allow for class arguments in class methods" do
    Klass.send( :named_arguments_for, :'self.klass_method')
    Klass.klass_method(1, 2).should == 3
    Klass.klass_method(:a => 3).should == 3
    Klass.klass_method(1,2,3,5).should == 5
    Klass.klass_method(1,2,3,5, 6).should == 5
  end

  it "should allow for method within a class' self block to be used with a class name" do
    Klass.send(:named_arguments_for, :'self.klass_method3')
    Klass.klass_method3(1,4).should == 4
    Klass.klass_method3(:a => 1, :b => 4).should == 4
  end

  it "should parse larger methods" do
     Klass.send( :named_arguments_for, :'self.startCSWithP2PEM')
     Klass.startCSWithP2PEM 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n' # 3

     Klass.startCSWithP2PEM 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', :dhtClassToUse => 44, :completion_proc => nil # 44 

     Klass.startCSWithP2PEM 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', :dhtClassToUse => 44, :completion_proc => nil, :use_this_shared_logger => nil, :do_not_shutdown_logger => false, :termination_proc => nil # 44

  end

  it "should allow for class arguments in class methods defined with like Name.method" do
    Klass.send( :named_arguments_for, :'self.klass_defaults_with_class2')
    Klass.klass_defaults_with_class2(1, 3).should == 3
    Klass.klass_defaults_with_class2(:a => 3).should == 3
    Klass.klass_defaults_with_class2().should == 3
  end
  
  it "should allow overriding with nil" do
    Klass.send( :named_arguments_for, :two )
    @instance.two( 1, :three => nil ).should == [1, 2, nil]
  end
  
  it "should pass block" do
    Klass.send( :named_arguments_for, :with_block )
    @instance.with_block( 1, :three => nil, :two => 'something' ){ :block }.should == [1, 'something', nil, :block]
  end
  
  it "should patch methods that accept proc as argument" do
    Klass.send( :named_arguments_for, :with_block2 )
    @instance.with_block2(1, :three => nil, :two => 'something'){ :block }.should == [1, 'something', nil, :block]
  end
  
  it "should override defaults on standard passing" do
    Klass.send( :named_arguments_for, :asr )
    @instance.asr(0, 1, :curve => 3).should == [0, 1, 1, 3]
  end

  it "should work with class methods" do
    (class << Klass; self; end).send( :named_arguments_for, :k_method )
    Klass.k_method(:d => :d).should == [1, 2, 3, :d]
    #(class << Klass; self; end).send( :named_arguments_for, :k_method )
    #Klass.k_method(:d => :d).should == [1, 2, 3, :d]
  end
  
  it "should override defaults on standard passing" do
    Klass.send( :named_arguments_for, 'self.k_method' )
    Klass.k_method(:d => :d).should == [1, 2, 3, :d]
  end
  
  it "should not use options if all arguments are passed" do
    Klass.send( :named_arguments_for, :two )
    @instance.two( 1, 2, :three => nil ).should == [1, 2, {:three => nil}]
  end
  
  it "should raise ArgumentError if passing a not recoginized keyword" do
    Klass.send( :named_arguments_for, :two )
    error =
    begin 
      @instance.two( 1, :four => nil )
    rescue ArgumentError => e
      e
    end
    error.to_s.should == "`four` is not a recognized argument keyword"
  end
  
  it "should raise ArgumentError if passing recoginized keywords" do
    Klass.send( :named_arguments_for, :two )
    error =
    begin 
      @instance.two( 1, :four => nil, :five => nil  )
    rescue ArgumentError => e
      e
    end
    error.to_s.should == "`four, five` are not recognized argument keywords" rescue  error.to_s.should == "`five, four` are not recognized argument keywords"
  end
  
  it "should not patch methods that accept no args" do
    Klass.send( :named_arguments_for, :no_args )
    lambda { @instance.no_args(1) }.should raise_error(ArgumentError)
    @instance.no_args.should be_nil
  end
  
  it "should not patch methods that use splatter op" do
    Klass.send( :named_arguments_for, :splatted )
    @instance.splatted(1, :args => 1).should == [1, {:args => 1}]
  
    Klass.send( :named_arguments_for, :splatted2 )
    @instance.splatted2(:a => 1, :"*rest" => 3).should == [{:a => 1, :'*rest' => 3}, []]
  
    Klass.send( :named_arguments_for, :splatted3 )
    @instance.splatted3(:a => 1, :"*args" => 3).should == [{:a => 1, :"*args" => 3}, []]
    @instance.splatted3(1, :b => 2, :args => 1).should == [1, [{:b => 2, :args => 1}]]
  
    Klass.send( :named_arguments_for, :splatted4 )
    @instance.splatted4(1, :b => 2, :args => 1).should == [1, {:b => 2, :args => 1}, []]
  end
  
  it "should patch methods with no optionals" do
    Klass.send( :named_arguments_for, :no_opts )
    @instance.method(:no_opts).arity.should == -1
  end
  
  it "should handle named blocks" do
    @instance.with_block3(3, 3).should==3
    Klass.send(:named_args, :with_block3)
    @instance.with_block3(3, nil, 4).should==4
    @instance.with_block3(3).should==3
  end

  it "should patch all methods" do
    Klass.send( :named_args )
    @instance.two(1, :three => 3).should == [1, 2, 3]
  end
  
  it "should benchmark without hack" do
    puts Benchmark.measure {
      1_000.times do
        @instance.with_block( 1, :three => nil ){ :block }
      end
    }
  end

  it "should work with modules (not working yet)" do
     require 'module.rb'
     TestMod.send(:named_arguments_for, :go)
     IncludesTestMod.new.go(1,2).should == 2
     IncludesTestMod.new.go(:a => 1, :b => 2).should == 2
  end

  it "should benchmark with hack" do
    puts Benchmark.measure {
      Klass.send( :named_arguments_for, :with_block )
    }
    puts Benchmark.measure {
      1_000.times do
        @instance.with_block( 1, :three => nil ){ :block }
      end
    }
  end


end