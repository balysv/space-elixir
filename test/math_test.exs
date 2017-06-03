defmodule PointTest do
  use ExUnit.Case, async: true
  doctest Point

  test "distance" do
    assert Point.distance({3, 3}, {3, 3}) == 0
    assert Point.distance({0, 1}, {0, 2}) == 1
  end

end

defmodule Vec2Test do
  use ExUnit.Case, async: true
  doctest Vec2

  test "magnitude" do
    assert Vec2.magnitude({3, 4}) == 5
    assert Vec2.magnitude({0, 1}) == 1
  end

  test "angle" do
    assert Float.ceil(Vec2.angle({1, 1}, {-1, -1}), 3) == Float.ceil(:math.pi, 3)
    assert Float.ceil(Vec2.angle({0, 1}, {1, 0}), 3) == Float.ceil(:math.pi / 2, 3)
  end

  test "unit" do
    assert Vec2.unit({0, 100}) == {0, 1}
  end

  test "minus" do
    assert Vec2.minus({1, 1}, {2, 3}) == {-1, -2}
  end

  test "plus" do
    assert Vec2.plus({1, 1}, {2, 3}) == {3, 4}
  end

  test "mult" do
    assert Vec2.mult({1, 2}, 3) == {3, 6}
  end

  test "dot" do
    assert Vec2.dot({1, 2}, {3, 4}) == 11
  end

end
