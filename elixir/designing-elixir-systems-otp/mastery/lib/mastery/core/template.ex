defmodule Mastery.Core.Template do
  @moduledoc """
  Fields:
  - name: the name of the template
  - category: a grouping for questions of the same name
  - instructions: a string telling the user how to answer questions of this type
  - raw: the template code before compilation
  - compiled: the compiled version of the template for execution
  - generators: the generator for each substitution in a template; each generator
    is a list of elements or a function; generating a template substitution will
    either fire the function or pick a random item from the list
  - checker: given the substitution strings and an answer, the function returns
    `true` if the answer is correct
  """
  @type t :: %__MODULE__{
          name: atom(),
          category: atom(),
          instructions: binary(),
          raw: binary(),
          compiled: Macro.t(),
          generators: %{required(binary()) => [any()] | function()},
          checker: (substitutions(), binary() -> boolean())
        }
  @type substitutions :: %{required(binary()) => any()}

  defstruct [
    :name,
    :category,
    :instructions,
    :raw,
    :compiled,
    :generators,
    :checker
  ]
end
