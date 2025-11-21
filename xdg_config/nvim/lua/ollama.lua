return {
    memory = {
        -- WIP
        default = {
            description = "Collection of common files for all projects",
            files = {
                { path = "/tmp/work.md" },
            },
        },
    },
    adapters = {
        ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
                env = {
                    url = "http://10.10.1.10:11434",
                },
                schema = {
                    model = {
                        default = "qwen3:4b-instruct-2507-q4_K_M",
                    },
                    -- From lmstudio
                    temperature = {
                        -- How much randomness to introduce. 0 will yield the same result every time, while higher values will increase creativity and variance
                        default = 0.8,
                    },
                    num_ctx = {
                        default = 16384,
                    },
                    think = {
                        default = false,
                    },
                    top_k = {
                        -- Limits the next token to one of the top-k most probable tokens. Acts similarly to temperature
                        default = 40,
                    },
                    top_p = {
                        -- Minimum cumulative probability for the possible next tokens. Acts similarly to temperature
                        default = 0.95,
                    },
                    repeat_penalty = {
                        -- How much to discourage repeating the same token
                        default = 1.1,
                    },
                    min_p = {
                        -- Minimum base probability for a token to be selected for output
                        default = 0.05,
                    },
                    keep_alive = {
                        default = "5m",
                    },
                },
            })
        end
    },

    strategies = {
        chat = {
            opts = {
                system_prompt = "go straight to the point, be concise and produce the minimal correct code.",
            },
            adapter = "ollama",
        },
        inline = {
            adapter = "ollama",
        },
    }
}
