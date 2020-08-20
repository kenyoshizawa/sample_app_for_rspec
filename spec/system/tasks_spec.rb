require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    let!(:task) { create(:task_todo, user: user) }
    
    describe 'タスク新規作成' do
      it 'ログインページにリダイレクトされること' do
        visit new_task_path
        expect(current_path).to eq login_path
        expect(page).to have_content "Login required"
      end
    end

    context 'タスクの編集ページにアクセス' do
      it '編集ページへのアクセスが失敗する' do
        visit edit_task_path(task)
        expect(page).to have_content('Login required')
        expect(current_path).to eq login_path
      end
    end

    context 'タスクの詳細ページにアクセス' do
      it 'タスクの詳細情報が表示される' do
        visit task_path(task)
        expect(page).to have_content task.title
        expect(current_path).to eq task_path(task)
      end
    end

    context 'タスクの一覧ページにアクセス' do
      it 'すべてのユーザーのタスク情報が表示される' do
        task_list = create_list(:task_todo, 3)
        visit tasks_path
        expect(page).to have_content task_list[0].title
        expect(page).to have_content task_list[1].title
        expect(page).to have_content task_list[2].title
        expect(current_path).to eq tasks_path
      end
    end
  end

  describe 'ログイン後' do
    before { login_as_user(user) }

    describe 'タスク新規作成' do
      it 'タスクが作成できること' do
        visit new_task_path
        fill_in 'Title', with: 'テストタイトル'
        fill_in 'Content', with: 'テスト本文'
        select 'todo', from: 'Status'
        fill_in 'Deadline', with: DateTime.new(1993, 2, 24, 12, 30)
        click_button 'Create Task'
        expect(current_path).to eq task_path(user)
        expect(page).to have_content('Task was successfully created.'), 'フラッシュメッセージ「Task was successfully created.」が表示されていません'
        expect(page).to have_content('テストタイトル'), '作成したタスクのタイトルが表示されていません'
        expect(page).to have_content('テスト本文'), '作成したタスクの本文が表示されていません'
        expect(page).to have_content('todo'), '作成したタスクのステータスが表示されていません'
        expect(page).to have_content('1993/2/24 12:30'), '作成したタスクのデッドライン日時が表示されていません'
      end
    end

    describe 'タスク編集' do
      let!(:task) { create(:task_todo, user: user) }
      let(:other_user) { create(:user) }
      let(:other_task) { create(:task_todo, user: other_user) }

      context '自分のタスク' do
        it 'タスクが編集できること' do
          visit edit_task_path(task)
          fill_in 'Title', with: 'テストタイトル編集'
          fill_in 'Content', with: 'テスト本文編集'
          select 'done', from: 'Status'
          # fill_in 'Deadline', with: DateTime.new(2021, 2, 24, 12, 30)

          click_button 'Update Task'
          expect(current_path).to eq task_path(user)
          expect(page).to have_content('Task was successfully updated.'), 'フラッシュメッセージ「Task was successfully updated.」が表示されていません'
          expect(page).to have_content('テストタイトル編集'), '更新したタスクのタイトルが表示されていません'
          expect(page).to have_content('テスト本文編集'), '更新したタスクの本文が表示されていません'
          expect(page).to have_content('done'), '更新したタスクのステータスが表示されていません'
          # expect(page).to have_content('2021/2/24 12:30'), '更新したタスクのデッドライン日時が表示されていません'
        end

      end

      context '他人のタスク' do
        it 'タスク編集ページへ遷移できないこと' do
          visit edit_task_path(other_task)
          expect(current_path).to eq root_path
          expect(page).to have_content('Forbidden access.'), 'フラッシュメッセージ「Forbidden access.」が表示されていません'
        end
      end
    end

    describe 'destroy' do
      let!(:task) { create(:task_todo, user: user) }

      context '自分の掲示板' do
        it '掲示板が削除できること' do
          visit tasks_path
          page.accept_confirm { click_on('Destroy') }
          expect(current_path).to eq tasks_path
          expect(page).to have_content('Task was successfully destroyed.'), 'フラッシュメッセージ「Task was successfully destroyed.」が表示されていません'
        end
      end
    end
  end
end
