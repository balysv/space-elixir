defmodule Point do
  @moduledoc """
  Provide 2d point related operations
  """
  @typedoc """
  A 2-dimentional point
  """
  @type point :: {number, number}

  @doc """
  Calculates Euclidean distance between two points
  """
  @spec distance(point, point) :: number
  def distance({x1, y1}, {x2, y2}) do
    :math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2))
  end
end


defmodule Vec2 do
  @moduledoc """
  Provides 2d vector related operations
  """

  @typedoc """
  A 2-dimentional vector
  """
  @type vec2 :: {number, number}

  @doc """
  Returns a zero 2d vector
  """
  def zero() do {0, 0} end

  @doc """
  Calculates the unit vector
  """
  @spec unit(vec2) :: vec2
  def unit({x, y}) do
    m = magnitude({x, y})
    if m == 0, do: {0, 0}, else: {x / m, y / m}
  end

  @doc """
  Calculates magnitude of a vector.
  Takes the square root of the sum of squared map values
  """
  @spec magnitude(vec2) :: number
  def magnitude({x, y}) do
    :math.sqrt(:math.pow(x, 2.0) + :math.pow(y, 2.0))
  end

  @doc """
  Calculate the angle between two 2d vectors in radians
  """
  @spec angle(vec2, vec2) :: number
  def angle({x1, y1}, {x2, y2}) do
    r = x1 * x2 + y1 * y2
    m = magnitude({x1, y1}) * magnitude({x2, y2})
    :math.acos(r / m)
  end

  @doc """
  Dot product of two 2d vectors
  """
  @spec dot(vec2,  vec2) :: number
  def dot({x1, y1}, {x2, y2}) do
    x1 * x2 + y1 * y2
  end

  @doc """
  Subtracts two 2d vectors
  """
  @spec minus(vec2, vec2) :: vec2
  def minus({x1, y1}, {x2, y2}) do
    {x1 - x2, y1 - y2}
  end

  @doc """
  Sums two 2d vectors
  """
  @spec plus(vec2, vec2) :: vec2
  def plus({x1, y1}, {x2, y2}) do
    {x1 + x2, y1 + y2}
  end

  @doc """
  Multiplies a 2d vector by a scalar
  """
  @spec mult(vec2, number) :: vec2
  def mult({x, y}, k) do
    {x * k, y * k}
  end

  @doc """
  Divides a 2d vector by a scalar
  """
  @spec div(vec2, number) :: vec2
  def div({x, y}, k) do
    {x / k, y / k}
  end


end
