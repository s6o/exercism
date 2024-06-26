# Wine Cellar

Welcome to Wine Cellar on Exercism's Elixir Track.
If you need help running the tests or submitting your code, check out `HELP.md`.
If you get stuck on the exercise, check out `HINTS.md`, but try and solve it
without using those first :)

## Introduction

## Keyword Lists

Keyword lists are a key-value data structure.

```elixir
[month: "April", year: 2018]
```

Keyword lists are lists of `{key, value}` [tuples][exercism-tuples], and can
also be written as such, but the shorter syntax is more widely used.

```elixir
[month: "April"] == [{:month, "April"}]
# => true
```

Keys in a keyword list must be [atoms][exercism-atoms], but the values can be
anything. Each key can be used more than once. The key-value pairs in a keyword
list are ordered.

You can work with keyword lists using the same approaches as for lists, or you
can use the `Keyword` module.

[exercism-tuples]: https://exercism.org/tracks/elixir/concepts/tuples
[exercism-atoms]: https://exercism.org/tracks/elixir/concepts/atoms

## Instructions

You are the manager of a fancy restaurant that has a sizable wine cellar. A lot
of your customers are demanding wine enthusiasts. Finding the right bottle of
wine for a particular customer is not an easy task.

As a tech-savvy restaurant owner, you decided to speed up the wine selection
process by writing an app that will let guests filter your wines by their
preferences.

## 1. Explain wine colors

On the welcome screen of your app, you want to display a short explanation of
each wine color.

Implement the `WineCellar.explain_colors/0` function. It takes no arguments and
returns a keyword list with wine colors as keys and explanations as values.

| Color    | Explanation                                                                |
| -------- | -------------------------------------------------------------------------- |
| `:white` | Fermented without skin contact.                                            |
| `:red`   | Fermented with skin contact using dark-colored grapes.                     |
| `:rose`  | Fermented with some skin contact, but not enough to qualify as a red wine. |

## 2. Get all wines of a given color

A bottle of wine is represented as a 3-tuple of grape variety, year, and country
of origin. The wines are stored by wine color in a keyword list.

```elixir
[
  white: {"Chardonnay", 2015, "Italy"},
  white: {"Pinot grigio", 2017, "Germany"},
  red: {"Pinot noir", 2016, "France"},
  rose: {"Dornfelder", 2018, "Germany"}
]
```

Implement the `WineCellar.filter/3` function. It should take a keyword list of
wines, a color atom and a keyword list of options, with a default value of `[]`.
The function should return a list of wines of a given color.

```elixir
WineCellar.filter(
  [
    white: {"Chardonnay", 2015, "Italy"},
    white: {"Pinot grigio", 2017, "Germany"},
    red: {"Pinot noir", 2016, "France"},
    rose: {"Dornfelder", 2018, "Germany"}
  ],
  :white
)
# => [
#      {"Chardonnay", 2015, "Italy"},
#      {"Pinot grigio", 2017, "Germany"}
#    ]
```

## 3. Get all wines of a given color bottled in a given year

Extend the `WineCellar.filter/3` function. When given a `:year` option, thefunction should return a list of wines of a given color from a given year.

Use the already-implemented `WineCellar.filter_by_year/2` function. It takes a list of wines and a year as arguments and returns a list of wines from a given year.

```elixir
WineCellar.filter(
  [
    white: {"Chardonnay", 2015, "Italy"},
    white: {"Pinot grigio", 2017, "Germany"},
    red: {"Pinot noir", 2016, "France"},
    rose: {"Dornfelder", 2018, "Germany"}
  ],
  :white,
  year: 2015
)
# => [
#      {"Chardonnay", 2015, "Italy"}
#    ]
```

## 4. Get all wines of a given color bottled in a given country

Extend the `WineCellar.filter/3` function. When given a `:country` option, the
function should return a list of wines of a given color from a given country.

Use the already-implemented `WineCellar.filter_by_country/2` function. It takes
a list of wines and a country as arguments and returns a list of wines from a
given country.

Make sure that the function works when given both the `:year` and the `:country`
option, in any order.

```elixir
WineCellar.filter(
  [
    white: {"Chardonnay", 2015, "Italy"},
    white: {"Pinot grigio", 2017, "Germany"},
    red: {"Pinot noir", 2016, "France"},
    rose: {"Dornfelder", 2018, "Germany"}
  ],
  :white,
  year: 2015,
  country: "Germany"
)
# => []
```

## Source

### Created by

- @angelikatyborska

### Contributed to by

- @neenjaw
