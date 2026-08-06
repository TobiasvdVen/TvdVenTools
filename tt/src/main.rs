pub mod args;
pub mod rust_commands;

use clap::Parser;

use crate::args::Args;
use crate::rust_commands::process_rust_command;

fn main()
{
    let args = Args::parse();

    let result = match &args.command
    {
        args::TtCommand::Rust { rust_command } => process_rust_command(rust_command)
    };

    if let Err(error) = result
    {
        eprintln!("{}", error);
    }
}
