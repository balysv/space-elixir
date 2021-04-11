
defmodule Entity do
  @moduledoc """
  A space entity!
  name: name of the entity, ie Earth
  mass: mass of entity in kilograms
  radius: radius of entity in metres
  velocity: a 2d vector representing the movement direction and speed
  coords: a point in space where the entity is
  """
  @enforce_keys [:mass, :radius, :velocity, :coords]
  @type entity :: %Entity{mass: number, radius: number, velocity: Vec.vec2, coords: Point.point}
  defstruct [:mass, :radius, :velocity, :coords]

  @doc """
  Computes volume of an entity
  """
  @spec volume(%Entity{}) :: number
  def volume(e) do
    4/3 * :math.pi * :math.pow(e.radius, 3)
  end
end

defmodule Space do
  @moduledoc """
  Simulated space to calculate new entity positions and collisions after each time step
  """

  @doc """
  Proceeds one step in the simulation with list of entities as the state
  entities: entities in space to simulate
  G: gravitational constant to use, defaults to 1.0
  """
  @spec step(list(%Entity{}), number) :: list(%Entity{})
  def step(entities, g \\ 1.0) do
    entities
    |> applyGravity(g)
    |> applyMovement
    |> applyCollisions
  end

  @doc """
  Permutation that apply gravitational forces to all entities using given
  gravitational constant
  """
  @spec applyGravity(list(%Entity{}), number) :: list(%Entity{})
  def applyGravity(entities, g) do
    # Calculate the gravitational force between two entities
    gravityBetween = fn(e1, e2) ->
      strength = (g * e1.mass * e2.mass) / (:math.pow(Point.distance(e1.coords, e2.coords), 2))
      direction = Vec2.unit(Vec2.minus(e2.coords, e1.coords))
      Vec2.mult(direction, strength)
    end

    entities
    |> Enum.map(&Task.async(fn ->
      # Computer total gravity force from all other entities
      others = List.delete(entities, &1)
      totalGravityForce = Enum.reduce(others, Vec2.zero, fn(other, acc) ->
        Vec2.plus(acc, Vec2.div(gravityBetween.(&1, other), &1.mass))
      end)
      # Update velocity of the entity
      Map.put(&1, :velocity, Vec2.plus(&1.velocity, totalGravityForce))
    end))
    |> Enum.map(&Task.await(&1))
  end

  @doc """
  Permutation that applies positional changes by current velocities of entities
  """
  @spec applyMovement(list(%Entity{})) :: list(%Entity{})
  def applyMovement(entities) do
    entities
    |> Enum.map(&Task.async(fn ->
      Map.put(&1, :coords, Vec2.plus(&1.coords, &1.velocity))
    end))
    |> Enum.map(&Task.await(&1))
  end

  @doc """
  Permutation that checks if any two entities are colliding - distance
  between them is less than the sum of thei radiuses - and merges them
  into one in a fully-inelastic strategy (sum of masses and conservation
  of momentum)
  """
  @spec applyCollisions(list(%Entity{})) :: list(%Entity{})
  def applyCollisions(entities) do
    applyCollisions(entities, [])
  end

  @doc """
  Recursively searches and applies collision strategy to given entities
  and accumulates them in the result list
  """
  defp applyCollisions([entity | others], result) do
    # Checks if two entities collide with each other -
    # Distance between them is less than sum of their radiuses
    collides? = fn(e1, e2) ->
      Point.distance(e1.coords, e2.coords) < e1.radius + e2.radius
    end

    # Inellastically merges two entities into one, converving mass and momentum
    # Conservation of momentum: (m1 * v1 + m2 * v2) = (m1 + m2) * vf
    merge = fn(e1, e2) ->
      mass = e1.mass + e2.mass
      %Entity{
        mass: mass,
        radius: :math.pow((Entity.volume(e1) + Entity.volume(e2)) / (4/3 * :math.pi), 0.3333),
        velocity: Vec2.div(Vec2.plus(Vec2.mult(e1.velocity, e1.mass), Vec2.mult(e2.velocity, e2.mass)), mass),
        coords: Vec2.div(Vec2.plus(Vec2.mult(e1.coords, e1.mass), Vec2.mult(e2.coords, e2.mass)), mass)
      }
    end

    # Find if we have a collisions with the input entity
    hit = Enum.find(others, fn(e) -> collides?.(e, entity) end)

    # If there's no collision, adds entity to result list;
    # Otherwise, merges it with the hit entity
    {result, others} = if is_nil(hit) do
      {result ++ [entity], others}
    else
      {result ++ [merge.(entity, hit)], List.delete(others, hit)}
    end

    applyCollisions(others, result)
  end
  defp applyCollisions([], result) do result end

end
