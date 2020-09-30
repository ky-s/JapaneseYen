# Japanese Yen class
#
# yen = JapaneseYen.new(10_000)
# => JapaneseYen[¥10,000]
#
# yen = JapaneseYen[310_000]
# => JapaneseYen[¥310,000]
#
# puts yen
# => ¥310,000
#
# yen * 1.10
# => ¥11,000
#
require 'matrix'

class JapaneseYen < Numeric
  attr_reader :value
  alias amount value

  def initialize(value)
    value.kind_of?(Numeric) or
      raise ArgumentError, "Cannot create JapaneseYen object from #{value.class}, because it is not a kind of Numeric."

    @value = value
  end

  def self.[](value)
    self.new(value)
  end

  def self.vectorize(*values)
    Vector.elements(values.map { |value| self.new(value) })
  end

  def +(other)
    right, left = coerce(other)
    JapaneseYen.new(left.value + right.value)
  end

  def -(other)
    right, left = coerce(other)
    JapaneseYen.new(left.value - right.value)
  end

  def *(other)
    right, left = coerce(other)
    JapaneseYen.new(left.value * right.value)
  end

  def /(other)
    right, left = coerce(other)
    JapaneseYen.new(left.value / right.value)
  end

  def %(other)
    right, left = coerce(other)
    JapaneseYen.new(left.value % right.value)
  end

  def divmod(other)
    right, left = coerce(other)
    integer, fraction = left.value.divmod(right.value)
    Vector[JapaneseYen.new(integer), JapaneseYen.new(fraction)]
  end

  def **(other)
    right, left = coerce(other)
    JapaneseYen.new(left.value ** right.value)
  end

  def ==(other)
    right, left = coerce(other)
    left.value == right.value
  end

  def <=>(other)
    right, left = coerce(other)
    left.value <=> right.value
  end

  def coerce(other)
    if other.is_a?(JapaneseYen)
      [other, self]
    elsif other.is_a?(Numeric)
      [JapaneseYen.new(other), self]
    else
      super.map { |n| JapaneseYen.new(n) }
    end
  end

  def to_i
    round.value
  end

  def to_f
    @value.to_f
  end

  def to_r
    @value.to_r
  end

  def round!(*args)
    @value = @value.round(*args)
  end

  def round(*args)
    dup.tap { |new_instance| new_instance.round!(*args) }
  end

  def decimalize!
    @value = to_f
  end

  def decimalize
    JapaneseYen.new(to_f)
  end

  def rationalize!
    @value = to_r
  end

  def rationalize
    JapaneseYen.new(to_r)
  end

  def to_s
    '¥' + @value.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,')
  end

  def inspect
    "JapaneseYen[#{to_s}]"
  end

  def dup
    JapaneseYen.new(@value)
  end
end
