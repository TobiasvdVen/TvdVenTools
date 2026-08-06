use assert_cmd::{Command, pkg_name};
use tempfile::tempdir;

#[test]
fn rust_config_generates_clippy_and_rustfmt_toml()
{
    let working_directory = tempdir().unwrap();
    let mut command = Command::cargo_bin(pkg_name!()).unwrap();
    command.current_dir(&working_directory);

    command.args(["rust", "config"]).assert().success();

    assert!(working_directory.path().join("clippy.toml").exists());
    assert!(working_directory.path().join("rustfmt.toml").exists());
}
