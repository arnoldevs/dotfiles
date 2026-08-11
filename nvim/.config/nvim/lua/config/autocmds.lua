-- =====================================================================
-- Global Autocommands
-- Event-driven actions for UI feedback, buffer state, and utility windows.
-- =====================================================================

local function augroup(name)
return vim.api.nvim_create_augroup("nvim_" .. name, { clear = true })
end

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("yank_highlight"),
							callback = function()
							vim.highlight.on_yank({ timeout = 200 })
							end,
})

-- Restore last cursor position when opening buffers
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("restore_cursor"),
							callback = function(event)
							local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
							local line_count = vim.api.nvim_buf_line_count(event.buf)
							if mark[1] > 0 and mark[1] <= line_count then
								pcall(vim.api.nvim_win_set_cursor, 0, mark)
								end
								end,
})

-- Equalize splits when terminal window is resized
vim.api.nvim_create_autocmd("VimResized", {
	group = augroup("resize_splits"),
							callback = function()
							local current_tab = vim.fn.tabpagenr()
							vim.cmd("tabdo wincmd =")
							vim.cmd("tabnext " .. current_tab)
							end,
})

-- Close ephemeral utility buffers with 'q'
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
							pattern = {
								"checkhealth",
								"gitsigns-blame",
								"help",
								"lspinfo",
								"man",
								"notify",
								"qf",
								"spectre_panel",
								"startuptime",
								"trouble",
							},
							callback = function(event)
							vim.bo[event.buf].buflisted = false
							vim.keymap.set("n", "q", "<cmd>close<cr>", {
								buffer = event.buf,
								silent = true,
								desc = "Quit utility buffer",
							})
							end,
})
