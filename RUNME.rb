# irb RUNME.rb
require_relative 'lib/japanese_yen'

puts """
#
# initializing
# ===
#   new or [],
#   generate_vector generates Vector[JapaneseYen...]
#
"""
JapaneseYen.new(1_000_000)

JapaneseYen[345_345]

# generate Vector
JapaneseYen.generate_vector(10_000, 20_000, 30_000)

JapaneseYen[10.0]

JapaneseYen[Rational(234, 3)]

# Cannot initialize from except Numeric objects.
begin
  JapaneseYen.new("3000")
rescue => e
  e
end

puts """
#
# atributes
# ===
#   value, amount
#   * both are same.
#
"""
yen = JapaneseYen[345_345]

yen.value
yen.amount # Alias of value

puts """
#
# print
# ===
#   to_s and inspect
#
"""
yen = JapaneseYen[38_000]

puts yen
p yen

puts """
#
# Artihmetic operators
# ===
#   +, -, *, /, **, %, divmod
#   It makes always JapaneseYen object by #coerce.
#
"""
JapaneseYen[1_000_000] + 500_000
JapaneseYen[1_000_000] - 300_000
JapaneseYen[300] * 10
JapaneseYen[400_000] / 4.0
JapaneseYen[10_000] ** 2
JapaneseYen[12_345] % 1_000
JapaneseYen[2300].divmod(3)

(1000 + JapaneseYen[200_000] / 2.5 - 2) * 2

begin
  "Cannot add" + JapaneseYen[2_000]
rescue => e
  e
end

puts """
#
# Comparing operators
#   ==, <, >, <=, >=, <=>
#
"""
JapaneseYen[10_000] == JapaneseYen[10_000]
JapaneseYen[10_000] > JapaneseYen[10_000]
JapaneseYen[10_000] >= JapaneseYen[10_000]
JapaneseYen[10_000] < JapaneseYen[10_000]
JapaneseYen[10_000] <= JapaneseYen[10_000]
JapaneseYen[400] <=> JapaneseYen[500]
JapaneseYen[500] <=> JapaneseYen[500]
JapaneseYen[600] <=> JapaneseYen[500]

puts """
#
# Numeric value converting
# ===
#   round, to_i, to_f, to_r
#
"""
yen = JapaneseYen.new(12345) * 0.1

yen.to_i
yen.to_f
yen.to_r

yen.round
JapaneseYen[123].decimalize
JapaneseYen[100/3].rationalize

puts """
#
# Vector (or Matrix)
#
"""
yen_vector = JapaneseYen.generate_vector( 324, 1234, 456, 340, 120, 345 )

# Bulk-calculating price including tax
(yen_vector * 1.1).map(&:round)

yen_vector2 = JapaneseYen[128, 256, 512, 1024, 2048, 5096]
yen_vector3 = JapaneseYen[-100, 200, -10,  210,   30,  416]

# Bulk-add each element
yen_vector + yen_vector2 + yen_vector3

# extra: cumsumlative
Vector.elements(yen_vector.size.times.map { |i| yen_vector[0..i].sum })

yen_matrix = JapaneseYen.generate_matrix(
  [ 100,  200,  300,  400,  500],
  [ 600,  700,  800,  900, 1000],
  [1100, 1200, 1300, 1400, 1500],
  [1600, 1700, 1800, 1900, 2000],
  [2100, 2200, 2300, 2400, 2500],
)

# Bulk-calculating price including tax
(yen_matrix * 1.1).map(&:round)

yen_matrix2 = JapaneseYen[
  [ -500,  100, 1200,  568, 3498 ],
  [ 1001, 2012, 1349, 2345, 6734 ],
  [  300, -987, 1872,  321,   45 ],
  [  213, 3492,  234,  212, 1032 ],
  [ 8234,  123,  100, 1298,  345 ],
]

# Bulk-add each element
yen_matrix + yen_matrix2

# 5x5 matrix * vector (as 1x5 matrix)
yen_matrix * JapaneseYen[1.1, 1.2, 1.3, 1.4, 1.5]

# Aggregate each row
# 5x5 matrix * vector (as 1x5 matrix) (All multipliers should be 1)
yen_matrix * Vector.elements(Array.new(yen_matrix.row_size, 1))

# Aggregate each column
# 5x5 matrix * vector (as 1x5 matrix) (All multipliers should be 1)
yen_matrix.transpose * Vector.elements(Array.new(yen_matrix.row_size, 1))

Vector.elements(yen_matrix.column_vectors.map(&:sum))
