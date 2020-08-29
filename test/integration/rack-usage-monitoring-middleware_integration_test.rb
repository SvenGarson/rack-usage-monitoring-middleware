=begin
  - fake requests and if data tracked the right
  - that Attribute#uupdate(value=nil) deep copies the objects passed to
    the Attribute#update_each method, i.e. not the same and internal state
    not leaking
  - that Attribute#update(value=nil) actually returns the argument for every tracker type
    this could not be tested since the Attribute itself does not responds to #update_each
    because we want it to be up to the class and throw an error if it is not overriden
    Also make sure the argument is the exact same in terms of object id and mutation(i.e. unchanged)
=end