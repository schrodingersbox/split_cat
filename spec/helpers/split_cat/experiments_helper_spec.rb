require 'spec_helper'

describe SplitCat::ExperimentsHelper do

  let( :experiment ) { FactoryGirl.create( :experiment_full ) }

  before( :each ) do
    SplitCat.config.experiments.clear
  end

  describe '#experiment_csv_link' do

    it 'renders a link to the experiment as csv' do
      helper.should_receive( :experiment_path ).with( experiment, :format => 'csv' ).and_return( '/' )

      expected = "<p><a href=\"/\">Export as CSV</a></p>"
      helper.experiment_csv_link( experiment ).should eql( expected )
    end
  end

  describe '#experiment_goal_list' do

    it 'renders the experiment goals as a list' do
      helper.experiment_goal_list( experiment ).should eql_file( 'spec/data/helpers/experiment_goal_list.html' )
    end

  end

  describe '#experiment_goal' do

    it 'renders the goal' do
      expected = "<p><b>goal_a</b> - this is goal a</p>"
      helper.experiment_goal( experiment.goals.first ).should eql( expected )
    end

  end

  describe '#experiment_hypothesis' do

    it 'renders the hypothesis' do
      expected = "<p><b>hypothesis_a</b> (10%) - this is hypothesis a</p>"
      helper.experiment_hypothesis( experiment.hypotheses.first ).should eql( expected )
    end

  end

  describe '#experiment_hypothesis_percentage' do

    it 'renders a value as a percentage of total for the given hypothesis' do
      hypothesis = experiment.hypotheses.first
      experiment.hypothesis_counts[ hypothesis.name ] = 10

      expected = "1 ()"
      helper.experiment_hypothesis_percentage( hypothesis, 1 ).should eql( expected )
    end

    it 'tolerates missing and zero totals' do
      hypothesis = experiment.hypotheses.first

      experiment.hypothesis_counts.delete( hypothesis.name )

      expected = "1 ()"
      helper.experiment_hypothesis_percentage( hypothesis, 1 ).should eql( expected )
    end

  end

  describe '#experiment_info' do

    it 'renders a table with basic information about the experiment' do
      helper.experiment_info( experiment ).should eql_file( 'spec/data/helpers/experiment_info.html' )
    end

  end

  describe '#experiment_info_row' do

    it 'renders a row of the info table' do
      helper.experiment_info_row( 'foo', 'bar' ).should eql_file( 'spec/data/helpers/experiment_info_row.html' )

    end

  end

  describe '#experiment_report' do

    it 'renders the report table' do
      experiment_report( experiment ).should eql_file( 'spec/data/helpers/experiment_report.html' )
    end

  end

  describe '#experiment_report_goal' do

    it 'renders a goal row in the report table' do
      goal = experiment.goals.first
      experiment_report_goal( goal ).should eql_file( 'spec/data/helpers/experiment_report_goal.html' )
    end

  end

  describe '#experiment_report_header' do

    it 'renders a header row in the report table' do
      experiment_report_header( experiment ).should eql_file( 'spec/data/helpers/experiment_report_header.html' )
    end

  end

  describe '#experiment_report_totals' do

    it 'renders a total row in the report table' do
      experiment_report_header( experiment ).should eql_file( 'spec/data/helpers/experiment_report_totals.html' )
    end

  end

  describe '#experiment_search_form' do

    it 'renders the _form partial with locals' do
      name = 'foo'
      active = true
      helper.should_receive( :render ).with( :partial => 'form', :locals => { :name => name, :active => active } )
      helper.experiment_search_form( name, active )
    end

  end

  describe '#experiment_table' do

    it 'renders a total row in the report table' do
      experiment_table( Experiment.all ).should eql_file( 'spec/data/helpers/experiment_table.html' )
    end

  end

end