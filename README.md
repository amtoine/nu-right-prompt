# nu-right-prompt
A package to setup the right prompt of Nushell.

## supported sections
- the list of shells with the active one being hightlighted
- the list of overlays with the base one dimmed and the last one highlighted

## configure the prompt
```nu
let-env PROMPT_CONFIG = {
    compact: false            # whether to make the prompt compact or not
    section_separator: " | "  # the separator between sections
    overlay_separator: " < "  # the separator between overlays
}
```
