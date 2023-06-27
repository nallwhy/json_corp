defmodule JsonCorp.Core.Cldr do
  use Cldr,
    locales: ["en", "ko"],
    default_locale: "en",
    providers: []
end
