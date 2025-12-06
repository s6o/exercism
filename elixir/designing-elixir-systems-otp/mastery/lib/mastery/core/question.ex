defmodule Mastery.Core.Question do
  @moduledoc """
  Fields:
  - asked: the question text for a user, e.g. "1 + 2"
  - substitutions: the values chosen for each substitution field in a template, e.g.
    template `<%= @left %>+<%= @right %>`, the substitutions: `%{:left=>1, :right=>2}`
  - template: the template that created the question
  """
  @type t :: %__MODULE__{
          asked: term(),
          substitutions: [{atom(), any()}],
          template: Mastery.Core.Template.t()
        }
  defstruct [
    :asked,
    :substitutions,
    :template
  ]

  alias Mastery.Core.Template

  @spec new(template :: Template.t()) :: t()
  def new(%Template{generators: generators} = template) do
    generators
    |> Enum.map(&build_substitution/1)
    |> evaluate(template)
  end

  @spec evaluate(substitutions :: [{atom(), any()}], template :: Template.t()) :: t()
  defp evaluate(substitutions, %Template{} = template) do
    %__MODULE__{
      asked: compile(template, substitutions),
      substitutions: substitutions,
      template: template
    }
  end

  @spec compile(Template.t(), [{atom(), any()}]) :: term()
  defp compile(%Template{compiled: compiled}, substitutions) do
    compiled
    |> Code.eval_quoted(assigns: substitutions)
    |> elem(0)
  end

  @spec build_substitution(item :: {atom(), Template.generator()}) :: {atom(), any()}
  defp build_substitution({name, choices_or_generator}) do
    {name, choose(choices_or_generator)}
  end

  defp choose(choices) when is_list(choices), do: Enum.random(choices)

  defp choose(generator) when is_function(generator), do: generator.()
end
