defmodule Mastery.Core.Quiz do
  @moduledoc """
  Fields:
  - title: the title of the quiz
  - mastery: the number of questions a user must get right to master a quiz
  - current_question: the current question being presented to the user
  - last_response: the last response given by the user
  - templates: the master list of templates, by category
  - used: the templates that we've used, this cycle, that have not yet been mastered
  - mastered: the templates that have been mastered
  - record: the number of correct answers in a row a user has given for each template
  """
  @type t :: %__MODULE__{
          title: atom() | binary() | nil,
          mastery: pos_integer(),
          templates: %{} | %{required(binary()) => [Mastery.Core.Template.t()]},
          used: [] | [Mastery.Core.Template.t()],
          current_question: Mastery.Core.Question.t() | nil,
          last_response: Mastery.Core.Response.t() | nil,
          record: %{} | %{required(atom()) => non_neg_integer()},
          mastered: [] | [Mastery.Core.Template.t()]
        }
  defstruct title: nil,
            mastery: 3,
            templates: %{},
            used: [],
            current_question: nil,
            last_response: nil,
            record: %{},
            mastered: []

  alias Mastery.Core.Response
  alias Mastery.Core.Question
  alias Mastery.Core.Template

  @spec new(fields :: Keyword.t()) :: t()
  def new(fields) do
    struct!(__MODULE__, fields)
  end

  @spec add_template(quiz :: t(), fields :: Keyword.t()) :: t()
  def add_template(quiz, fields) do
    template = Template.new(fields)

    templates =
      update_in(quiz.templates, [template.category], &add_to_list_or_nil(&1, template))

    %{quiz | templates: templates}
  end

  def advance(quiz) do
    quiz
    |> move_template(:mastered)
    |> reset_record()
    |> reset_used()
  end

  def answer_question(quiz, %Response{correct: true} = response) do
    new_quiz =
      quiz
      |> increment_record()
      |> save_response(response)

    maybe_advance(new_quiz, mastered?(new_quiz))
  end

  def answer_question(quiz, %Response{correct: false} = response) do
    quiz
    |> reset_record()
    |> save_response(response)
  end

  @spec select_question(quiz :: t()) :: nil | Mastery.Core.Question.t()
  def select_question(%__MODULE__{templates: t}) when map_size(t) == 0, do: nil

  def select_question(%__MODULE__{current_question: _cq} = quiz) do
    quiz
    |> pick_current_question()
    |> move_template(:used)
    |> reset_template_cycle()
  end

  defp add_to_list_or_nil(nil, template), do: [template]
  defp add_to_list_or_nil(templates, template), do: [template | templates]

  defp increment_record(%__MODULE__{current_question: question} = quiz) do
    new_record = Map.update(quiz.record, question.template.name, 1, &(&1 + 1))
    Map.put(quiz, :record, new_record)
  end

  defp mastered?(quiz) do
    score = Map.get(quiz.record, template(quiz).name, 0)
    score == quiz.mastery
  end

  defp maybe_advance(quiz, false = _mastered), do: quiz
  defp maybe_advance(quiz, true = _mastered), do: advance(quiz)

  defp move_template(quiz, field) do
    quiz
    |> remove_template_from_category()
    |> add_template_to_field(field)
  end

  defp pick_current_question(quiz) do
    Map.put(quiz, :current_question, select_random_question(quiz))
  end

  defp reset_record(%__MODULE__{current_question: question} = quiz) do
    Map.put(quiz, :record, Map.delete(quiz.record, question.template.name))
  end

  defp reset_used(%__MODULE__{current_question: question} = quiz) do
    Map.put(quiz, :used, List.delete(quiz.used, question.template))
  end

  defp save_response(quiz, response), do: Map.put(quiz, :last_response, response)

  defp select_random_question(quiz) do
    quiz.templates
    |> Enum.random()
    |> elem(1)
    |> Enum.random()
    |> Question.new()
  end

  defp template(quiz), do: quiz.current_question.template

  defp remove_template_from_category(quiz) do
    template = template(quiz)

    new_category_templates =
      quiz.templates
      |> Map.fetch!(template.category)
      |> List.delete(template)

    new_templates =
      case new_category_templates do
        [] -> Map.delete(quiz.templates, template.category)
        _ -> Map.put(quiz.templates, template.category, new_category_templates)
      end

    Map.put(quiz, :templates, new_templates)
  end

  defp add_template_to_field(quiz, field) do
    template = template(quiz)
    list = Map.get(quiz, field)

    Map.put(quiz, field, [template | list])
  end

  defp reset_template_cycle(%__MODULE__{templates: templates, used: used} = quiz)
       when map_size(templates) == 0 do
    %__MODULE__{quiz | templates: Enum.group_by(used, fn t -> t.category end), used: []}
  end

  defp reset_template_cycle(quiz), do: quiz
end
