require ReduceComprehensions

result = ReduceComprehensions.reduce (
  for x <- [1,2,3], y <- [3,4,5], {n,m} = {2,3}, x !=2, acc: {sum, product} = {0,1} do
    {sum + x + y + n + m, product*x*y*n*m}
  end
)

IO.inspect result
