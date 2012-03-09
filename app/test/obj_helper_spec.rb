describe "ObjHelper" do
  
  class TempClass
  end
  
  before(:all) do
    @test_class = TempClass.new
    @test_class.extend(ObjHelper)
  end

  it "should remove leading 'The'" do
    test_string = "the test"
    expected = "test"
    @test_class.make_sort_title(test_string).should == expected
  end

  it "should remove leading 'An'" do
    test_string = "an test"
    expected = "test"
    @test_class.make_sort_title(test_string).should == expected
  end

  it "should remove leading 'A'" do
    test_string = "a test"
    expected = "test"
    @test_class.make_sort_title(test_string).should == expected
  end

  it "shouldn't remove 'The' after first word" do
    test_string = "test the"
    @test_class.make_sort_title(test_string).should == test_string
  end

  it "shouldn't remove 'An' after first word" do
    test_string = "test an"
    @test_class.make_sort_title(test_string).should == test_string
  end

  it "shouldn't remove 'A' after first word" do
    test_string = "test a"
    @test_class.make_sort_title(test_string).should == test_string
  end

  it "shouldn't remove 'the' from 'thereafter'" do
    test_string = "thereafter"
    @test_class.make_sort_title(test_string).should == test_string
  end

  it "shouldn't remove 'a' or 'an' from 'annabelle'" do
    test_string = "annabelle"
    @test_class.make_sort_title(test_string).should == test_string
  end

  it "should delete file" do
    # Create test file
    file = File.join(Rho::RhoApplication::get_base_app_path(), "test.jpg")
    File.new(file, "w+")
    # Check file has been created
    File.exists?(file).should == true
    # Delete file
    @test_class.delete_image(file)
    # Check that the file has been deleted.
    File.exists?(file).should == false
  end

  it "shouldn't raise error when a file doesn't exist" do
    # Get example file path
    file = File.join(Rho::RhoApplication::get_base_app_path(), "test.jpg")
    # Check file has not been created
    File.exists?(file).should == false
    # Attempt Delete file
    @test_class.delete_image(file).should_not raise_error(IOError)
  end
 
end
