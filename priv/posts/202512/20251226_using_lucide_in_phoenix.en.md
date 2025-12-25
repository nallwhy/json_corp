%{
title: "Using Lucide Icons in Phoenix",
description: "When Heroicons aren't enough",
category: :dev,
tags: ["Elixir", "Phoenix", "Lucide"]
}

---

Phoenix currently ships with [Heroicons]+(https://heroicons.com/) wired into the `CoreComponents.icon` component by default, like this.

```elixir
defmodule MyApp.CoreComponents do
  @doc """
  Renders a [Heroicon](https://heroicons.com).

  ...

  ## Examples

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end
end
```

Heroicons is an icon library built by Tailwind Labs, so expectations were high, but it still lacks many icons and hasn't been updated since v2.2.0 on 2024-11-18, so it looks effectively abandoned.

To make up for that, there are projects like [Sidekickicons]+(https://sidekickicons.com/) that add extra icons in the heroicons style, but it seems hard for them to stay active.

So I set things up to use [Lucide]+(https://lucide.dev/) in Phoenix, which has lots of icons and is continuously updated.

<figure>
  <img src="/images/blog/20251226_lucide.png" alt="Lucide">
  <figcaption>As of v0.562.0, there are a whopping 1,666 icons.</figcaption>
</figure>

## Setting up Lucide in Phoenix

### Add mix deps

Just as Heroicons is configured to fetch only the `optimized` folder from the tailwindlabs/heroicons GitHub repository, add Lucide to `deps/0` in `mix.exs` so only the `icons` folder is fetched.

```elixir
defmodule MyApp.MixProject do
  ...

  defp deps do
    [
      ...,
      {
        :lucide,
        github: "lucide-icons/lucide",
        tag: "0.562.0",
        sparse: "icons",
        app: false,
        compile: false,
        depth: 1
      }
    ]
  end
end
```

### Write `lucide.js`

Use the `heroicons.js` that Phoenix ships with as a reference and create `lucide.js` under `./assets/vendor/`.

Heroicons is more complex because it creates Tailwind CSS dynamic utility classes for the four types (outline, solid, mini, micro), but Lucide is simpler. I also added a `mask-size` setting to match Lucide.

```js
const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = plugin(function ({ matchComponents, theme }) {
  let iconsDir = path.join(__dirname, "../../deps/lucide/icons")
  let values = {}

  fs.readdirSync(iconsDir).forEach(file => {
    if (file.endsWith(".svg")) {
      let name = path.basename(file, ".svg")
      values[name] = { name, fullPath: path.join(iconsDir, file) }
    }
  })

  matchComponents({
    "lucide": ({ name, fullPath }) => {
      let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
      content = encodeURIComponent(content)
      let size = theme("spacing.6")

      return {
        [`--lucide-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
        "-webkit-mask": `var(--lucide-${name})`,
        "mask": `var(--lucide-${name})`,
        "mask-size": "contain",
        "mask-repeat": "no-repeat",
        "background-color": "currentColor",
        "vertical-align": "middle",
        "display": "inline-block",
        "width": size,
        "height": size
      }
    }
  }, { values })
})
```

### Update `app.css`

To register the Lucide plugin with Tailwind CSS, add the following to `app.css`.

```css
@plugin "../vendor/lucide";
```

### Add the "lucide" prefix to the `CoreComponents.icon` component

The existing `CoreComponents.icon` component only allows the "hero" prefix.

Add support for the "lucide" prefix like this.

```elixir
defmodule MyApp.CoreComponents do
  ...

  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  # Allow the lucide prefix
  def icon(%{name: "lucide-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end
end
```

## Using Lucide

You can now use Lucide icons as simply as the existing Heroicons.

```html
<.icon name="lucide-newspaper" />
```

<figure>
  <img src="/images/blog/20251226_lucide_in_action.png" class="border border-primary" alt="Lucide in action">
  <figcaption>Applied directly to the header.</figcaption>
</figure>

Now you can use the massive Lucide icon set without running out. Since the icon library keeps growing quickly, update the Lucide version periodically as needed.
