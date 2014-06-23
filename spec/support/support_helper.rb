shared_context "support helper" do

  private

  def wait_longer_for_ajax
    counter = 0
    while page.evaluate_script("typeof($) === 'undefined' || $.active > 0")
      counter += 1
      sleep(0.1)
      raise "AJAX request took longer than 5 seconds." if counter >= 200
    end
  end

end
