require 'test_helper'

class UnreadItemsTest < ActionDispatch::IntegrationTest
  def setup
    @user = FactoryGirl.create(:user)
    @article = FactoryGirl.create(:article, title: "Unicorns!", author: @user)
  end

  test "unicorns see an unread article" do
    visit articles_path
    assert_no_content("1 Updates")

    sign_user_in(@user)
    assert_content("1 Updates")

    visit article_path(@article)
    assert_no_content("1 Updates")
  end

  test "unicorns can mark all articles as read" do
    2.times { FactoryGirl.create(:article, title: "Title of Unicorns!", author: @user) }

    visit articles_path
    assert_no_content("3 Updates")

    sign_user_in(@user)
    assert_content("3 Updates")

    click_on "Mark all as read"
    assert_no_content("3 Updates")
  end

  test "unicorns can mark as read on an article via clicking on unread indicator" do
    Capybara.current_driver = Capybara.javascript_driver

    sign_user_in(@user)

    assert_content("1 Updates")

    within("#article_#{@article.id}") do
      click_link "Mark as read"

      assert_no_link("Mark as read")
    end

    assert_no_content("1 Updates")
  end
end
