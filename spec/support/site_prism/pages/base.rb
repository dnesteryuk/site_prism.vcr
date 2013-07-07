require_relative '../sections/console_block'

class BasePage < SitePrism::Page
  element :result_block,  '#result'
  section :console_block, ConsoleBlockSection, '#console'

  def wait_for_max_and_felix
    console_block.max && console_block.felix
  end

  def wait_for_tom_and_zeus
    console_block.tom && console_block.zeus
  end

  def wait_for_max_and_zeus
    console_block.max && console_block.zeus
  end
end