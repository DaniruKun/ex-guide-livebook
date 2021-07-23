# Elixir language guide in Livebook

This project is a collection of Elixir Livebooks that are near 1:1 replicas of the official Elixir language guides. They have been auto-generated with a simple Elixir script.

## Acknowledgements

 - [Elixir lang website guide](https://github.com/elixir-lang/elixir-lang.github.com)
 - [Livebook](https://github.com/elixir-nx/livebook)
  
## Usage/Examples

1. Install and start a Livebook server as described [in the official docs](https://github.com/livebook-dev/livebook#usage)
2. Load a `.livemd` file in a running Livebook session and you can interactively run and modify Elixir code cells.

### Converting markdown to patched LiveMD

The conversion follows this sequence:

```
.md/.markdown file -> .livemd -> patch.exs -> patched .livemd
```

The [patch.exs script](patch.exs) script is necessary to do some small patches to MarkDown Elixir examples. For example, it doesn't make sense to convert IEx usage examples to eval cells, since this will never work.

