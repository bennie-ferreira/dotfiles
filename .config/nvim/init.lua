-- ===== Bootstrap do lazy.nvim =====
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

-- ===== Plugins =====
require("lazy").setup({
	-- Barra de status
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					always_divide_middle = true,
					section_separators = "",
					component_separators = "",
				},
				sections = {
					lualine_c = { { "filename", file_status = true, path = 1 } },
				},
			})
		end,
	},

	-- Destaque de sintaxe
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- Git signs
	{
		"lewis6991/gitsigns.nvim",
		-- dependencies = { "lewis6991/satellite.nvim" },
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- lazy.nvim
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			terminal = {
				enabled = false,
			},
			explorer = {},
			picker = {
				sources = {
					explorer = {
						hidden = true, -- arquivos ocultos no picker também
						ignored = true,
					},
				},
			},
			indent = {
				animate = {
					enabled = vim.fn.has("nvim-0.10") == 1,
					style = "out",
					easing = "linear",
					duration = {
						step = 20, -- ms per step
						total = 500, -- maximum duration
					},
				},
			},
			dashboard = {
				sections = {
					{
						section = "terminal",
						cmd = "~/.config/asciiart/zfetch.sh",
						height = 17,
						width = 100,
						padding = 0,
					},
					-- { title = "NUX COMMANDS", padding = 1 },
					-- { section = "recent_files", limit = 8, padding = 1 },
				},
			},
			keys = {},
		},
	},

	-- Theme Tokyonight
	{
		"folke/tokyonight.nvim",
		config = function()
			require("tokyonight").setup({
				transparent = true,
				styles = {
					sidebars = "dark",
					floats = "dark",
					comments = { italic = true },
					keywords = { italic = true },
					functions = { italic = true },
					variables = { italic = true },
				},
			})
		end,
	},

	-- nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
	-- Mason nvim
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	-- Mason lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"pyright",
					"lua_ls",
					"clangd",
					"jdtls",
					"gopls",
					"rust_analyzer",
					"intelephense",
					"html",
					"cssls",
					"marksman",
					"jsonls",
					"yamlls",
					"bashls",
					"dockerls",
					"sqls",
					"kotlin_language_server",
					"terraformls",
				},
				automatic_installation = true,
			})
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			telescope.setup({})
		end,
	},

	-- Bufferline
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					numbers = "none",
					diagnostics = "nvim_lsp",
					show_buffer_close_icons = true,
					show_close_icon = true,
					separator_style = "slant",
					offsets = {
						{
							filetype = "NvimTree",
							text = "Explorer",
							highlight = "Directory",
							text_align = "left",
						},
					},
					highlights = {
						fill = { guibg = "#1a1b26" },
						background = { guibg = "#1a1b26" },
						buffer_selected = { guibg = "#414868" },
					},
				},
			})
		end,
	},

	-- Toogleterm
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 25, -- altura do terminal horizontal
				open_mapping = [[<C-t>]], -- atalho para abrir/fechar
				hidden = true,
				hide_numbers = true,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "float", -- "horizontal", "vertical" ou "float"
				close_on_exit = true,
				shell = vim.o.shell,
			})
		end,
	},

	-- Vim  Notify
	{
		"rcarriga/nvim-notify",
		config = function()
			local notify = require("notify")
			notify.setup({
				-- Options settings
				stages = "fade", -- animations: fade, slide, ou static
				timeout = 3000, -- time in ms
				max_height = function()
					return math.floor(vim.o.lines * 0.75)
				end,
				max_width = function()
					return math.floor(vim.o.columns * 0.75)
				end,
			})

			vim.notify = notify
		end,
	},

	-- Vim move
	{
		"matze/vim-move",
		config = function()
			vim.g.move_disable_defaults = 1
		end,
	},

	-- nvim-cursor-online
	{
		"yamatsum/nvim-cursorline",
		config = function()
			require("nvim-cursorline").setup({
				cursorline = {
					enable = true, -- habilita destaque da linha
					timeout = 1000, -- tempo em ms até sumir ao mover o cursor
					number = false, -- se true, também destaca o número da linha
				},
				cursorword = {
					enable = true, -- habilita destaque da palavra sob o cursor
					min_length = 3, -- tamanho mínimo da palavra
					hl = { underline = true }, -- como destacar
				},
			})
		end,
	},

	-- nvim-ufo
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
		config = function()
			-- Ativa o folding globalmente
			vim.o.foldcolumn = "3" -- mostra coluna de fold
			vim.o.foldlevel = 99 -- deixa todos os folds abertos por padrão
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
			vim.o.fillchars = "fold:,foldopen:,foldsep:│,diff:╱"
			vim.cmd("hi Folded guibg=#2e2e2e guifg=#aaaaaa")

			local ufo = require("ufo")

			-- Configuração básica
			ufo.setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
			})
		end,
	},

	-- barbecue.nvim
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic", -- precisa do navic
			"nvim-tree/nvim-web-devicons", -- ícones
		},
		config = function()
			require("barbecue").setup({
				create_autocmd = true, -- atualiza automaticamente quando mudar de buffer
				theme = "auto", -- pode usar "auto" ou escolher cores
			})
		end,
	},

	{
		"karb94/neoscroll.nvim",
		event = "WinScrolled",
		config = function()
			require("neoscroll").setup({
				hide_cursor = true,
				stop_eof = true,
				respect_scrolloff = false,
				cursor_scrolls_alone = true,
			})
		end,
	},

	-- nvim-noise
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				cmdline = {
					view = "cmdline_popup", -- popup moderno para :
				},
				messages = {
					view = "notify", -- usa nvim-notify
				},
				popupmenu = {
					enabled = true, -- substitui wildmenu
				},
				lsp = {
					progress = { enabled = true },
					hover = { enabled = true },
					signature = { enabled = true },
				},
				presets = {
					bottom_search = true, -- :/ ? para baixo
					command_palette = true, -- cmdline e menu no centro
					long_message_to_split = true, -- msgs longas em split
					inc_rename = false, -- precisa de inc-rename.nvim
					lsp_doc_border = true, -- borda em hover/signature
				},
			})
		end,
	},

	-- nvim comment
	{
		"numToStr/Comment.nvim",
		lazy = false,
		config = function()
			local api = require("Comment.api")

			require("Comment").setup({
				mappings = {
					basic = true,
					-- extra = false,
				},
			})

			-- Normal mode: Ctrl+; para comentar linha
			vim.keymap.set("n", "<C-;>", api.toggle.linewise.current, { noremap = true, silent = true })

			-- Visual mode: Ctrl+; para comentar seleção
			vim.keymap.set("v", "<C-;>", function()
				api.toggle.linewise(vim.fn.visualmode())
			end, { noremap = true, silent = true })
		end,
	},

	-- vim-multiple-cursors
	{
		"mg979/vim-visual-multi",
		lazy = false,
		config = function()
			vim.g.VM_highlight_matches = "Search"
		end,
	},

	-- yank nvim
	{
		"gbprod/yanky.nvim",
		lazy = false,
		config = function()
			require("yanky").setup({
				ring = {
					storage = "memory", -- armazena cópias na memória (não precisa de registro do Vim)
					history_length = 100,
				},
				highlight = {
					on_put = true, -- destaca quando colar
					on_yank = true, -- destaca quando copiar
				},
			})

			-- Atalhos estilo VSCode
			local map = vim.keymap.set
			-- Yank (copiar)
			map("n", "<C-c>", "y", { noremap = true, silent = true })
			map("v", "<C-c>", "y", { noremap = true, silent = true })

			-- Delete (recortar)
			map("n", "<C-x>", "d", { noremap = true, silent = true })
			map("v", "<C-x>", "d", { noremap = true, silent = true })

			-- Paste (colar)
			map("n", "<C-v>", "p", { noremap = true, silent = true })
			map("v", "<C-v>", "p", { noremap = true, silent = true })
		end,
	},

	-- barbar nvim
	{
		"romgrk/barbar.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = { "BufReadPre" },
		config = function()
			require("barbar").setup({
				animation = false,
				auto_hide = 0,
				sidebar_filetypes = {
					NvimTree = true,
					["snacks_layout_box"] = { event = "BufWipeout" },
				},
				icons = {
					filetype = {
						custom_icons = false,
					},
					pinned = { button = "", filename = true },
				},
			})
		end,
	},
})

