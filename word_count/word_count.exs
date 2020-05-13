defmodule WordCounter do
  def count(word) do
    words = String.split(word, ~r{[^\w']}, trim: true)
    result = %{}
    Enum.reduce(words, result, fn word, counts ->
      Map.update(counts, word, 1, &(&1 + 1))
    end)
  end
end

IO.inspect(WordCounter.count("this is great, isn't this?"))
