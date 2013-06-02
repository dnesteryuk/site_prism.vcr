require_relative '../sections/console_block'

class BasePage < SitePrism::Page
  element :result_block,  '#result'
  section :console_block, ConsoleBlockSection, '#console'

  def wait_for_octocat_and_martian
    console_block.octocat && console_block.martian
  end

  def wait_for_tom_and_zeus
    console_block.tom && console_block.zeus
  end

  def wait_for_octocat_and_zeus
    console_block.octocat && console_block.zeus
  end
end