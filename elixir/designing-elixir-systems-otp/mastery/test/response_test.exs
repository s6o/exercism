defmodule ResponseTest do
  use ExUnit.Case
  use QuizBuilders

  defp quiz() do
    fields = template_fields(name: :wtf, generators: %{left: [1], right: [2]})

    build_quiz()
    |> Quiz.add_template(fields)
    |> Quiz.select_question()
  end

  defp response(answer), do: Response.new(quiz(), "mathy@example.com", answer)

  defp correct(context), do: {:ok, Map.put(context, :correct, response("3"))}

  defp incorrect(context), do: {:ok, Map.put(context, :incorrect, response("2"))}

  describe "a correct response and an incorrect response" do
    setup [:correct, :incorrect]

    test "building response checks answers", %{correct: resp_a, incorrect: resp_b} do
      assert resp_a.correct
      refute resp_b.correct
    end

    test "a timestamp is added at build time", %{correct: response} do
      assert %DateTime{} = response.timestamp
      assert DateTime.compare(response.timestamp, DateTime.utc_now()) == :lt
    end
  end
end
