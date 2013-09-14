select hypothesis_id, count( hypothesis_id ) as subject_count
from split_cat_hypothesis_subjects
where experiment_id = 1
group by hypothesis_id
