## Overview

Almost all code is taken from [Validatable gem](https://github.com/jnunemaker/validatable) and adopted to use with [rhodes framework](https://github.com/rhomobile/rhodes).

## Installation

Installation is pretty straightforward:

    cd rhodes_project_directory
    git clone git://github.com/artemk/rh-validatable.git extensions/rh-validatable  

  
## Usage

First you have to add *rh-validatable* to **build.yml**

      extensions:
      - rh-validatable
At the top of application.rb add:

      require "validatable"
      
Include module to your model:

      class Account
        include Validatable
      end

After that you can add your validations into the model:

      class Account
        include Rhom::FixedSchema
        include Validatable
  
        validates_confirmation_of :password  
        validates_presence_of :password
        validates_length_of :password, :within => 6..15, :message => "Password should be 6 to 15 characters"
  
  
        validates_presence_of :birth_date
        validates_presence_of :name
        validates_presence_of :gender
        validates_presence_of :cell_number
  
  
        # Email
        validates_presence_of :email  
        validates_length_of :email, :minimum => 5, :message => "should be more than 5 characters"
        validates_format_of :email, 
            :with => /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.(?:[A-Za-z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)$/, 
            :message => "should look like an email"
      


To see all available validation methods dig into **validatable/macros.rb**

## Contributing
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## TODO


## Known problems


## Author

Artem Kramarenko (artemk)


## Copyright

MIT
