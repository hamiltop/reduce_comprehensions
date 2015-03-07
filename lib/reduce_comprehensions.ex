defmodule ReduceComprehensions do
  defmacro reduce({:for, meta, args}, block) do
    {acc, comprehension} = extract_acc(args)
    vars = extract_vars(comprehension)
    [acc: {:=, _, [acc_var, acc_start]}] = acc
    vars_tuple = {:{}, [], vars}
    for_comp = {:for, meta, comprehension ++ [[do: vars_tuple]]}
    [do: reduce_fun] = block
    quote do
      Enum.reduce(unquote(for_comp), unquote(acc_start), fn(unquote(vars_tuple),unquote(acc_var)) ->
        unquote(reduce_fun) 
      end)
    end
  end

  defp extract_acc(clauses) do
    acc = Enum.find(clauses, fn
        ([acc: _]) -> true
        _ -> false
      end)
    {acc, List.delete(clauses, acc)}
  end

  defp extract_vars(code) do
    {_, acc} = Macro.prewalk(code, [], fn
    ({_sym, _, nil} = el, acc) ->
      {el, [el | acc]}
    (el, acc) ->
      {el, acc}
    end)
    acc |> Enum.uniq
  end
end
