# ruby README.rb
#
require_relative 'lib/japanese_yen'

puts """
# initializing
# ===
#   new or [],
#   generate_vector generates Vector[JapaneseYen...]
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
  puts JapaneseYen.generate_vector(10_000, 20_000, 30_000)
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
# Vector (or Matrix)
#
"""
begin
  yen_vector = JapaneseYen.generate_vector( 324, 1234, 456, 340, 120, 345 )

  # Bulk-calculating price including tax
  puts (yen_vector * 1.1).map(&:round)
  # => Vector[¥356, ¥1,357, ¥502, ¥374, ¥132, ¥380]

  yen_vector2 = JapaneseYen[128, 256, 512, 1024, 2048, 5096]
  yen_vector3 = JapaneseYen[-100, 200, -10,  210,   30,  416]

  # Bulk-add each element
  puts yen_vector + yen_vector2 + yen_vector3
  # => Vector[¥352, ¥1,690, ¥958, ¥1,574, ¥2,198, ¥5,857]

  # extra: cumsumlative
  puts Vector.elements(yen_vector.size.times.map { |i| yen_vector[0..i].sum })
  # => Vector[¥324, ¥1,558, ¥2,014, ¥2,354, ¥2,474, ¥2,819]

  yen_matrix = JapaneseYen.generate_matrix(
    [ 100,  200,  300,  400,  500],
    [ 600,  700,  800,  900, 1000],
    [1100, 1200, 1300, 1400, 1500],
    [1600, 1700, 1800, 1900, 2000],
    [2100, 2200, 2300, 2400, 2500],
  )
  puts yen_matrix
  # => Matrix[
  #   [¥100, ¥200, ¥300, ¥400, ¥500],
  #   [¥600, ¥700, ¥800, ¥900, ¥1,000],
  #   [¥1,100, ¥1,200, ¥1,300, ¥1,400, ¥1,500],
  #   [¥1,600, ¥1,700, ¥1,800, ¥1,900, ¥2,000],
  #   [¥2,100, ¥2,200, ¥2,300, ¥2,400, ¥2,500]
  # ]

  # Bulk-calculating price including tax
  puts (yen_matrix * 1.1).map(&:round)
  # => Matrix[
  #   [¥110, ¥220, ¥330, ¥440, ¥550],
  #   [¥660, ¥770, ¥880, ¥990, ¥1,100],
  #   [¥1,210, ¥1,320, ¥1,430, ¥1,540, ¥1,650],
  #   [¥1,760, ¥1,870, ¥1,980, ¥2,090, ¥2,200],
  #   [¥2,310, ¥2,420, ¥2,530, ¥2,640, ¥2,750]
  # ]

  yen_matrix2 = JapaneseYen[
    [ -500,  100, 1200,  568, 3498 ],
    [ 1001, 2012, 1349, 2345, 6734 ],
    [  300, -987, 1872,  321,   45 ],
    [  213, 3492,  234,  212, 1032 ],
    [ 8234,  123,  100, 1298,  345 ]
  ]

  # Bulk-add each element
  puts yen_matrix + yen_matrix2
  # => Matrix[
  #   [¥-400, ¥300, ¥1,500, ¥968, ¥3,998],
  #   [¥1,601, ¥2,712, ¥2,149, ¥3,245, ¥7,734],
  #   [¥1,400, ¥213, ¥3,172, ¥1,721, ¥1,545],
  #   [¥1,813, ¥5,192, ¥2,034, ¥2,112, ¥3,032],
  #   [¥10,334, ¥2,323, ¥2,400, ¥3,698, ¥2,845]
  # ]

  # 5x5 matrix * vector (as 1x5 matrix)
  puts yen_matrix * JapaneseYen[1.1, 1.2, 1.3, 1.4, 1.5]
  # => Vector[¥2,050.0, ¥5,300.0, ¥8,550.0, ¥11,800.0, ¥15,050.0]

  # Aggregate each row
  # 5x5 matrix * vector (as 1x5 matrix) (All multipliers should be 1)
  puts yen_matrix * Vector.elements(Array.new(yen_matrix.row_size, 1))
  # => Vector[¥1,500, ¥4,000, ¥6,500, ¥9,000, ¥11,500]

  # Aggregate each column
  # 5x5 matrix * vector (as 1x5 matrix) (All multipliers should be 1)
  puts yen_matrix.transpose * Vector.elements(Array.new(yen_matrix.row_size, 1))
  # => Vector[¥5,500, ¥6,000, ¥6,500, ¥7,000, ¥7,500]
  puts Vector.elements(yen_matrix.column_vectors.map(&:sum))
end

