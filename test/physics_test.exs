defmodule SpaceTest do
  use ExUnit.Case, async: true
  doctest Space

  @realG 6.674 * :math.pow(10, -11)

  @earth %Entity{
    mass: 5.972 * :math.pow(10, 24),
    radius: 6.371 * :math.pow(10, 6),
    velocity: Vec2.zero,
    coords: Vec2.zero
  }

  @sun %Entity{
    mass: 2.0 * :math.pow(10, 30),
    radius: 6.957 * :math.pow(10, 8),
    velocity: Vec2.zero,
    coords: {1000000, 1000000}
  }

  @apple %Entity{
    mass: 0.2,
    radius: 0.05,
    velocity: Vec2.zero,
    coords: {0, @earth.radius}
  }

  test "volume" do
    assert Entity.volume(@earth) - 1.08321 * :math.pow(10, 21) < 1
  end

  test "gravity on Earth" do
    [earth, apple] = Space.applyGravity([@earth, @apple], @realG)
    # Apple accelerates at 9.8m/s^2 downwards
    assert Float.round(elem(apple.velocity, 1), 1) == -9.8
    # Earth is not affected by the gravity of an apple
    assert Float.round(elem(earth.velocity, 1), 1) == 0
  end

  test "movement" do
    entity = Map.put(@apple, :velocity, {-100.0, 500.0})
    [entity2] = Space.applyMovement([entity])
    assert entity2.coords == {-100.0, elem(entity.coords, 1) + 500}
  end

  test "Earth collides into the Sun" do
    result = Space.applyCollisions([@earth, @sun])
    assert length(result) == 1

    # TODO: fully test the math
    [sunV2 | _] = result
    assert sunV2.mass > @sun.mass
  end

  def spaceStep(space, times) do
    if times <= 0 do
      IO.puts "Simulation complete"
      space
    else
      spaceStep(Space.step(space, 1), times - 1)
    end
  end

  def randomEntity() do
    %Entity{
      mass: :math.pow(10, 24) + :rand.uniform * :math.pow(10, 20),
      radius: :math.pow(10, 3) + :rand.uniform * :math.pow(10, 4),
      velocity: {
        -:math.pow(10, 3) + :rand.uniform * :math.pow(10, 6),
        -:math.pow(10, 3) + :rand.uniform * :math.pow(10, 6)
      },
      coords: {
        -:math.pow(10, 30) + :rand.uniform * :math.pow(10, 60),
        -:math.pow(10, 30) + :rand.uniform * :math.pow(10, 60)
      }
    }
  end

  test "Run of a planet system" do
    entities = Enum.map(1..500, fn _ -> randomEntity() end)
    spaceStep(entities, 100)
  end
end
