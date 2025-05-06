## Development is not quite declarative

If types are missing, we might need to run `ags types .` which generates a `@girs` directory in `~/.config/ags` that is
needed for the language server to help us with autocompletion and stuff. So the `@girs` directory will need to be copied
into this directory. You might also have to run `npm install` for the `astal` package.
