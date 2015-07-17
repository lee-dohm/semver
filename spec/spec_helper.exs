ESpec.start

ESpec.configure fn(config) ->
  config.before fn ->
  end

  config.finally fn(__) ->
  end
end
