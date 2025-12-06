defmodule Mastery.Core.Response do
  @moduledoc """
  Fields:
  - quiz_title: title field from the quiz
  - template_name: name field identifying the template
  - to: the question being answered, as in "this is a response to the asked question"
  - email: the email address of the user answering the question
  - answer: the answer provided by the user
  - correct: whether the given answer was correct
  - timestamp: the date&time of when the answer was provided
  """
  @type t :: %__MODULE__{
          quiz_title: binary(),
          template_name: atom(),
          to: binary(),
          email: binary(),
          answer: binary(),
          correct: boolean(),
          timestamp: DateTime.t()
        }
  defstruct [
    :quiz_title,
    :template_name,
    :to,
    :email,
    :answer,
    :correct,
    :timestamp
  ]

  @spec new(quiz :: Mastery.Core.Quiz.t(), email :: binary(), answer :: binary()) :: t()
  def new(quiz, email, answer) do
    question = quiz.current_question
    template = question.template

    %__MODULE__{
      quiz_title: quiz.title,
      template_name: template.name,
      to: question.asked,
      email: email,
      answer: answer,
      correct: template.checker.(question.substitutions, answer),
      timestamp: DateTime.utc_now()
    }
  end
end
