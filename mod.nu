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
            let color = if $shell.item.active {
                {fg: "green" attr: "bu"}
            } else {
                {fg: "default" attr: "d"}
            }
            $"(ansi -e $color)($shell.index)(ansi reset)"
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
                {fg: "green" attr: "bu"}
            } else if $overlay.index == (($overlays | length) - 1) {
                {fg: "default" attr: "d"}
            } else {
                {fg: "cyan"}
            }

            [
                (ansi -e $color)
                ($overlay.item | if ($env.NU_RIGHT_PROMPT_CONFIG?.compact? | default false) {
                    split chars | first
                } else {})
                (ansi reset)
            ] | str join ""
        } | str join ($env.NU_RIGHT_PROMPT_CONFIG?.overlay_separator? | default ' < ' | separator)
    }

    $env.NU_RIGHT_PROMPT_CONFIG.sections? | default ["shells", "overlays"] | each {|section|
        match $section {
            "shells" | "overlays" => {},
            _ => {
                error make --unspanned {
                    msg: $"(ansi red_bold)unknown section(ansi reset) ($'"($section)"' | nu-highlight) in ('$env.NU_RIGHT_PROMPT_CONFIG.sections' | nu-highlight)"
                }
            }
        }
    }

    let-env PROMPT_COMMAND_RIGHT = {
        $env.NU_RIGHT_PROMPT_CONFIG.sections? | default ["shells", "overlays"] | each {|section|
            match $section {
                "shells" => { get-shells },
                "overlays" => { get-overlays },
            }
        } | str join ($env.NU_RIGHT_PROMPT_CONFIG?.section_separator? | default ' | ' | separator)
    }
}
