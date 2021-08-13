module GradeSchool

type School = Map<int, string list>

let empty: School = Map.empty

let add (student: string) (grade: int) (school: School) : School =
    if school.ContainsKey grade then
        Map.add grade (school.[grade] @ [ student ]) school
    else
        Map.add grade [ student ] school

let roster (school: School) : string list =
    school
    |> Map.toSeq
    |> Seq.collect (fun (_, n) -> Seq.sort n)
    |> Seq.toList

let grade (number: int) (school: School) : string list =
    if school.ContainsKey number then
        school.[number] |> List.sort
    else
        []
