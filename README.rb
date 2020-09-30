# ruby README.rb
#
require_relative 'lib/japanese_yen'

puts """
# initializing
# ===
#   new or [],
#   vectorize generates Vector[JapaneseYen...]
#
"""
begin
  yen = JapaneseYen.new(1_000_000)

  puts yen
  # => ¥1,000,000

  yen = JapaneseYen[345_345]

  puts yen
  # => ¥345,345

  # generate Vector
  puts JapaneseYen.vectorize(10_000, 20_000, 30_000)
  # => Vector[¥10,000, ¥20,000, ¥30,000]

  puts JapaneseYen[10.0]
  puts JapaneseYen[Rational(234, 3)]

  # Cannot initialize from except Numeric objects.
  begin
    JapaneseYen.new("3000")
  rescue => e
    p e
    # => <ArgumentError: Cannot create JapaneseYen object from String, because it is not a kind of Numeric.>
  end
end

puts """
#
# atributes
# ===
#   value, amount
#   * both are same.
#
"""
begin
  yen = JapaneseYen[345_345]
  puts yen.value
  puts yen.amount # Alias of value
  # => 345345
end

puts """
#
# print
# ===
#   to_s and inspect
#
"""
begin
  yen = JapaneseYen[38_000]

  puts yen
  # => ¥38,000
  p yen
  # => JapaneseYen[¥38,000]
end

puts """
#
# Artihmetic operators
# ===
#   +, -, *, /, **, %, divmod
#   It makes always JapaneseYen object by #coerce.
#
"""
begin
  puts JapaneseYen[1_000_000] + 500_000
  # => ¥1,500,000
  puts JapaneseYen[1_000_000] - 300_000
  # => ¥700,000
  puts JapaneseYen[300] * 10
  # => ¥3,000
  puts JapaneseYen[400_000] / 4.0
  # => ¥100_000.0
  puts JapaneseYen[10_000] ** 2
  # => ¥100,000,000
  puts JapaneseYen[12_345] % 1_000
  # => ¥345
  p JapaneseYen[2300].divmod(3)
  # => Vector[JapaneseYen[¥766], JapaneseYen[¥2]]


  puts (1000 + JapaneseYen[200_000] / 2.5 - 2) * 2
  # => ¥161,996.0

  begin
    "Cannot add" + JapaneseYen[2_000]
  rescue => e
    p e
    # => <TypeError: no implicit conversion of JapaneseYen into String>
  end
end

puts """
#
# Comparing operators
#   ==, <, >, <=, >=, <=>
#
"""
puts JapaneseYen[10_000] == JapaneseYen[10_000]
# => true
puts JapaneseYen[10_000] > JapaneseYen[10_000]
# => false
puts JapaneseYen[10_000] >= JapaneseYen[10_000]
# => true
puts JapaneseYen[10_000] < JapaneseYen[10_000]
# => false
puts JapaneseYen[10_000] <= JapaneseYen[10_000]
# => true
puts JapaneseYen[400] <=> JapaneseYen[500]
# => -1
puts JapaneseYen[500] <=> JapaneseYen[500]
# => 0
puts JapaneseYen[600] <=> JapaneseYen[500]
# => 1

puts """
#
# Numeric value converting
# ===
#   round, to_i, to_f, to_r
#
"""
begin
  yen = JapaneseYen.new(12345) * 0.1
  puts yen
  # => ¥1,234.5

  puts yen.to_i
  # => 1235
  puts yen.to_f
  # => 1234.5
  puts yen.to_r
  # => (2469/2)

  puts yen.round
  # => ¥1,235
  puts JapaneseYen[123].decimalize
  # => ¥123.0
  puts JapaneseYen[100/3].rationalize
  # => ¥33//1
end

puts """
#
# Vector's merits
#
"""
begin
  yen_vector = JapaneseYen.vectorize( 324, 1234, 456, 340, 120, 345 )

  # Bulk-calculating price including tax
  puts (yen_vector * 1.1).map(&:round)
  # => Vector[¥356, ¥1,357, ¥502, ¥374, ¥132, ¥380]

  yen_vector2 = JapaneseYen.vectorize( 128, 256, 512, 1024, 2048, 5096 )
  yen_vector3 = JapaneseYen.vectorize(-100, 200, -10,  210,   30,  416 )

  # Bulk-add each element
  puts yen_vector + yen_vector2 + yen_vector3
  # => Vector[¥352, ¥1,690, ¥958, ¥1,574, ¥2,198, ¥5,857]

  # extra: cumsumlative
  puts Vector.elements(yen_vector.size.times.map { |i| yen_vector[0..i].sum })
  # => Vector[¥324, ¥1,558, ¥2,014, ¥2,354, ¥2,474, ¥2,819]
end

