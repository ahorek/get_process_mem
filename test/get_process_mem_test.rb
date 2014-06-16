require 'test_helper'

class GetProcessMemTest < Test::Unit::TestCase

  def setup
    @mem = GetProcessMem.new
  end

  def test_seems_to_work
    assert @mem.kb    > 0
    assert @mem.mb    > 0
    assert @mem.gb    > 0
    assert @mem.bytes > 0
  end

  def test_linux_smap
    delta = 1
    bytes = @mem.linux_memory(fixture_path("heroku-bash-smap"))
    assert_in_delta BigDecimal.new("2122240.0"), bytes, delta
  end

  def test_conversions
    bytes = 0
    delta = BigDecimal.new("0.0000001")
    assert_in_delta  0.0, @mem.kb(bytes), delta
    assert_in_delta  0.0, @mem.mb(bytes), delta
    assert_in_delta  0.0, @mem.gb(bytes), delta

    # kb
    bytes = 1024
    assert_in_delta  1.0,                 @mem.kb(bytes), delta
    assert_in_delta  0.0009765625,        @mem.mb(bytes), delta
    assert_in_delta  9.5367431640625e-07, @mem.gb(bytes), delta

    # mb
    bytes = 1_048_576
    assert_in_delta  1024.0,              @mem.kb(bytes), delta
    assert_in_delta  1.0,                 @mem.mb(bytes), delta
    assert_in_delta  0.0009765625,        @mem.gb(bytes), delta

    # gb
    bytes = 1_073_741_824
    assert_in_delta  1048576.0,           @mem.kb(bytes), delta
    assert_in_delta  1024.0,              @mem.mb(bytes), delta
    assert_in_delta  1.0,                 @mem.gb(bytes), delta
  end
end