module LoginHelper
  def login_as_user(user)
    visit root_path
    click_link 'Login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Login'
    expect(current_path).to eq root_path
    expect(page).to have_content "Login successful"
  end
end
