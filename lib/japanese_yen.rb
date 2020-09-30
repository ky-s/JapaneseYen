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
      raise ArgumentError, "Cannot create #{self.class} object from #{value.class}, because it is not a kind of Numeric."

    @value = value
  end

  # JapaneseYen[100, 200, 300]
  # => Vector[JapaneseYen[¥100], JapaneseYen[¥200], JapaneseYen[¥300]]
  #
  # JapaneseYen[[100, 200], [300, 400]]
  # => Matrix[[JapaneseYen[¥100], JapaneseYen[¥200]], [JapaneseYen[¥300], JapaneseYen[¥400]]]
  #
  def self.[](*values)
    if values.first.kind_of?(Enumerable)
      generate_matrix(*values)
    else
      values.size == 1 ?
        self.new(values.first) : generate_vector(*values)
    end
  end

  def self.generate_vector(*values)
    Vector.elements(values.map { |value| self.new(value) })
  end

  def self.generate_matrix(*value_arrays)
    rows = value_arrays.map { |values| generate_vector(*values) }
    Matrix.rows(rows)
  end

  def +(other)
    right, left = coerce(other)
    self.class.new(left.value + right.value)
  end

  def -(other)
    right, left = coerce(other)
    self.class.new(left.value - right.value)
  end

  def *(other)
    right, left = coerce(other)
    self.class.new(left.value * right.value)
  end

  def /(other)
    right, left = coerce(other)
    self.class.new(left.value / right.value)
  end

  def %(other)
    right, left = coerce(other)
    self.class.new(left.value % right.value)
  end

  def divmod(other)
    right, left = coerce(other)
    integer, fraction = left.value.divmod(right.value)
    Vector[self.class.new(integer), self.class.new(fraction)]
  end

  def **(other)
    right, left = coerce(other)
    self.class.new(left.value ** right.value)
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
    if other.kind_of?(JapaneseYen)
      [other, self]
    elsif other.kind_of?(Numeric)
      [self.class.new(other), self]
    else
      super.map { |n| self.class.new(n) }
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
    self.class.new(to_f)
  end

  def rationalize!
    @value = to_r
  end

  def rationalize
    self.class.new(to_r)
  end

  def to_s
    '¥' + @value.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,')
  end

  def inspect
    "#{self.class}[#{to_s}]"
  end

  def dup
    self.class.new(@value)
  end
end
