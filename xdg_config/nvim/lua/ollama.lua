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
        http = {
            ollama = function()
                return require("codecompanion.adapters").extend("ollama", {
                    env = {
                        -- url = "http://10.10.1.10:11434",
                        url = "http://127.0.0.1:11434",
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
        }
    },

    strategies = {
        chat = {
            opts = {
                system_prompt = "go straight to the point, be concise and produce the minimal correct code.",
                approvals = {
                    -- Ensure all tools require approval
                    all = true,
                },
            },
            adapter = "ollama",
        },
        inline = {
            adapter = "ollama",
        },
    },

    extensions = {
        history = {
            enabled = true,
            opts = {
                -- Keymap to open history from chat buffer (default: gh)
                keymap = "gh",
                -- Keymap to save the current chat manually (when auto_save is disabled)
                save_chat_keymap = "sc",
                -- Save all chats by default (disable to save only manually using 'sc')
                auto_save = true,
                -- Number of days after which chats are automatically deleted (0 to disable)
                expiration_days = 0,
                -- Picker interface (auto resolved to a valid picker)
                picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default")
                ---Optional filter function to control which chats are shown when browsing
                chat_filter = nil,    -- function(chat_data) return boolean end
                -- Customize picker keymaps (optional)
                picker_keymaps = {
                    rename = { n = "r", i = "<M-r>" },
                    delete = { n = "d", i = "<M-d>" },
                    duplicate = { n = "<C-y>", i = "<C-y>" },
                },
                ---Automatically generate titles for new chats
                auto_generate_title = true,
                title_generation_opts = {
                    ---Adapter for generating titles (defaults to current chat adapter)
                    adapter = nil,               -- "copilot"
                    ---Model for generating titles (defaults to current chat model)
                    model = nil,                 -- "gpt-4o"
                    ---Number of user prompts after which to refresh the title (0 to disable)
                    refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
                    ---Maximum number of times to refresh the title (default: 3)
                    max_refreshes = 3,
                    format_title = function(original_title)
                        -- this can be a custom function that applies some custom
                        -- formatting to the title.
                        return original_title
                    end
                },
                ---On exiting and entering neovim, loads the last chat on opening chat
                continue_last_chat = false,
                ---When chat is cleared with `gx` delete the chat from history
                delete_on_clearing_chat = false,
                ---Directory path to save the chats
                --dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
                dir_to_save = vim.fn.getenv("HOME") .. "/.cache//codecompanion-history",
                ---Enable detailed logging for history extension
                enable_logging = false,

                -- Summary system
                summary = {
                    -- Keymap to generate summary for current chat (default: "gcs")
                    create_summary_keymap = "gcs",
                    -- Keymap to browse summaries (default: "gbs")
                    browse_summaries_keymap = "gbs",

                    generation_opts = {
                        adapter = nil,               -- defaults to current chat adapter
                        model = nil,                 -- defaults to current chat model
                        context_size = 90000,        -- max tokens that the model supports
                        include_references = true,   -- include slash command content
                        include_tool_outputs = true, -- include tool execution results
                        system_prompt = nil,         -- custom system prompt (string or function)
                        format_summary = nil,        -- custom function to format generated summary e.g to remove <think/> tags from summary
                    },
                },

                -- Memory system (requires VectorCode CLI)
                memory = {
                    -- Automatically index summaries when they are generated
                    auto_create_memories_on_summary_generation = true,
                    -- Path to the VectorCode executable
                    vectorcode_exe = "vectorcode",
                    -- Tool configuration
                    tool_opts = {
                        -- Default number of memories to retrieve
                        default_num = 10
                    },
                    -- Enable notifications for indexing progress
                    notify = true,
                    -- Index all existing memories on startup
                    -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
                    index_on_startup = false,
                },
            }
        },
        vectorcode = {
            ---@type VectorCode.CodeCompanion.ExtensionOpts
            opts = {
                tool_group = {
                    -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
                    enabled = true,
                    -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
                    -- if you use @vectorcode_vectorise, it'll be very handy to include
                    -- `file_search` here.
                    extras = {},
                    collapse = false,             -- whether the individual tools should be shown in the chat
                },
                tool_opts = {
                    ---@type VectorCode.CodeCompanion.ToolOpts
                    ["*"] = {},
                    ---@type VectorCode.CodeCompanion.LsToolOpts
                    ls = {},
                    ---@type VectorCode.CodeCompanion.VectoriseToolOpts
                    vectorise = {},
                    ---@type VectorCode.CodeCompanion.QueryToolOpts
                    query = {
                        requires_approval = true,
                        max_num = { chunk = -1, document = -1 },
                        default_num = { chunk = 50, document = 10 },
                        include_stderr = false,
                        use_lsp = true,
                        no_duplicate = true,
                        chunk_mode = false,
                        ---@type VectorCode.CodeCompanion.SummariseOpts
                        summarise = {
                            ---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
                            enabled = false,
                            adapter = nil,
                            query_augmented = true,
                        },
                    },
                    files_ls = {},
                    files_rm = {},
                },
            },
        },
    }
}
