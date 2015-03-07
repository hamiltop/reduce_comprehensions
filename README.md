ReduceComprehensions
====================

An implementation of reduce comprehensions ( see https://groups.google.com/forum/#!msg/elixir-lang-core/_veg3CFQkS4/ZEBzE_ksQncJ )

A reduce comprehension is similar to a for comprehension in that you can enumerate over multiple collections and provide filters. Rather than return a list of values, it returns a single value (similar in functionality to Enum.reduce). By providing the `acc:` options you can define the initial value of the accumulator along with the variables that will be bound.

Example:

```elixir
require ReduceComprehensions

result = ReduceComprehensions.reduce (
  for x <- [1,2,3], y <- [3,4,5], {n,m} = {2,3}, x !=2, acc: {sum, product} = {0,1} do
    {sum + x + y + n + m, product*x*y*n*m}
  end
)
```
