[
  import_deps: [:ecto, :phoenix],
  line_length: 120,
  inputs: ["*.{ex,exs}", "{config,lib,priv,test}/**/*.{ex,exs}"],
  locals_without_parens: [resolve: :*, arg: :*, puts: :*, defenum: :*, attributes: :*, meta: :*, assert_raise: :*]
]
