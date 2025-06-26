defmodule JsonCorp.Core.Cldr do
  use Cldr,
    locales: [:en, :ko, :ja],
    default_locale: :en,
    providers: [Cldr.Number, Cldr.Calendar, Cldr.DateTime, Cldr.LocaleDisplay]

  def ensure_supported_language(language) do
    case language in known_languages() do
      true -> language
      false -> default_language()
    end
  end

  def known_languages() do
    __MODULE__.known_locale_names()
    |> Enum.map(&__MODULE__.Locale.new!/1)
    |> Enum.map(& &1.language)
  end

  defp default_language() do
    __MODULE__.default_locale().language
  end
end
