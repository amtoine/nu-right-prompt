export-env {
    def separator [] {
        [
            (ansi default_dimmed)
            $in
            (ansi reset)
        ] | str join ""
    }

    def get-shells [] {
        shells | enumerate | each {|shell|
            let color = if $shell.item.active { "green" } else { "default_dimmed" }
            $"(ansi $color)($shell.index)(ansi reset)"
        } | str join " "
    }

    def get-overlays [] {
        let overlays = (
            overlay list
        )

        $overlays
        | reverse
        | enumerate
        | each {|overlay|
            let color = if $overlay.index == 0 {
                "green"
            } else if $overlay.index == (($overlays | length) - 1) {
                "default_dimmed"
            } else {
                "cyan"
            }

            [
                (ansi $color)
                ($overlay.item | if ($env.PROMPT_CONFIG?.compact? | default false) {
                    split chars | first
                } else {})
                (ansi reset)
            ] | str join ""
        } | str join ($env.PROMPT_CONFIG?.overlay_separator? | default ' < ' | separator)
    }

    let-env PROMPT_COMMAND_RIGHT = {
        (get-shells) ++ ($env.PROMPT_CONFIG?.section_separator? | default ' | ' | separator) ++ (get-overlays)
    }
}