-- ===== Configurações básicas do Neovim =====
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.relativenumber = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.termguicolors = true

-- Opções do mapeamento
local opts = { noremap = true, silent = true }

-- Buscar arquivos (Ctrl+P)
vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>Telescope find_files<cr>", opts)

-- Buscar texto no projeto
vim.api.nvim_set_keymap("n", "<C-A-f>", "<cmd>Telescope live_grep<cr>", opts)

-- Alternar buffers (Ctrl+Tab)
vim.api.nvim_set_keymap("n", "<C-Tab>", "<cmd>Telescope buffers<cr>", opts)

-- Comando (Command Palette) Ctrl+Shift+P
vim.api.nvim_set_keymap("n", "<C-S-p>", "<cmd>Telescope commands<cr>", opts)

-- Abrir terminal como floating window (Ctrl+T)
vim.api.nvim_set_keymap("n", "<C-t>", ":ToggleTerm direction=float<CR>", opts)

-- Abrir terminal horizontal (Ctrl+Shift+T)
vim.api.nvim_set_keymap("n", "<C-S-t>", ":ToggleTerm direction=horizontal<CR>", opts)

-- Desfazer com Ctrl + Z no modo normal
-- vim.api.nvim_set_keymap("n", "<C-z>", "u", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-z>", "u", { noremap = true, silent = true })

-- Refazer com Ctrl + Shift + Z (opcional)
vim.api.nvim_set_keymap("n", "<C-y>", "<C-r>", { noremap = true, silent = true })

-- Modo normal: Tab = indentar, Shift+Tab = desindentar
vim.api.nvim_set_keymap("n", "<Tab>", ">>", opts)
vim.api.nvim_set_keymap("n", "<S-Tab>", "<<", opts)

-- Modo visual: Tab = indentar seleção, Shift+Tab = desindentar seleção
vim.api.nvim_set_keymap("v", "<Tab>", ">gv", opts)
vim.api.nvim_set_keymap("v", "<S-Tab>", "<gv", opts)

-- Modo normal: mover a linha atual
vim.api.nvim_set_keymap("n", "<A-Up>", "<Plug>MoveLineUp", opts)
vim.api.nvim_set_keymap("n", "<A-Down>", "<Plug>MoveLineDown", opts)
vim.api.nvim_set_keymap("n", "<A-Left>", "<Plug>MoveHCharLeft", opts)
vim.api.nvim_set_keymap("n", "<A-Right>", "<Plug>MoveHCharRight", opts)

-- Modo visual: mover o bloco selecionado
vim.api.nvim_set_keymap("v", "<A-Up>", "<Plug>MoveBlockUp", opts)
vim.api.nvim_set_keymap("v", "<A-Down>", "<Plug>MoveBlockDown", opts)
vim.api.nvim_set_keymap("v", "<A-Left>", "<Plug>MoveHBlockLeft", opts)
vim.api.nvim_set_keymap("v", "<A-Right>", "<Plug>MoveHBlockRight", opts)

-- Desabilitar teclas no modo normal
vim.api.nvim_set_keymap("n", "j", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "k", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "h", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "h", "<Nop>", { noremap = true, silent = true })

-- Desabilitar J/K/H/L no modo visual
vim.api.nvim_set_keymap("v", "j", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "k", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "h", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "l", "<Nop>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("v", "<C-d>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-d>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-d>", "<Nop>", { noremap = true, silent = true })

-- Modo normal
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", opts)

-- Modo insert (mantém você no insert depois de salvar)
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>a", opts)

-- Modo visual
vim.api.nvim_set_keymap("v", "<C-s>", "<Esc>:w<CR>gv", opts)

-- Normal mode: Ctrl+A → seleciona todo o buffer
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- Ctrl+K W → fecha todos os buffers, incluindo o atual
-- vim.api.nvim_set_keymap("n", "<C-k>w", ":bufdo bd!<CR>", { noremap = true, silent = true })

-- Ctrl + B
vim.keymap.set("n", "<A-b>", function()
	require("snacks").picker.explorer()
end, { desc = "Toggle Snacks Explorer" })

-- Atalho Ctrl+F para buscar palavras no buffer atual
vim.keymap.set("n", "<C-f>", function()
	require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "Buscar palavra no buffer atual" })

-- Tema
-- vim.cmd("colorscheme tokyonight")
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd([[colorscheme tokyonight]])  -- use o seu tema favorito

--- comandos uteis para colocar atalho
--- Telescope git_commits -- historico de commits
--- Telescope git_status -- arquivos modificados

--- comando htop pra ver depois
local Terminal = require("toggleterm.terminal").Terminal

local term = Terminal:new({
	hidden = false,
	close_on_exit = true,
	direction = "float",
})

local function run_cmd(cmd)
	term:toggle()
	vim.defer_fn(function()
		term:send(cmd)
	end, 50)
end

vim.api.nvim_create_user_command("Run", function(opts)
	run_cmd(opts.args)
end, { nargs = 1 })
