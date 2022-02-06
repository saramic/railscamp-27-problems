require "selenium-webdriver"
require "capybara"
require "pry"

source_url = ENV.fetch("SOURCE_URL")
user = ENV.fetch("USER")
pass = ENV.fetch("PASS")

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.javascript_driver = :chrome
Capybara.configure do |config|
  config.default_max_wait_time = 10 # seconds
  config.default_driver = :selenium
end

browser = Capybara.current_session

browser.visit source_url

browser.find_all("a", text: "Log in").first.click
# browser.find_all("form").first.native["innerHTML"]
sleep(2)
browser.send_keys(:tab)
browser.send_keys(:tab)
sleep(1)
browser.send_keys(user)
sleep(1)
browser.send_keys(:tab)
sleep(1)
browser.send_keys(pass)
sleep(1)
browser.send_keys(:tab)
sleep(1)
browser.send_keys(:enter)

binding.pry

def add_item(browser, item)
  sleep(1)
  input_buttons = browser.find_all("button[data-testid=Input_EditButton]")
  input_buttons[0].click
  sleep(1)
  browser.send_keys("https://en.wikipedia.org/wiki/#{item}")
  sleep(1)
  input_buttons[1].click
  sleep(1)
  browser.send_keys("https://en.wikipedia.org/wiki/#{item}")
  browser.find("[data-testid=LinkEditor_Link_Add_Button]").click
  sleep(1)
end

items = ARGV.join.split("\n")
binding.pry
items.each{ |item| add_item(browser, item) }
binding.pry

