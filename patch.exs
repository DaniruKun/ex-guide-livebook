#! /usr/bin/env elixir

# Author: Daniils Petrovs @danirukun

# This script patches markdown Elixir guide examples to Livebook.

# Various helpers

is_iex_example? = fn block ->
  block =~ "```elixir" and block =~ "iex>"
end

force_markdown = fn block ->
  "<!-- livebook:{\"force_markdown\":true} -->\n\n" <> block
end

fmt_iex_block = fn block ->
  remove_prompts = fn line ->
    line
    |> String.replace("...>", "")
    |> String.replace("iex>", "")
  end

  if block =~ "iex>" do
    block
    |> String.split("\n")
    |> Stream.filter(&(&1 =~ "iex>" or &1 =~ "...>" or &1 =~ "```"))
    |> Stream.map(remove_prompts)
    |> Enum.join("\n")
  else
    block
  end
end

patch = fn file ->
  with {:ok, src_file} <- File.open(file, [:read, :utf8]),
       {:ok, dst_file} <- File.open(file <> "-new", [:write, :utf8]) do
    block_sep = "\n\n"

    # Create a chain of blocks and patch
    patched_data =
      src_file
      |> IO.read(:all)
      |> String.split(block_sep)
      |> Stream.map(fn block ->
        if is_iex_example?.(block) do
          fmt_iex_block.(block)
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

# actual patching entrypoint

# directory where to look for livemd files 
directory = "getting-started/mix-otp"
IO.puts("Attemping to read files in dir: #{directory}")

files = File.ls!(directory)

File.cd!(directory)

files
|> Stream.filter(&(!(&1 =~ "DS_Store") && &1 =~ "livemd"))
|> Enum.each(patch)
