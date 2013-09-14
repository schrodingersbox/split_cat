select goal_id, hypothesis_id, count( goal_id ) as subject_count
from split_cat_goal_subjects
where experiment_id = 1
group by goal_id, hypothesis_id
