module SplitCat
  module ExperimentsHelper

    def experiment_csv_link( experiment )
      content_tag( :p ) do
        text = t( :export_as_csv, :scope => :split_cat )
        path = experiment_path( experiment, :format => 'csv' )
        concat link_to text, path
      end
    end

    def experiment_goal_list( experiment )
      content_tag( :ul ) do
        experiment.goals.each do |goal|
          concat content_tag( :li, experiment_goal( goal ) )
        end
      end
    end

    def experiment_goal( goal )
      content_tag( :p ) do
        concat content_tag( :b, goal.name )
        concat ' - '
        concat goal.description
      end
    end

    def experiment_hypothesis( hypothesis )
      ratio = hypothesis.weight.to_f / hypothesis.experiment.total_weight

      content_tag( :p ) do
        concat content_tag( :b, hypothesis.name )
        concat sprintf( " (%0.0f%%)", ratio * 100 )
        concat ' - '
        concat hypothesis.description
      end
    end

    def experiment_hypothesis_list( experiment )
      content_tag( :ul ) do
        experiment.hypotheses.each do |hypothesis|
          concat content_tag( :li, experiment_hypothesis( hypothesis ) )
        end
      end
    end

    def experiment_hypothesis_percentage( hypothesis, value )
      experiment = hypothesis.experiment
      value = number_with_delimiter( value || 0 )

      ratio = experiment.hypothesis_counts[ hypothesis.name ] || 0
      return sprintf( "%s ()", value ) if ratio == 0

      return sprintf( "%s (%0.1f%%)", value, ( value.to_f / ratio ) * 100 )
    end

    def experiment_info( experiment )
      content_tag( :table ) do
        concat experiment_info_row( :id, experiment.id )
        concat experiment_info_row( :name, experiment.name )
        concat experiment_info_row( :description, experiment.description )
        concat experiment_info_row( :created, experiment.created_at )
        concat experiment_info_row( :active, experiment.active? )
        concat experiment_info_row( :subjects, number_with_delimiter( experiment.total_subjects ) )
      end
    end

    def experiment_info_row( name, value )
      content_tag( :tr ) do
        concat content_tag( :th, t( name, :scope => :split_cat ) )
        concat content_tag( :td, value )
      end
    end

    def experiment_report( experiment )
      content_tag( :table, :border => 1 ) do
        concat experiment_report_header( experiment )
        concat experiment_report_totals( experiment )
        experiment.goals.each do |goal|
          concat experiment_report_goal( goal )
        end
      end
    end

    def experiment_report_goal( goal )
      experiment = goal.experiment
      style = cycle( 'background-color: #dddddd;', '' )

      content_tag( :tr ) do
        concat content_tag( :th, goal.name, :style => style )
        experiment.hypotheses.each do |hypothesis|
          count = experiment.goal_counts[ goal.name ][ hypothesis.name ]
          percentage = experiment_hypothesis_percentage( hypothesis, count )
          concat content_tag( :td, percentage, :style => style )
        end
      end

    end

    def experiment_report_header( experiment )
      content_tag( :tr ) do
        concat content_tag( :th )
        experiment.hypotheses.each do |hypothesis|
          concat content_tag( :th, hypothesis.name )
        end
      end
    end

    def experiment_report_totals( experiment )
      content_tag( :tr ) do
        concat content_tag( :th, t( :total, :scope => :split_cat ) )
        experiment.hypotheses.each do |hypothesis|
          count = experiment.hypothesis_counts[ hypothesis.name ]
          concat content_tag( :td, experiment_hypothesis_percentage( hypothesis, count ) )
        end
      end
    end

    def experiment_search_form( name, active)
      render :partial => 'form', :locals => { :name => name, :active => active }
    end

    def experiment_table( experiments )
      content_tag( :table, :border => 1 ) do
        output = content_tag( :tr ) do
          concat content_tag( :th, t( :id, :scope => :split_cat ) )
          concat content_tag( :th, t( :name, :scope => :split_cat ) )
          concat content_tag( :th, t( :active, :scope => :split_cat ) )
        end

        show = t( :show, :scope => :split_cat )

        experiments.each do |experiment|
          output += content_tag( :tr ) do
           concat content_tag( :td, experiment.id )
           concat content_tag( :td, experiment.name )
           concat content_tag( :td, experiment.active? )
           concat content_tag( :td, link_to( show, { :controller => :experiments, :action => :show, :id => experiment.id } ) )
          end
        end

        output
      end
    end

  end
end
