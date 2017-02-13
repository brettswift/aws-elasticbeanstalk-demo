#Guard runs continuous tests, triggered when you save a file.
#simply run `guard` to have your tests run continuously so you don't have
#to alt-tab and run tests all the time.

#default group
scope group: :validation

group :validation do
  guard :shell do
    watch /.*\.yaml$/ do |m|
      # if system("aws cloudformation validate-template --template-body file:////Users/bswift/src/aws/simple_web_auto_scaling/#{m[0]}")
      pwd = Dir.pwd
      puts pwd
      `aws cloudformation validate-template --template-body file:///#{pwd}/#{m[0]}`
      # if system("aws cloudformation validate-template --template-body file:////Users/bswift/src/aws/simple_web_auto_scaling/*.yaml")
      #   n "#{m[0]} is correct", 'Template Validation', :success
      # else
      #   n "#{m[0]} is incorrect", 'Template Validation', :failed
      # end
    end
  end
end
