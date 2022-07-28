# Functor

Implement Functor's `fmap` in Elixir via protocols.
Based on this [article](https://blog.appsignal.com/2022/07/26/how-to-write-a-functor-in-elixir.html)

But, the `fmap` implementation for Elixir `Map` is similar to [Elm's](https://package.elm-lang.org/packages/elm/core/latest/Dict#map)
where the transformation function must handle both arguments: key and value,
instead of just value, which actually breaks the structure - something the `fmap`
is not supposed to do.

The `fmap` implementation for `Tuple` includes an additional option/feature where
in case the tuple does not start with `:ok` nor `:error`, the transformation
function is applied to all tuple elements.
