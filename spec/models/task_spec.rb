require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it '全ての属性がなければ無効' do
      task = FactoryBot.build(:task_todo)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end

    # validates :title, presence: true, uniqueness: true
    it 'タイトルがなければ無効' do
      task_without_title = FactoryBot.build(:task_todo, title: "")
      expect(task_without_title).to be_invalid
      expect(task_without_title.errors[:title]).to eq ["can't be blank"]
    end

    it 'ステータスがなければ無効' do
      task_without_status = FactoryBot.build(:task_todo, status: nil)
      expect(task_without_status).to be_invalid
      expect(task_without_status.errors[:status]).to eq ["can't be blank"]
    end

    it '重複したタイトルは無効' do
      task = FactoryBot.create(:task_todo)
      task_with_duplicated_title = FactoryBot.build(:task_todo, title: task.title)
      expect(task_with_duplicated_title).to be_invalid
      expect(task_with_duplicated_title.errors[:title]).to eq ["has already been taken"]
    end


    it '異なるタイトルは有効' do
      task = FactoryBot.create(:task_todo)
      task_with_another_title = FactoryBot.build(:task_todo, title: 'another_title')
      expect(task_with_another_title).to be_valid
      expect(task_with_another_title.errors).to be_empty
    end
  end
end
