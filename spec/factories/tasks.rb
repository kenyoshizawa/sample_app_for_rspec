FactoryBot.define do
  factory :task do
    association :user
    sequence(:title) { |n| "タイトル#{n}"}
    content { 'コンテンツ' }
    deadline { '2020-08-18' }

    factory :task_todo do
      status { 0 }
    end

    factory :task_doing do
      status { 1 }
    end

    factory :task_done do
      status { 2 }
    end
  end
end
