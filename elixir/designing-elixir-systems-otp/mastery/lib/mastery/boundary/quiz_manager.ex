defmodule Mastery.Boundary.QuizManager do
  alias Mastery.Core.Quiz
  use GenServer

  @spec build_quiz(manager :: module(), quiz_fields :: Keyword.t()) :: :ok
  def build_quiz(manager \\ __MODULE__, quiz_fields) do
    GenServer.call(manager, {:build_quiz, quiz_fields})
  end

  @spec add_template(
          manager :: module(),
          quiz_title :: atom() | binary(),
          template_fields :: Keyword.t()
        ) ::
          :ok
  def add_template(manager \\ __MODULE__, quiz_title, template_fields) do
    GenServer.call(manager, {:add_template, quiz_title, template_fields})
  end

  @spec lookup_quiz_by_title(manager :: module(), quiz_title :: atom() | binary()) :: Quiz.t()
  def lookup_quiz_by_title(manager \\ __MODULE__, quiz_title) do
    GenServer.call(manager, {:lookup_quiz_by_title, quiz_title})
  end

  def init(quizzes) when is_map(quizzes) do
    {:ok, quizzes}
  end

  def init(_), do: {:error, "Quizzes must be a map"}

  def handle_call({:build_quiz, quiz_fields}, _from, state) do
    quiz = Quiz.new(quiz_fields)
    new_quizzes = Map.put(state, quiz.title, quiz)
    {:reply, :ok, new_quizzes}
  end

  def handle_call({:add_template, quiz_title, template_fields}, _from, state) do
    new_quizzes =
      Map.update!(state, quiz_title, fn quiz ->
        Quiz.add_template(quiz, template_fields)
      end)

    {:reply, :ok, new_quizzes}
  end

  def handle_call({:lookup_quiz_by_title, quiz_title}, _from, state) do
    {:reply, state[quiz_title], state}
  end
end
