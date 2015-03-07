defmodule ReduceComprehensions do
  defmacro reduce({:for, meta, args}) do
    {acc, block, comprehension} = extract_acc(args)
    vars = extract_vars(comprehension)
    [acc: {:=, _, [acc_var, acc_start]}] = acc
    vars_tuple = {:{}, [], vars}
    for_comp = {:for, meta, things ++ [[do: b]]}
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
    block = Enum.find(clauses, fn
        ([do: _]) -> true
        _ -> false
      end)
    {acc, block, List.delete(clauses, acc) |> List.delete(block)}
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
