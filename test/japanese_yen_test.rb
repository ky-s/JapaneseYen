require "test_helper"

class JapaneseYenTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::JapaneseYen::VERSION
  end

  def test_initializing
    yen = JapaneseYen.new(1_000_000)
    assert 1_000_000, yen
    assert 1_000_000, yen.value
    assert 1_000_000, yen.amount

    assert_equal JapaneseYen[1_000_000], yen

    assert_equal 10.0, JapaneseYen[10.0]
    assert_equal Rational(234, 3), JapaneseYen[Rational(234, 3)]

    # JapaneseYen が入っても、 JapaneseYen の value にそのまま設定されません。
    # 与えられた JapaneseYen の value を value に代入しますので、
    # 実質的に与えた JapaneseYen と同じものが返却されます。
    yen = JapaneseYen[10]
    assert_equal yen, JapaneseYen.new(yen)
    assert JapaneseYen.new(yen).value.kind_of?(Integer)
  end

  def test_initializing_vector
    yen_vector = JapaneseYen[10_000, 20_000, 30_000]
    assert yen_vector.kind_of?(Vector)
    assert_equal 10_000, yen_vector[0]
    assert_equal 20_000, yen_vector[1]
    assert_equal 30_000, yen_vector[2]
  end

  def test_initializing_matrix
    yen_matrix = JapaneseYen[[10_000, 20_000, 30_000],
                             [20_000, 30_000, 40_000]]

    assert yen_matrix.kind_of?(Matrix)
    assert_equal JapaneseYen[10_000], yen_matrix[0, 0]
    assert_equal JapaneseYen[40_000], yen_matrix[-1, -1]
  end

  def test_cannot_initialize_from_except_numeric_objects
    assert_raises(ArgumentError) { JapaneseYen.new("3000") }
  end

  def test_print
    yen = JapaneseYen[38_000]
    assert_equal '¥38,000', yen.to_s
    assert_equal 'JapaneseYen[¥38,000]', yen.inspect

    yen = JapaneseYen[3.14159265358979]
    assert_equal '¥3.14159265358979', yen.to_s
    assert_equal 'JapaneseYen[¥3.14159265358979]', yen.inspect

    yen = JapaneseYen[Rational(1000, 3)]
    assert_equal '¥1,000/3', yen.to_s
    assert_equal 'JapaneseYen[¥1,000/3]', yen.inspect
  end

  def test_coerce
    yen = JapaneseYen[38_000]
    assert_equal [JapaneseYen[10],               yen], yen.coerce(10)
    assert_equal [JapaneseYen[10.0],             yen], yen.coerce(10.0)
    assert_equal [JapaneseYen[Rational(111, 3)], yen], yen.coerce(Rational(111, 3))
    assert_equal [JapaneseYen[10_000.0],         yen], yen.coerce("10_000")
  end

  def test_arithmetic_operators
    # returns JapaneseYen object
    assert_equal JapaneseYen[  1_500_000], JapaneseYen[1_000_000] + JapaneseYen[500_000]
    assert_equal JapaneseYen[  1_500_000], JapaneseYen[1_000_000] + 500_000
    assert_equal JapaneseYen[  1_500_000], 1_000_000 + JapaneseYen[500_000]

    assert_equal JapaneseYen[    700_000], JapaneseYen[1_000_000] - 300_000
    assert_equal JapaneseYen[      3_000], JapaneseYen[300] * 10
    assert_equal JapaneseYen[    100_000], JapaneseYen[400_000] / 4.0
    assert_equal JapaneseYen[100_000_000], JapaneseYen[10_000] ** 2
    assert_equal JapaneseYen[        345], JapaneseYen[12_345] % 1_000

    assert_equal JapaneseYen[766, 2], JapaneseYen[2300].divmod(3)

    assert_equal JapaneseYen[161_996], (1000 + JapaneseYen[200_000] / 2.5 - 2) * 2
  end

  def test_cannot_calculation_raised
    error = assert_raises(TypeError) {
      "Cannot add" + JapaneseYen[2_000]
    }
    assert_equal "no implicit conversion of JapaneseYen into String", error.message
  end

  def test_comparing_operators
    assert JapaneseYen[10_000] == JapaneseYen[10_000]
    assert JapaneseYen[10_001] > JapaneseYen[10_000]
    assert JapaneseYen[10_000] >= JapaneseYen[10_000]
    assert JapaneseYen[10_000] < JapaneseYen[10_000.1]
    assert JapaneseYen[10_000] <= JapaneseYen[10_000]
    assert_equal(-1, JapaneseYen[400] <=> JapaneseYen[500])
    assert_equal  0, JapaneseYen[500] <=> JapaneseYen[500]
    assert_equal(+1, JapaneseYen[600] <=> JapaneseYen[500])

    assert JapaneseYen[10_000] == 10_000
    assert 10_000.0 == JapaneseYen[10_000]
  end

  def test_cannot_comparing_raised
    assert_raises(ArgumentError) {
      JapaneseYen[10_000] <= "abc"
    }
  end

  def test_converting_numeric_value
    yen = JapaneseYen.new(12345) * 0.1

    assert_equal 1235, yen.to_i
    assert_equal 1234.5, yen.to_f
    assert_equal Rational(2469, 2), yen.to_r
    assert_equal JapaneseYen[1235], yen.round
    assert_equal JapaneseYen[1234.5], yen.decimalize
    assert_equal JapaneseYen[Rational(2469, 2)], yen.rationalize
  end
end
