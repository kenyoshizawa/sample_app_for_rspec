require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    # ファクトリー
    it "Userファクトリーは有効" do
      expect(FactoryBot.build(:user)).to be_valid
    end

    it "Taskファクトリーは有効" do
      expect(FactoryBot.build(:task_todo)).to be_valid
    end

    # モデル
    it '全ての属性がなければ無効' do
      user = FactoryBot.create(:user)
      task = user.tasks.build(
        title: 'タイトル',
        content: 'コンテンツ',
        status: 0,
        deadline: '2020-08-18'
      )
      expect(task).to be_valid
    end

    # validates :title, presence: true, uniqueness: true
    it 'タイトルがなければ無効' do
      task = FactoryBot.build(:task_todo, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    # アソシエーション
    it '重複したタイトルは無効（ユーザーは重複したタイトルのタスクを持たない）' do
      user = FactoryBot.create(:user)
      FactoryBot.create(:task_todo,
        user: user,
        title: 'タイトル'
      )

      task = FactoryBot.build(:task_todo,
        user: user,
        title: 'タイトル'
      )
      task.valid?
      expect(task.errors[:title]).to include('has already been taken')
    end

    # alidates :status, presence: true
    it 'ステータスがなければ無効' do
      task = FactoryBot.build(:task_todo, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end


    # # アソシエーション
    # it '２人のユーザーは同じタスクを共有できない' do
    #   user = FactoryBot.create(:user)
    #   FactoryBot.create(:task_todo,
    #     user: user,
    #     title: '同じタスク'
    #   )
    #
    #   other_user = FactoryBot.build(:user)
    #   other_task = FactoryBot.build(:task_todo,
    #     user: other_user,
    #     title: '同じタスク'
    #   )
    #   expect(other_task.errors[:title]).to include('has already been taken')
    # end
  end
end
