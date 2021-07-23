#! /usr/bin/env elixir

# Author: Daniils Petrovs @danirukun

# This script patches markdown Elixir guide examples to Livebook.
# For example, you must force IEx examples to markdown blocks, since they cannot be evaluated in Livebook.

patch = fn file ->
  with {:ok, src_file} <- File.open(file, [:read, :utf8]),
       {:ok, dst_file} <- File.open(file <> "-new", [:write, :utf8]) do
	block_sep = "\n\n"
	
	is_iex_example? = fn block ->
	  block =~ "```elixir" and block =~ "iex>"
	end

	# Create a chain of blocks and patch
	patched_data = src_file
	|> IO.read(:all)
	|> String.split(block_sep)
	|> Enum.map(fn block ->
	  if is_iex_example?.(block) do
		"<!-- livebook:{\"force_markdown\":true} -->\n\n" <> block
	  else
		block
	  end
	end)
	|> Enum.join(block_sep)

	# dump the patched data to the new file
	:ok = IO.write(dst_file, patched_data)

	# perform cleanup
	File.close(src_file)
	File.close(dst_file)
	File.rm!(file)
	File.rename!(file <> "-new", file)

	IO.puts("File patched: " <> file)
  end
end

directory = "getting-started" # directory where to look for livemd files 
IO.puts("Attemping to read #{}")

files = File.ls!(directory)

File.cd!(directory)

files
|> Enum.filter(&(!(&1 =~ "DS_Store") && (&1 =~ "livemd")))
|> Enum.each(patch)
