FactoryBot.define do
  factory :task do
    association :user
    sequence(:title, "title_1")
    content { 'コンテンツ' }
    deadline { 1.week.from_now }

    factory :task_todo do
      status { :todo }
    end

    factory :task_doing do
      status { :doing }
    end

    factory :task_done do
      status { :done }
    end
  end
end
