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
          title: binary(),
          mastery: pos_integer(),
          templates: %{required(binary()) => [Mastery.Core.Template.t()]},
          used: [Mastery.Core.Template.t()],
          current_question: Mastery.Core.Question.t(),
          last_response: Mastery.Core.Response.t(),
          record: %{required(atom()) => non_neg_integer()},
          mastered: [Mastery.Core.Template.t()]
        }
  defstruct [
    :title,
    :mastery,
    :templates,
    :used,
    :current_question,
    :last_response,
    :record,
    :mastered
  ]
end
