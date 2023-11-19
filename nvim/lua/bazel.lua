-- Check the working directory for bazel directories and add them to the path.
-- This is useful for navigating to generated files with gf.
if vim.fn.isdirectory("bazel-genfiles") == 1 then
    vim.opt.path:append("bazel-genfiles")
end

if vim.fn.isdirectory("bazel-bin") == 1 then
    vim.opt.path:append("bazel-bin")
end
