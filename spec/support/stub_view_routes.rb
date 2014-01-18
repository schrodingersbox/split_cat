# Engine is getting app routes, rather than engine routes.
# Tried several approaches to resolve, before this rank hack.
# Revisit after a few RSpec and Rails updates to see if it persists

def stub_view_routes

  view.stub( :experiment_path ).and_return( '/split_cat/experiment' )
  view.stub( :experiments_path ).and_return( '/split_cat/experiments' )
  view.stub( :new_experiment_path ).and_return( '/split_cat/experiments/new' )

end