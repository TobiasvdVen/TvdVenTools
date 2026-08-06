use clap::{Parser, Subcommand};

#[derive(Subcommand)]
pub enum TtCommand
{
    Rust
    {
        #[command(subcommand)]
        rust_command: RustCommand
    }
}

#[derive(Subcommand)]
pub enum RustCommand
{
    Config
}

#[derive(Parser)]
#[command(version, about, long_about = None)]
pub struct Args
{
    #[command(subcommand)]
    pub command: TtCommand
}
