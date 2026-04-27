#!/usr/bin/env bash
# Module: skills
# Install AI agent skills by symlinking to Claude Code and OpenCode skill directories.

skills_setup() {
    log_info "=== AI Skills setup ==="

    local skills_source="${DOTFILES_DIR}/skills"

    if [[ ! -d "$skills_source" ]]; then
        log_info "No skills directory found. Skipping."
        return
    fi

    # Claude Code skills directory
    local claude_skills_dir="${HOME}/.claude/skills"
    # OpenCode skills directory
    local opencode_skills_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/opencode/skills"

    for skill_dir in "${skills_source}"/*/; do
        [[ -d "$skill_dir" ]] || continue
        local skill_name
        skill_name=$(basename "$skill_dir")

        # Install to Claude Code
        if [[ -d "${HOME}/.claude" ]]; then
            mkdir -p "$claude_skills_dir"
            if [[ ! -e "${claude_skills_dir}/${skill_name}" ]]; then
                ln -sv "$skill_dir" "${claude_skills_dir}/${skill_name}"
                log_info "Installed skill '${skill_name}' to Claude Code."
            else
                log_info "Skill '${skill_name}' already installed in Claude Code."
            fi
        fi

        # Install to OpenCode
        if is_executable "opencode"; then
            mkdir -p "$opencode_skills_dir"
            if [[ ! -e "${opencode_skills_dir}/${skill_name}" ]]; then
                ln -sv "$skill_dir" "${opencode_skills_dir}/${skill_name}"
                log_info "Installed skill '${skill_name}' to OpenCode."
            else
                log_info "Skill '${skill_name}' already installed in OpenCode."
            fi
        fi
    done
}
