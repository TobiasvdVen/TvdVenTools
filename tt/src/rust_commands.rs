use std::io;

use crate::args::RustCommand;

const CLIPPY_TOML: &str = include_str!("../clippy.toml");
const RUSTFMT_TOML: &str = include_str!("../rustfmt.toml");

pub fn process_rust_command(rust_command: &RustCommand) -> Result<(), io::Error>
{
    match rust_command
    {
        RustCommand::Config => process_config_command()
    }
}

fn process_config_command() -> Result<(), io::Error>
{
    std::fs::write("clippy.toml", CLIPPY_TOML)?;
    std::fs::write("rustfmt.toml", RUSTFMT_TOML)?;

    Ok(())
}
