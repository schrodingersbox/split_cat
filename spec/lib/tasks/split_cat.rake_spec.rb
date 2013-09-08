require 'spec_helper'
require 'rake'

describe 'spec_cat rake tasks' do

  before( :each ) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake::Task.define_task(:environment)
    load 'lib/tasks/meter_cat.rake'
  end

end
