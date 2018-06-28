factory :graphic do |f|
  f.shape_id { 1 }
  f.user_id { 1 }
  f.color_id { 1 }
end

factory :invalid_graphic, parent: :graphic do |f|
  f.user_id nil
end