use core::str;

use fancy_regex::{Error, Regex};
use wasm_minimal_protocol::*;

initiate_protocol!();

#[wasm_func]
pub fn regex_match(arg1: &[u8], arg2: &[u8]) -> Result<Vec<u8>, Box<Error>> {
    regex_match_impl(str::from_utf8(arg1).unwrap(), str::from_utf8(arg2).unwrap())
        .map(|b| vec![if b { 1 } else { 0 }])
}

fn regex_match_impl(re: &str, str: &str) -> Result<bool, Box<Error>> {
    let re = Regex::new(re)?;
    Ok(re.is_match(str)?)
}
