defmodule WordCount do
  def count(word) do
    word
    |> String.downcase()
    |> String.replace(~r/[^\w'-]/u, " ")
    |> String.split(~r/[\s_]/, trim: true)
    |> Enum.reduce(%{}, &increment_count/2)
  end

  defp increment_count(word, counts), do: Map.update(counts, word, 1, &(&1 + 1))
end
