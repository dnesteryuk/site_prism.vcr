require_relative '../sections/console_block'

class BasePage < SitePrism::Page
  element :cat_owner, '#result'
  section :console_block, ConsoleBlockSection, '#console'

  def wait_for_arya_stark_and_jon_snow
    console_block.arya_stark && console_block.jon_snow
  end

  def wait_for_ned_stark_and_robb_stark
    console_block.ned_stark && console_block.robb_stark
  end

  def wait_for_arya_stark_and_robb_stark
    console_block.arya_stark && console_block.robb_stark
  end
end