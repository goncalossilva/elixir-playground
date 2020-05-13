defmodule RobotSimulator do
  # defstruct direction: :north, position: {0, 0}
  defstruct [:direction, :position]

  defguardp is_position(position)
            when is_tuple(position) and
                   tuple_size(position) == 2 and
                   is_number(elem(position, 0)) and
                   is_number(elem(position, 1))

  @directions [:north, :east, :south, :west]
  @error_direction {:error, "invalid direction"}
  @error_position {:error, "invalid position"}
  @error_instruction {:error, "invalid instruction"}

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, position) when direction in @directions and is_position(position) do
    %RobotSimulator{direction: direction, position: position}
  end

  def create(direction, _position) when direction in @directions, do: @error_position

  def create(_direction, _position), do: @error_direction

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: %RobotSimulator{}, instructions :: String.t()) :: any

  def simulate(robot, "L" <> actions), do: simulate(turn_left(robot), actions)
  def simulate(robot, "R" <> actions), do: simulate(turn_right(robot), actions)
  def simulate(robot, "A" <> actions), do: simulate(advance(robot), actions)
  def simulate(robot, ""), do: robot
  def simulate(_, _), do: @error_instruction

  defp turn_left(r = %{direction: :north}), do: %{r | direction: :west}
  defp turn_left(r = %{direction: :east}), do: %{r | direction: :north}
  defp turn_left(r = %{direction: :south}), do: %{r | direction: :east}
  defp turn_left(r = %{direction: :west}), do: %{r | direction: :south}

  defp turn_right(r = %{direction: :north}), do: %{r | direction: :east}
  defp turn_right(r = %{direction: :east}), do: %{r | direction: :south}
  defp turn_right(r = %{direction: :south}), do: %{r | direction: :west}
  defp turn_right(r = %{direction: :west}), do: %{r | direction: :north}

  defp advance(r = %{direction: :north, position: {x, y}}), do: %{r | position: {x, y + 1}}
  defp advance(r = %{direction: :east, position: {x, y}}), do: %{r | position: {x + 1, y}}
  defp advance(r = %{direction: :south, position: {x, y}}), do: %{r | position: {x, y - 1}}
  defp advance(r = %{direction: :west, position: {x, y}}), do: %{r | position: {x - 1, y}}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`.
  """
  @spec direction(robot :: any) :: atom
  def direction(robot), do: robot.direction

  @doc """
  Return the robot's position.

  Valid positions are integer tuples.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot), do: robot.position
end
