return function(n)
  local sounds = ""

  if n % 3 == 0 then
    sounds = sounds .. "Pling"
  end
  if n % 5 == 0 then
    sounds = sounds .. "Plang"
  end
  if n % 7 == 0 then
    sounds = sounds .. "Plong"
  end
  if sounds == "" then
    sounds = tostring(n)
  end

  return sounds
end
