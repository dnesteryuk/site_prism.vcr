require_relative '../sections/console_block'

class BasePage < SitePrism::Page
  element :result_block,  '#result'
  section :console_block, ConsoleBlockSection, '#console'
end