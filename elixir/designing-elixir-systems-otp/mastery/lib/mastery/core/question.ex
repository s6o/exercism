defmodule Mastery.Core.Question do
  @moduledoc """
  Fields:
  - asked: the question text for a user, e.g. "1 + 2"
  - substitutions: the values chosen for each substitution field in a template, e.g.
    template `<%=left%>+<%=right%>`, the substitutions: `%{"left"=>1, "right"=>2}`
  - template: the template that created the question
  """
  @type t :: %__MODULE__{
          asked: binary(),
          substitutions: Mastery.Core.Template.substitutions(),
          template: Mastery.Core.Template.t()
        }
  defstruct [
    :asked,
    :substitutions,
    :template
  ]
end
