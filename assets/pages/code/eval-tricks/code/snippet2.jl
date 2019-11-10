# This file was generated, do not modify it. # hide
#hideall
names = (:Bob, :Alice, :Maria, :Arvind, :Jose, :Minjie)
numbers = (1525, 5134, 4214, 9019, 8918, 5757)
println("@@gen-table ")
println("Name | Number")
println("--- | ---")
println.("$name | $number" for (name, number) in zip(names, numbers))
println("@@")